///|
fn binder(
  o : Map[String, Value],
  prefix : String,
  min_args : Int32,
  max_args : Int32,
) -> (String, Array[String]) raise TemplateError {
  let keys = o.keys().filter(k => k.has_prefix(prefix + "(")).collect()
  if keys.length() != 1 {
    raise Invalid("exactly one binding property required")
  }
  let k = keys[0]
  if !k.has_suffix(")") {
    raise Invalid("malformed binding property")
  }
  let names = k[prefix.length() + 1:k.length() - 1]
    .to_string()
    .split(",")
    .map(x => x.trim().to_string())
    .collect()
  if names.length() < min_args || names.length() > max_args {
    raise Invalid("invalid binding argument count")
  }
  for name in names {
    if !identifier(name) {
      raise Invalid("invalid variable name")
    }
  }
  (k, names)
}

///|
fn render_collection(
  op : String,
  o : Map[String, Value],
  env : Map[String, Value],
  b : Budget,
  depth : Int32,
) -> Value raise TemplateError {
  let is_reduce = op == "$reduce"
  let (key, names) = binder(
    o,
    "each",
    if is_reduce {
      2
    } else {
      1
    },
    if is_reduce {
      3
    } else {
      2
    },
  )
  allowed(o, if is_reduce { [op, key, "initial"] } else { [op, key] })
  let body = required(o, key)
  if op == "$find" && !(body is Text(_)) {
    raise Invalid("find predicate must be expression string")
  }
  let value = render_value(required(o, op), env, b, depth + 1)
  let mut object_input = false
  let values = match value {
    Sequence(xs) => xs.map(x => (Nil, x))
    Record(obj) => {
      if op != "$map" {
        raise Invalid("operator requires array")
      }
      object_input = true
      obj.iter().map(pair => (Text(pair.0), pair.1)).collect()
    }
    _ => raise Invalid("map requires array or object")
  }
  let out = []
  let mapped = Map([])
  let mut acc = if is_reduce { required(o, "initial") } else { Nil }
  for i, pair in values {
    b.tick(depth)
    let child = env.copy()
    let item = pair.1
    if is_reduce {
      child[names[0]] = acc
      child[names[1]] = item
      if names.length() == 3 {
        child[names[2]] = Numeric(i.to_double())
      }
    } else if object_input {
      if names.length() == 1 {
        child[names[0]] = Record(Map([("key", pair.0), ("val", item)]))
      } else {
        child[names[0]] = item
        child[names[1]] = pair.0
      }
    } else {
      child[names[0]] = item
      if names.length() == 2 {
        child[names[1]] = Numeric(i.to_double())
      }
    }
    if op == "$find" {
      if truth(eval_source(string_value(body), child, b)) {
        return render_value(item, child, b, depth + 1)
      }
      continue
    }
    let result = render_value(body, child, b, depth + 1)
    if result == Omit {
      continue
    }
    if is_reduce {
      acc = result
    } else if object_input {
      match result {
        Record(obj) =>
          for k, v in obj {
            mapped[k] = v
          }
        _ => raise Invalid("object map body must return object")
      }
    } else {
      out.push(result)
    }
  }
  if is_reduce {
    acc
  } else if op == "$find" {
    Omit
  } else if object_input {
    Record(mapped)
  } else {
    Sequence(out)
  }
}

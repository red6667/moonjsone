///|
fn array_value(v : Value) -> Array[Value] raise TemplateError {
  match v {
    Sequence(xs) => xs
    _ => raise Invalid("expected array")
  }
}

///|
fn merge_values(
  left : Value,
  right : Value,
  deep : Bool,
  b : Budget,
  depth : Int32,
) -> Value raise TemplateError {
  b.tick(depth)
  match (left, right) {
    (Record(a), Record(c)) => {
      let out = a.copy()
      for k, v in c {
        out[k] = if deep {
          match out.get(k) {
            Some(old) => merge_values(old, v, true, b, depth + 1)
            None => v
          }
        } else {
          v
        }
        b.items(out.length())
      }
      Record(out)
    }
    (Sequence(a), Sequence(c)) =>
      if deep {
        b.items(a.length() + c.length())
        Sequence(a + c)
      } else {
        right
      }
    _ => right
  }
}

///|
fn flatten_into(
  v : Value,
  out : Array[Value],
  deep : Bool,
  b : Budget,
  depth : Int32,
) -> Unit raise TemplateError {
  b.tick(depth)
  match v {
    Sequence(xs) =>
      for x in xs {
        if deep {
          flatten_into(x, out, true, b, depth + 1)
        } else {
          out.push(x)
        }
        b.items(out.length())
      }
    _ => {
      out.push(v)
      b.items(out.length())
    }
  }
}

///|
fn sort_template(
  o : Map[String, Value],
  env : Map[String, Value],
  b : Budget,
  depth : Int32,
) -> Value raise TemplateError {
  let keys = o.keys().filter(k => k.has_prefix("by(")).collect()
  let binding = if keys.is_empty() { None } else { Some(binder(o, "by", 1, 1)) }
  allowed(
    o,
    match binding {
      Some((k, _)) => ["$sort", k]
      None => ["$sort"]
    },
  )
  let values = array_value(
    render_value(required(o, "$sort"), env, b, depth + 1),
  )
  let pairs : Array[(Value, Value)] = []
  for value in values {
    let sort_key = match binding {
      Some((key, names)) => {
        let child = env.copy()
        child[names[0]] = value
        eval_source(string_value(required(o, key)), child, b)
      }
      None => value
    }
    if !(sort_key is Numeric(_) || sort_key is Text(_)) {
      raise Invalid("sort key must be number or string")
    }
    if !pairs.is_empty() {
      ignore(compare_values(pairs[0].0, sort_key))
    }
    pairs.push((sort_key, value))
  }
  // Bottom-up merge sort preserves equal-key input order and bounded O(n log n) work.
  let mut width = 1
  let mut source = pairs
  while width < source.length() {
    let target = []
    let mut begin = 0
    while begin < source.length() {
      let middle = Int32::min(begin + width, source.length())
      let end = Int32::min(begin + 2 * width, source.length())
      let mut left = begin
      let mut right = middle
      while left < middle || right < end {
        b.tick(depth)
        if right == end ||
          (
            left < middle &&
            compare_values(source[left].0, source[right].0) <= 0
          ) {
          target.push(source[left])
          left += 1
        } else {
          target.push(source[right])
          right += 1
        }
      }
      begin = end
    }
    source = target
    width *= 2
  }
  Sequence(source.map(x => x.1))
}

///|
fn canonical(
  v : Value,
  b : Budget,
  depth : Int32,
) -> String raise TemplateError {
  b.tick(depth)
  match v {
    Record(o) => {
      let keys = o.keys().collect()
      keys.sort()
      let parts = []
      for k in keys {
        let v = required(o, k)
        if v == Omit {
          continue
        }
        parts.push(
          Json::string(k).stringify() + ":" + canonical(v, b, depth + 1),
        )
      }
      "{" + parts.join(",") + "}"
    }
    Sequence(xs) =>
      "[" +
      xs.filter(x => x != Omit).map(x => canonical(x, b, depth + 1)).join(",") +
      "]"
    Numeric(_) => text(v)
    _ => to_json(v, b, depth + 1).stringify()
  }
}

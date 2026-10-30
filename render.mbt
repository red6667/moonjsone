///|
let operator_names : Array[String] = ["$eval", "$if", "$let"]

///|
fn interpolate(
  s : String,
  env : Map[String, Value],
  b : Budget,
) -> String raise TemplateError {
  let out = StringBuilder::new()
  let mut size = 0
  let mut i = 0
  while i < s.length() {
    b.tick(0)
    if i + 3 <= s.length() && s[i:i + 3] == "$${" {
      out.write_string("${")
      size += 2
      i += 3
    } else if i + 2 <= s.length() && s[i:i + 2] == "${" {
      let source = s[i + 2:].to_string()
      let p = { tokens: tokenize(source, b), pos: 0, budget: b, }
      let e = p.expr(1, 0)
      let end = p.take("}").offset
      let value = evaluate(e, env, b, 0)
      let part = if value == Nil { "" } else { text(value) }
      out.write_string(part)
      size += part.length()
      i += end + 3
    } else {
      out.write_string(s[i:i + 1].to_string())
      size += 1
      i += 1
    }
    b.items(size)
  }
  out.to_string()
}

///|
fn allowed(
  o : Map[String, Value],
  keys : Array[String],
) -> Unit raise TemplateError {
  for k, _ in o {
    if !keys.contains(k) {
      raise Invalid("unexpected operator property: " + k)
    }
  }
}

///|
fn required(o : Map[String, Value], k : String) -> Value raise TemplateError {
  match o.get(k) {
    Some(v) => v
    None => raise Invalid("missing operator property: " + k)
  }
}

///|
fn render_value(
  v : Value,
  env : Map[String, Value],
  b : Budget,
  depth : Int32,
) -> Value raise TemplateError {
  b.tick(depth)
  match v {
    Text(s) => Text(interpolate(s, env, b))
    Sequence(xs) => {
      let out = []
      for x in xs {
        let v = render_value(x, env, b, depth + 1)
        if v != Omit {
          out.push(v)
        }
      }
      Sequence(out)
    }
    Record(o) => {
      let ops = o.keys().filter(k => operator_names.contains(k)).collect()
      if ops.length() > 1 {
        raise Invalid("only one operator is allowed")
      }
      if ops.length() == 1 {
        return render_operator(ops[0], o, env, b, depth + 1)
      }
      let out = Map([])
      for k, v in o {
        let key = if k.has_prefix("$$") {
          k[1:].to_string()
        } else {
          if k.has_prefix("$") && identifier(k[1:].to_string()) {
            raise Invalid("reserved dollar property")
          }
          interpolate(k, env, b)
        }
        let value = render_value(v, env, b, depth + 1)
        if value != Omit {
          out[key] = value
        }
      }
      Record(out)
    }
    _ => v
  }
}

///|
fn render_operator(
  op : String,
  o : Map[String, Value],
  env : Map[String, Value],
  b : Budget,
  depth : Int32,
) -> Value raise TemplateError {
  b.tick(depth)
  match op {
    "$eval" => {
      allowed(o, [op])
      eval_source(string_value(required(o, op)), env, b)
    }
    "$if" => {
      allowed(o, [op, "then", "else"])
      let condition = eval_source(string_value(required(o, op)), env, b)
      let branch = if truth(condition) { "then" } else { "else" }
      match o.get(branch) {
        Some(v) => render_value(v, env, b, depth + 1)
        None => Omit
      }
    }
    "$let" => {
      allowed(o, [op, "in"])
      if !(required(o, op) is Record(_)) {
        raise Invalid("$let requires literal object")
      }
      let bindings = render_value(required(o, op), env, b, depth + 1)
      let child = env.copy()
      match bindings {
        Record(values) =>
          for k, v in values {
            if !identifier(k) {
              raise Invalid("invalid let binding")
            }
            child[k] = v
          }
        _ => raise Invalid("let bindings must render object")
      }
      render_value(required(o, "in"), child, b, depth + 1)
    }
    _ => raise Invalid("unknown template operator")
  }
}

///|
/// Render a JSON-e template. Clock injection keeps generated documents reproducible.
pub fn render(
  template : Json,
  context : Json,
  now~ : String = "1970-01-01T00:00:00.000Z",
  max_steps~ : Int32 = 1000000,
  max_depth~ : Int32 = 128,
  max_items~ : Int32 = 100000,
) -> Json raise TemplateError {
  if max_steps < 1 || max_depth < 1 || max_depth > 256 || max_items < 1 {
    raise Invalid("invalid resource limits")
  }
  let b = { remaining: max_steps, max_depth, max_items, }
  let env = environment(context, b, now)
  let source = from_json(template, b, 0)
  to_json(render_value(source, env, b, 0), b, 0)
}

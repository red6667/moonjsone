///|
let builtin_names : Array[String] = [
  "lowercase", "uppercase", "strip", "lstrip", "rstrip", "len", "str", "number",
  "join", "split", "typeof", "defined", "min", "max", "sqrt", "abs", "ceil", "floor",
  "range", "fromNow",
]

///|
fn environment(
  context : Json,
  b : Budget,
  now : String,
) -> Map[String, Value] raise TemplateError {
  let env = Map([])
  for name in builtin_names {
    env[name] = Function(name)
  }
  env["now"] = Text(now)
  match from_json(context, b, 0) {
    Record(o) =>
      for k, v in o {
        if !identifier(k) {
          raise Invalid("invalid context key: " + k)
        }
        env[k] = v
      }
    _ => raise Invalid("context must be an object")
  }
  env
}

///|
fn arity(
  args : Array[Value],
  minimum : Int32,
  maximum : Int32,
) -> Unit raise TemplateError {
  if args.length() < minimum || args.length() > maximum {
    raise Invalid("invalid builtin argument count")
  }
}

///|
fn builtin(
  name : String,
  args : Array[Value],
  env : Map[String, Value],
  b : Budget,
) -> Value raise TemplateError {
  b.tick(0)
  match name {
    "min" | "max" => {
      arity(args, 1, b.max_items)
      let mut result = numeric(args[0])
      for x in args {
        let n = numeric(x)
        if (name == "min" && n < result) || (name == "max" && n > result) {
          result = n
        }
      }
      Numeric(result)
    }
    "abs" | "sqrt" | "ceil" | "floor" => {
      arity(args, 1, 1)
      let n = numeric(args[0])
      let result = match name {
        "abs" => if n < 0 { -n } else { n }
        "ceil" => @math.ceil(n)
        "floor" => @math.floor(n)
        _ => {
          if n < 0 {
            raise Invalid("sqrt of negative number")
          }
          n.sqrt()
        }
      }
      Numeric(result)
    }
    "range" => {
      arity(args, 2, 3)
      let start = index_value(args[0])
      let stop = index_value(args[1])
      let step = if args.length() == 3 { index_value(args[2]) } else { 1 }
      if step == 0 {
        raise Invalid("range step is zero")
      }
      let out = []
      let mut n = start.to_double()
      while (step > 0 && n < stop.to_double()) ||
            (step < 0 && n > stop.to_double()) {
        b.tick(0)
        b.items(out.length() + 1)
        out.push(Numeric(n))
        n += step.to_double()
      }
      Sequence(out)
    }
    "lowercase" | "uppercase" | "strip" | "lstrip" | "rstrip" => {
      arity(args, 1, 1)
      let s = string_value(args[0])
      Text(
        match name {
          "lowercase" => s.to_lower()
          "uppercase" => s.to_upper()
          "strip" => s.trim(chars=" \t\n\r\u{0b}\u{0c}").to_string()
          "lstrip" => s.trim_start(chars=" \t\n\r\u{0b}\u{0c}").to_string()
          _ => s.trim_end(chars=" \t\n\r\u{0b}\u{0c}").to_string()
        },
      )
    }
    "len" => {
      arity(args, 1, 1)
      let n = match args[0] {
        Text(s) => s.to_array().length()
        Sequence(xs) => xs.length()
        _ => raise Invalid("len requires string or array")
      }
      Numeric(n.to_double())
    }
    "str" => {
      arity(args, 1, 1)
      Text(text(args[0]))
    }
    "number" => {
      arity(args, 1, 1)
      let s = string_value(args[0]).trim().to_string()
      let n = @string.parse_double(s[:]) catch {
        _ => raise Invalid("invalid numeric string")
      }
      if n.is_nan() || n.is_inf() {
        raise Invalid("non-finite number")
      }
      Numeric(n)
    }
    "join" => {
      arity(args, 2, 2)
      let sep = string_or_number(args[1])
      let xs = match args[0] {
        Sequence(xs) => xs
        _ => raise Invalid("join requires array")
      }
      let out = StringBuilder::new()
      let mut size = 0
      for i, x in xs {
        if i > 0 {
          out.write_string(sep)
        }
        let part = string_or_number(x)
        size += part.length() + (if i > 0 { sep.length() } else { 0 })
        b.items(size)
        out.write_string(part)
      }
      Text(out.to_string())
    }
    "split" => {
      arity(args, 2, 2)
      let s = string_value(args[0])
      let sep = string_or_number(args[1])
      let parts = if sep == "" {
        s.to_array().map(c => Text(c.to_string()))
      } else {
        s.split(sep[:]).map(x => Text(x.to_string())).collect()
      }
      b.items(parts.length())
      Sequence(parts)
    }
    "typeof" => {
      arity(args, 1, 1)
      Text(
        match args[0] {
          Nil | Omit => "null"
          Boolean(_) => "boolean"
          Numeric(_) => "number"
          Text(_) => "string"
          Sequence(_) => "array"
          Record(_) => "object"
          Function(_) => "function"
        },
      )
    }
    "defined" => {
      arity(args, 1, 1)
      Boolean(env.contains(string_value(args[0])))
    }
    "fromNow" => {
      arity(args, 1, 2)
      let reference = if args.length() == 2 {
        string_value(args[1])
      } else {
        string_value(env.get("now").or(Nil))
      }
      Text(relative_time(string_value(args[0]), reference, b))
    }
    _ => raise Invalid("unknown builtin: " + name)
  }
}

///|
/// Evaluate an expression with strict JSON-e types and explicit resource limits.
/// The default clock is deterministic; pass now or a context now value for real time.
pub fn evaluate_expression(
  source : String,
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
  to_json(eval_source(source, env, b), b, 0)
}

///|
fn string_or_number(v : Value) -> String raise TemplateError {
  match v {
    Text(_) | Numeric(_) => text(v)
    _ => raise Invalid("expected string or number")
  }
}

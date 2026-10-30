///|
let builtin_names : Array[String] = [
  "min", "max", "sqrt", "abs", "ceil", "floor", "range",
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
  _env : Map[String, Value],
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

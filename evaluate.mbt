///|
fn compare_values(a : Value, b : Value) -> Int32 raise TemplateError {
  match (a, b) {
    (Numeric(x), Numeric(y)) => if x < y { -1 } else if x > y { 1 } else { 0 }
    (Text(x), Text(y)) => lexical(x, y)
    _ => raise Invalid("comparison requires two numbers or two strings")
  }
}

///|
fn arithmetic(op : String, a : Value, b : Value) -> Value raise TemplateError {
  if op == "+" {
    match (a, b) {
      (Text(x), Text(y)) => return Text(x + y)
      _ => ()
    }
  }
  let x = numeric(a)
  let y = numeric(b)
  let n = match op {
    "+" => x + y
    "-" => x - y
    "*" => x * y
    "/" => {
      if y == 0 {
        raise Invalid("division by zero")
      }
      x / y
    }
    "**" => @math.pow(x, y)
    _ => raise Invalid("unknown arithmetic operator")
  }
  if n.is_inf() || n.is_nan() {
    raise Invalid("non-finite arithmetic")
  }
  Numeric(n)
}

///|
fn evaluate(
  e : Expr,
  env : Map[String, Value],
  b : Budget,
  depth : Int32,
) -> Value raise TemplateError {
  b.tick(depth)
  match e {
    Literal(v) => v
    Name(name) =>
      match env.get(name) {
        Some(v) => v
        None => raise Invalid("unknown context value: " + name)
      }
    Unary(op, x) => {
      let v = evaluate(x, env, b, depth + 1)
      match op {
        "!" => Boolean(!truth(v))
        "+" => Numeric(numeric(v))
        "-" => Numeric(-numeric(v))
        _ => raise Invalid("unknown unary operator")
      }
    }
    Binary(op, left, right) => {
      let a = evaluate(left, env, b, depth + 1)
      if op == "||" && truth(a) {
        return Boolean(true)
      }
      if op == "&&" && !truth(a) {
        return Boolean(false)
      }
      let c = evaluate(right, env, b, depth + 1)
      match op {
        "+" | "-" | "*" | "/" | "**" => arithmetic(op, a, c)
        "||" | "&&" => Boolean(truth(c))
        "in" => {
          let found = match c {
            Sequence(xs) => xs.contains(a)
            Record(o) => o.contains(string_value(a))
            Text(s) => s.contains(string_value(a)[:])
            _ =>
              raise Invalid(
                "right operand of in must be array, string or object",
              )
          }
          Boolean(found)
        }
        "==" => Boolean(a == c)
        "!=" => Boolean(a != c)
        "<" => Boolean(compare_values(a, c) < 0)
        ">" => Boolean(compare_values(a, c) > 0)
        "<=" => Boolean(compare_values(a, c) <= 0)
        ">=" => Boolean(compare_values(a, c) >= 0)
        _ => raise Invalid("operator not available")
      }
    }
    Items(xs) => {
      b.items(xs.length())
      Sequence(xs.map(x => evaluate(x, env, b, depth + 1)))
    }
    Fields(fields) => {
      let out = Map([])
      for (k, v) in fields {
        out[k] = evaluate(v, env, b, depth + 1)
      }
      Record(out)
    }
    Access(base, key, dot) => {
      let v = evaluate(base, env, b, depth + 1)
      let k = evaluate(key, env, b, depth + 1)
      match v {
        Record(o) =>
          match o.get(string_value(k)) {
            Some(x) => x
            None =>
              if dot {
                raise Invalid("missing object property")
              } else {
                Nil
              }
          }
        Sequence(xs) => {
          if dot {
            raise Invalid("dot access requires object")
          }
          let i = index_value(k)
          let i = if i < 0 { xs.length() + i } else { i }
          if i < 0 || i >= xs.length() {
            raise Invalid("index out of bounds")
          }
          xs[i]
        }
        Text(s) => {
          if dot {
            raise Invalid("dot access requires object")
          }
          let xs = s.to_array()
          let i = index_value(k)
          let i = if i < 0 { xs.length() + i } else { i }
          if i < 0 || i >= xs.length() {
            raise Invalid("index out of bounds")
          }
          Text(xs[i].to_string())
        }
        _ => raise Invalid("access requires collection")
      }
    }
    Slice(base, start, end) => {
      let v = evaluate(base, env, b, depth + 1)
      let lo = start.map(x => index_value(evaluate(x, env, b, depth + 1)))
      let hi = end.map(x => index_value(evaluate(x, env, b, depth + 1)))
      match v {
        Sequence(xs) => {
          let l = slice_bound(lo, 0, xs.length())
          let h = slice_bound(hi, xs.length(), xs.length())
          let out = []
          for i = l; i < h; i = i + 1 {
            out.push(xs[i])
          }
          Sequence(out)
        }
        Text(s) => {
          let xs = s.to_array()
          let l = slice_bound(lo, 0, xs.length())
          let h = slice_bound(hi, xs.length(), xs.length())
          let out = StringBuilder()
          for i = l; i < h; i = i + 1 {
            out.write_char(xs[i])
          }
          Text(out.to_string())
        }
        _ => raise Invalid("slice requires string or array")
      }
    }
    Call(fnexpr, args) => {
      let func = evaluate(fnexpr, env, b, depth + 1)
      let args = args.map(x => evaluate(x, env, b, depth + 1))
      match func {
        Function(name) => builtin(name, args, env, b)
        _ => raise Invalid("value is not callable")
      }
    }
  }
}

///|
fn eval_source(
  s : String,
  env : Map[String, Value],
  b : Budget,
) -> Value raise TemplateError {
  evaluate(parse_expr(s, b), env, b, 0)
}

///|
fn index_value(v : Value) -> Int32 raise TemplateError {
  let n = numeric(v)
  if n < -2147483647 || n > 2147483647 || n != n.to_int().to_double() {
    raise Invalid("index must be a bounded integer")
  }
  n.to_int()
}

///|
fn slice_bound(v : Int32?, default : Int32, size : Int32) -> Int32 {
  let i = v.unwrap_or(default)
  let i = if i < 0 { size + i } else { i }
  if i < 0 {
    0
  } else if i > size {
    size
  } else {
    i
  }
}

///|
fn lexical(a : String, b : String) -> Int32 {
  let xs = a.to_array()
  let ys = b.to_array()
  for i = 0; i < Int32::min(xs.length(), ys.length()); i = i + 1 {
    let x = xs[i].to_int()
    let y = ys[i].to_int()
    if x < y {
      return -1
    }
    if x > y {
      return 1
    }
  }
  xs.length().compare(ys.length())
}

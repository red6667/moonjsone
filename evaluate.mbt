///|
fn compare_values(a : Value, b : Value) -> Int32 raise TemplateError {
  match (a, b) {
    (Numeric(x), Numeric(y)) => if x < y { -1 } else if x > y { 1 } else { 0 }
    (Text(x), Text(y)) => x.compare(y)
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
    _ => raise Invalid("expression not available")
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

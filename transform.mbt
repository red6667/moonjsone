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

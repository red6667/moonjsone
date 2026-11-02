///|
/// Interpreter failures have a stable category and diagnostic message.
pub suberror TemplateError {
  Invalid(String)
  Limit(String)
} derive(Debug)

///|
pub extend TemplateError with @moonbitlang/core/debug.Debug::{to_repr}

///|
priv enum Value {
  Nil
  Boolean(Bool)
  Numeric(Double)
  Text(String)
  Sequence(Array[Value])
  Record(Map[String, Value])
  Function(String)
  Omit
} derive(Eq, Debug)

///|
priv struct Budget {
  mut remaining : Int32
  max_depth : Int32
  max_items : Int32
}

///|
fn Budget::tick(self : Budget, depth : Int32) -> Unit raise TemplateError {
  if depth > self.max_depth {
    raise Limit("maximum nesting depth")
  }
  self.remaining -= 1
  if self.remaining < 0 {
    raise Limit("evaluation step budget exhausted")
  }
}

///|
fn Budget::items(self : Budget, size : Int32) -> Unit raise TemplateError {
  if size > self.max_items {
    raise Limit("collection size limit")
  }
}

///|
fn from_json(j : Json, b : Budget, depth : Int32) -> Value raise TemplateError {
  b.tick(depth)
  match j {
    Null => Nil
    True => Boolean(true)
    False => Boolean(false)
    Number(n, ..) => Numeric(n)
    String(s) => {
      b.items(s.length())
      Text(s)
    }
    Array(a) => {
      b.items(a.length())
      Sequence(a.map(x => from_json(x, b, depth + 1)))
    }
    Object(o) => {
      b.items(o.length())
      let out = Map([])
      for k, v in o {
        out[k] = from_json(v, b, depth + 1)
      }
      Record(out)
    }
  }
}

///|
fn to_json(v : Value, b : Budget, depth : Int32) -> Json raise TemplateError {
  b.tick(depth)
  match v {
    Nil | Omit => Json::null()
    Boolean(x) => Json::boolean(x)
    Numeric(n) => {
      if n.is_nan() || n.is_inf() {
        raise Invalid("non-finite result")
      }
      Json::number(n)
    }
    Text(s) => {
      b.items(s.length())
      Json::string(s)
    }
    Sequence(a) => {
      b.items(a.length())
      Json::array(a.filter(x => x != Omit).map(x => to_json(x, b, depth + 1)))
    }
    Record(o) => {
      let out = Map([])
      b.items(o.length())
      for k, v in o {
        if v != Omit {
          out[k] = to_json(v, b, depth + 1)
        }
      }
      Json::object(out)
    }
    Function(_) => raise Invalid("uncalled function in output")
  }
}

///|
fn truth(v : Value) -> Bool {
  match v {
    Nil | Omit => false
    Boolean(b) => b
    Numeric(n) => n != 0 && !n.is_nan()
    Text(s) => s != ""
    Sequence(a) => !a.is_empty()
    Record(o) => !o.is_empty()
    Function(_) => true
  }
}

///|
fn text(v : Value) -> String raise TemplateError {
  match v {
    Nil => "null"
    Boolean(b) => if b { "true" } else { "false" }
    Text(s) => s
    Numeric(n) =>
      if n == 0 {
        "0"
      } else if n >= -2147483648.0 &&
        n <= 2147483647.0 &&
        n == n.to_int().to_double() {
        n.to_int().to_string()
      } else {
        n.to_string()
      }
    _ => raise Invalid("expected scalar")
  }
}

///|
fn numeric(v : Value) -> Double raise TemplateError {
  match v {
    Numeric(n) => n
    _ => raise Invalid("expected number")
  }
}

///|
fn string_value(v : Value) -> String raise TemplateError {
  match v {
    Text(s) => s
    _ => raise Invalid("expected string")
  }
}

///|
fn identifier(s : String) -> Bool {
  if s.is_empty() {
    return false
  }
  for i = 0; i < s.length(); i = i + 1 {
    let c = s.code_unit_at(i).to_int()
    if !((c >= 65 && c <= 90) ||
      (c >= 97 && c <= 122) ||
      c == 95 ||
      (i > 0 && c >= 48 && c <= 57)) {
      return false
    }
  }
  true
}

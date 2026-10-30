///|
priv enum Expr {
  Literal(Value)
  Name(String)
  Unary(String, Expr)
  Binary(String, Expr, Expr)
  Items(Array[Expr])
  Fields(Array[(String, Expr)])
} derive(Eq, Debug)

///|
priv struct Parser {
  tokens : Array[Token]
  mut pos : Int32
  budget : Budget
}

///|
fn Parser::kind(self : Parser) -> String {
  self.tokens[self.pos].kind
}

///|
fn Parser::take(self : Parser, k : String) -> Token raise TemplateError {
  let t = self.tokens[self.pos]
  if t.kind != k {
    raise Invalid("expected " + k + " at " + t.offset.to_string())
  }
  if k != "end" {
    self.pos += 1
  }
  t
}

///|
fn priority(k : String) -> Int32 {
  match k {
    "||" => 1
    "&&" => 2
    "in" => 3
    "==" | "!=" => 4
    "<" | ">" | "<=" | ">=" => 5
    "+" | "-" => 6
    "*" | "/" => 7
    "**" => 8
    _ => 0
  }
}

///|
fn Parser::expr(
  self : Parser,
  minimum : Int32,
  depth : Int32,
) -> Expr raise TemplateError {
  self.budget.tick(depth)
  let mut left = self.unit(depth + 1)
  while priority(self.kind()) >= minimum && priority(self.kind()) > 0 {
    let op = self.kind()
    self.pos += 1
    let next = priority(op) + (if op == "**" { 0 } else { 1 })
    let right = self.expr(next, depth + 1)
    left = Binary(op, left, right)
  }
  left
}

///|
fn Parser::unit(self : Parser, depth : Int32) -> Expr raise TemplateError {
  self.budget.tick(depth)
  let t = self.tokens[self.pos]
  self.pos += 1
  match t.kind {
    "number" => {
      let n = @string.parse_double(t.content[:]) catch {
        _ => raise Invalid("invalid number")
      }
      Literal(Numeric(n))
    }
    "string" => Literal(Text(t.content))
    "true" => Literal(Boolean(true))
    "false" => Literal(Boolean(false))
    "null" => Literal(Nil)
    "id" => Name(t.content)
    "+" | "-" | "!" => Unary(t.kind, self.unit(depth + 1))
    "(" => {
      let e = self.expr(1, depth + 1)
      ignore(self.take(")"))
      e
    }
    "[" => {
      let a = []
      if self.kind() != "]" {
        a.push(self.expr(1, depth + 1))
        while self.kind() == "," {
          self.pos += 1
          a.push(self.expr(1, depth + 1))
        }
      }
      ignore(self.take("]"))
      Items(a)
    }
    "{" => {
      let a = []
      while self.kind() != "}" {
        let k = self.tokens[self.pos]
        if k.kind != "id" && k.kind != "string" {
          raise Invalid("object key must be identifier or string")
        }
        self.pos += 1
        ignore(self.take(":"))
        a.push((k.content, self.expr(1, depth + 1)))
        if self.kind() == "}" {
          break
        }
        ignore(self.take(","))
      }
      ignore(self.take("}"))
      Fields(a)
    }
    _ => raise Invalid("expected expression at " + t.offset.to_string())
  }
}

///|
fn parse_expr(source : String, b : Budget) -> Expr raise TemplateError {
  let p = { tokens: tokenize(source, b), pos: 0, budget: b, }
  let result = p.expr(1, 0)
  ignore(p.take("end"))
  result
}

///|
priv struct Token {
  kind : String
  content : String
  offset : Int32
}

///|
fn digit(c : Int32) -> Bool {
  c >= 48 && c <= 57
}

///|
fn alpha(c : Int32) -> Bool {
  (c >= 65 && c <= 90) || (c >= 97 && c <= 122) || c == 95
}

///|
fn tokenize(s : String, b : Budget) -> Array[Token] raise TemplateError {
  b.items(s.length())
  let out = []
  let mut i = 0
  while i < s.length() {
    b.tick(0)
    let start = i
    let c = s.code_unit_at(i).to_int()
    if c == 32 || c == 9 || c == 10 || c == 13 {
      i += 1
      continue
    }
    if digit(c) {
      i += 1
      while i < s.length() && digit(s.code_unit_at(i).to_int()) {
        i += 1
      }
      if i + 1 < s.length() &&
        s.code_unit_at(i).to_int() == 46 &&
        digit(s.code_unit_at(i + 1).to_int()) {
        i += 1
        while i < s.length() && digit(s.code_unit_at(i).to_int()) {
          i += 1
        }
      }
      out.push({
        kind: "number",
        content: s[start:i].to_owned(),
        offset: start,
      })
    } else if alpha(c) {
      i += 1
      while i < s.length() &&
            (
              alpha(s.code_unit_at(i).to_int()) ||
              digit(s.code_unit_at(i).to_int())
            ) {
        i += 1
      }
      let word = s[start:i].to_owned()
      let kind = match word {
        "true" | "false" | "null" | "in" => word
        _ => "id"
      }
      out.push({ kind, content: word, offset: start, })
    } else if c == 34 || c == 39 {
      i += 1
      while i < s.length() && s.code_unit_at(i).to_int() != c {
        i += 1
      }
      if i == s.length() {
        raise Invalid("unterminated quoted string at " + start.to_string())
      }
      out.push({
        kind: "string",
        content: s[start + 1:i].to_owned(),
        offset: start,
      })
      i += 1
    } else {
      let two = if i + 1 < s.length() { s[i:i + 2].to_owned() } else { "" }
      let op = match two {
        "**" | "<=" | ">=" | "==" | "!=" | "&&" | "||" => {
          i += 2
          two
        }
        _ => {
          let one = s[i:i + 1].to_owned()
          if ![
              "+", "-", "*", "/", "!", "<", ">", "(", ")", "[", "]", "{", "}", ":",
              ",", ".",
            ].contains(one) {
            raise Invalid("unexpected character at " + i.to_string())
          }
          i += 1
          one
        }
      }
      out.push({ kind: op, content: op, offset: start, })
    }
  }
  out.push({ kind: "end", content: "", offset: s.length(), })
  out
}

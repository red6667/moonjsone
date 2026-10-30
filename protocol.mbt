///|
fn json_property(
  o : Map[String, Json],
  key : String,
) -> Json raise TemplateError {
  match o.get(key) {
    Some(v) => v
    None => raise Invalid("missing request field: " + key)
  }
}

///|
fn protocol_request(request : Json) -> Json raise TemplateError {
  let o = match request {
    Object(o) => o
    _ => raise Invalid("request must be object")
  }
  for k, _ in o {
    if !["template", "context", "now", "expression"].contains(k) {
      raise Invalid("unknown request field: " + k)
    }
  }
  let context = o.get("context").unwrap_or(Json::empty_object())
  let now = match o.get("now") {
    Some(String(s)) => s
    Some(_) => raise Invalid("now must be string")
    None => "1970-01-01T00:00:00.000Z"
  }
  if o.contains("expression") {
    if o.contains("template") {
      raise Invalid("request cannot contain expression and template")
    }
    let expr = match json_property(o, "expression") {
      String(s) => s
      _ => raise Invalid("expression must be string")
    }
    evaluate_expression(expr, context, now~)
  } else {
    render(json_property(o, "template"), context, now~)
  }
}

///|
fn protocol_one(request : Json) -> Json {
  try {
    let value = protocol_request(request)
    Json::object(Map([("ok", Json::boolean(true)), ("result", value)]))
  } catch {
    Invalid(message) =>
      Json::object(
        Map([
          ("ok", Json::boolean(false)),
          ("category", Json::string("invalid")),
          ("message", Json::string(message)),
        ]),
      )
    Limit(message) =>
      Json::object(
        Map([
          ("ok", Json::boolean(false)),
          ("category", Json::string("limit")),
          ("message", Json::string(message)),
        ]),
      )
  }
}

///|
/// JSON request protocol for portable command-line and embedded integrations.
/// Accepts one request or a bounded batch. Every response has an ok field.
pub fn execute(input : String) -> String {
  if input.length() > 4000000 {
    return "{\"ok\":false,\"category\":\"limit\",\"message\":\"request too large\"}"
  }
  try {
    let request = @json.parse(
      input[:],
      max_nesting_depth=128,
      reject_duplicate_keys=true,
    )
    let response = match request {
      Array(xs) => {
        if xs.length() > 1000 {
          raise Limit("batch exceeds 1000 requests")
        }
        Json::array(xs.map(protocol_one))
      }
      _ => protocol_one(request)
    }
    response.stringify()
  } catch {
    _ =>
      "{\"ok\":false,\"category\":\"invalid\",\"message\":\"invalid request JSON or oversized batch\"}"
  }
}

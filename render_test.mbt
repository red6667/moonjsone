///|
test "template interpolation, escaped keys and structured eval" {
  let c : Json = { "name": "world", "n": 3 }
  assert_eq(
    render(
      (
        {
          "hello": "Hi ${name}",
          "n": { "$eval": "n+1" },
          "$$literal": "$${escaped}",
        } : Json),
      c,
    ),
    ({ "hello": "Hi world", "n": 4, "$literal": "${escaped}" } : Json),
  )
  assert_eq(render(("value: ${{a: 2}.a}" : Json), c), Json::string("value: 2"))
}

///|
test "conditional omission and lexical let bindings" {
  let c : Json = { "x": 3 }
  assert_eq(
    render(([1, { "$if": "false", "then": 2 }, 3] : Json), c),
    ([1, 3] : Json),
  )
  assert_eq(
    render(({ "a": { "$if": "false", "then": 2 }, "b": 3 } : Json), c),
    ({ "b": 3 } : Json),
  )
  assert_eq(
    render(
      (
        { "$let": { "x": 4, "y": { "$eval": "x" } }, "in": { "$eval": "x+y" } } :
        Json),
      c,
    ),
    Json::number(7),
  )
  assert_eq(
    render(
      ({ "$if": "true", "then": 1, "else": { "$eval": "missing" } } : Json),
      c,
    ),
    Json::number(1),
  )
}

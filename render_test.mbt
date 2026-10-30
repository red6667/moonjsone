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

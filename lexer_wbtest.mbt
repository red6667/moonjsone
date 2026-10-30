///|
test "lexer preserves raw string contents and token boundaries" {
  let b = { remaining: 1000, max_depth: 30, max_items: 1000, }
  let t = tokenize("inside in 'a\\b' >= 2.5 ** 3", b)
  assert_eq(t[0].kind, "id")
  assert_eq(t[1].kind, "in")
  assert_eq(t[2].content, "a\\b")
  assert_eq(t[3].kind, ">=")
  assert_eq(t[4].content, "2.5")
  assert_eq(t[5].kind, "**")
}

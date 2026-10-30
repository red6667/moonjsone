///|
test "value conversion, truth and identifier boundaries" {
  let b = { remaining: 1000, max_depth: 50, max_items: 1000, }
  let j : Json = { "ok": [true, false, null, 3, "x"] }
  assert_eq(to_json(from_json(j, b, 0), b, 0), j)
  assert_false(truth(Record(Map([]))))
  assert_true(identifier("_test2"))
  assert_false(identifier("2test"))
  assert_false(identifier("a-b"))
}

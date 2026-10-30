///|
test "request protocol isolates failures within batch" {
  let input = "[{\"expression\":\"2+3\"},{\"expression\":\"missing\"},{\"template\":{\"n\":4}}]"
  let actual = @json.parse(@moonjsone.execute(input)[:])
  assert_true(actual is Array([Object(_), Object(_), Object(_)]))
  match actual {
    Array(xs) => {
      assert_eq(xs[0], ({ "ok": true, "result": 5 } : Json))
      assert_eq(xs[2], ({ "ok": true, "result": { "n": 4 } } : Json))
    }
    _ => fail("expected array")
  }
  assert_eq(
    @json.parse(@moonjsone.execute("{")[:]),
    (
      {
        "ok": false,
        "category": "invalid",
        "message": "invalid request JSON or oversized batch",
      } : Json),
  )
}

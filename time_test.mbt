///|
test "relative dates cross leap days and year boundaries" {
  let c : Json = {}
  assert_eq(
    evaluate_expression("fromNow('1 day')", c, now="2024-02-28T23:59:59.123Z"),
    Json::string("2024-02-29T23:59:59.123Z"),
  )
  assert_eq(
    evaluate_expression(
      "fromNow('-2 seconds')",
      c,
      now="2026-01-01T00:00:01.000Z",
    ),
    Json::string("2025-12-31T23:59:59.000Z"),
  )
  assert_eq(
    evaluate_expression(
      "fromNow('1 year 1 month')",
      c,
      now="2026-01-01T00:00:00.000Z",
    ),
    Json::string("2027-01-31T00:00:00.000Z"),
  )
}

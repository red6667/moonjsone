///|
test "parser precedence and right associative powers" {
  let b = { remaining: 10000, max_depth: 64, max_items: 10000, }
  assert_eq(
    parse_expr("2 ** 3 ** 2", b),
    Binary(
      "**",
      Literal(Numeric(2)),
      Binary("**", Literal(Numeric(3)), Literal(Numeric(2))),
    ),
  )
  assert_eq(
    parse_expr("1+2*3", b),
    Binary(
      "+",
      Literal(Numeric(1)),
      Binary("*", Literal(Numeric(2)), Literal(Numeric(3))),
    ),
  )
  assert_eq(parse_expr("[]", b), Items([]))
  assert_eq(parse_expr("{}", b), Fields([]))
}

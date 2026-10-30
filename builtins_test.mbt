///|
test "numeric builtins and descending bounded ranges" {
  let context : Json = {}
  assert_eq(
    evaluate_expression("min(3,1,7)+max(2,4)", context),
    Json::number(5),
  )
  assert_eq(evaluate_expression("range(5,0,-2)", context), ([5, 3, 1] : Json))
  assert_eq(
    evaluate_expression("sqrt(9)+abs(-2)+ceil(1.2)+floor(-1.2)", context),
    Json::number(5),
  )
}

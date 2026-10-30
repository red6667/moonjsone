///|
test "numeric builtins and descending bounded ranges" {
  let context : Json = Json::empty_object()
  assert_eq(
    @moonjsone.evaluate_expression("min(3,1,7)+max(2,4)", context),
    Json::number(5),
  )
  assert_eq(
    @moonjsone.evaluate_expression("range(5,0,-2)", context),
    ([5, 3, 1] : Json),
  )
  assert_eq(
    @moonjsone.evaluate_expression(
      "sqrt(9)+abs(-2)+ceil(1.2)+floor(-1.2)", context,
    ),
    Json::number(5),
  )
}

///|
test "text, introspection and conversion builtins" {
  let context : Json = { "x": 2 }
  assert_eq(
    @moonjsone.evaluate_expression("join(split('abc',''),'-')", context),
    Json::string("a-b-c"),
  )
  assert_eq(
    @moonjsone.evaluate_expression("uppercase(strip('  hello  '))", context),
    Json::string("HELLO"),
  )
  assert_eq(
    @moonjsone.evaluate_expression("typeof(min)", context),
    Json::string("function"),
  )
  assert_eq(
    @moonjsone.evaluate_expression("defined('x') && !(defined('y'))", context),
    Json::boolean(true),
  )
  assert_eq(
    @moonjsone.evaluate_expression("number('12.5')+len('abc')", context),
    Json::number(15.5),
  )
}

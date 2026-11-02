///|
test "intermediate concatenation cannot bypass the string budget via len" {
  let c : Json = { "x": "01234567890123456789012345678901" }
  let failed = try {
    ignore(@moonjsone.evaluate_expression("len(x+x)", c, max_items=32))
    false
  } catch {
    @moonjsone.TemplateError::Limit(_) => true
    _ => false
  }
  assert_true(failed)
}

///|
fn expect_budget_limit(
  source : String,
  context : Json,
  limit : Int32,
) -> Unit raise {
  let limited = try {
    ignore(@moonjsone.evaluate_expression(source, context, max_items=limit))
    false
  } catch {
    @moonjsone.TemplateError::Limit(_) => true
    _ => false
  }
  assert_true(limited)
}

///|
test "intermediate string limits apply to parent consumers and input values" {
  let context : Json = { "x": "01234567890123456789012345678901" }
  expect_budget_limit("len((x+x)+x)", context, 32)
  expect_budget_limit("len(join([x,x],''))", context, 32)
  expect_budget_limit(
    "len(x)",
    { "x": "012345678901234567890123456789012" },
    32,
  )
  let limited = try {
    ignore(@moonjsone.render({ "$eval": "len(x+x)" }, context, max_items=32))
    false
  } catch {
    @moonjsone.TemplateError::Limit(_) => true
    _ => false
  }
  assert_true(limited)
}

///|
test "string budget allows exact boundaries and preserves arithmetic" {
  let context : Json = { "x": "0123456789012345" }
  assert_true(
    @moonjsone.evaluate_expression("x+x", context, max_items=32) ==
    Json::string("01234567890123450123456789012345"),
  )
  assert_true(
    @moonjsone.evaluate_expression("len(x+x)", context, max_items=32) ==
    Json::number(32),
  )
  assert_true(
    @moonjsone.evaluate_expression("2+3", {}, max_items=32) == Json::number(5),
  )
  assert_true(
    @moonjsone.evaluate_expression(
      "x+x",
      { "x": "😀😀😀😀😀😀😀😀" },
      max_items=32,
    ) ==
    Json::string(
      "😀😀😀😀😀😀😀😀😀😀😀😀😀😀😀😀",
    ),
  )
}

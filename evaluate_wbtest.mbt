///|
test "numeric evaluator respects precedence and strict scalar types" {
  let b = { remaining: 10000, max_depth: 100, max_items: 10000, }
  let env = Map([])
  assert_eq(eval_source("2**3**2", env, b), Numeric(512))
  assert_eq(eval_source("3+4*2", env, b), Numeric(11))
  assert_eq(eval_source("'ab'+'cd'", env, b), Text("abcd"))
  assert_eq(eval_source("2 < 3", env, b), Boolean(true))
  assert_eq(eval_source("true == 1", env, b), Boolean(false))
}

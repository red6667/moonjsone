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

///|
test "logical operators return booleans and short circuit errors" {
  let b = { remaining: 10000, max_depth: 100, max_items: 10000, }
  let env = Map([("xs", Sequence([Numeric(3)])), ("s", Text("alpha"))])
  assert_eq(eval_source("false && missing", env, b), Boolean(false))
  assert_eq(eval_source("true || (1/0)", env, b), Boolean(true))
  assert_eq(eval_source("0 || 'nonempty'", env, b), Boolean(true))
  assert_eq(eval_source("3 in xs", env, b), Boolean(true))
  assert_eq(eval_source("'ph' in s", env, b), Boolean(true))
}

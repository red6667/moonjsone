///|
fn rejected(
  template : Json,
  context : Json,
  steps~ : Int32 = 1000,
  items~ : Int32 = 100,
  depth~ : Int32 = 32,
) -> Bool {
  try {
    ignore(
      @moonjsone.render(
        template,
        context,
        max_steps=steps,
        max_items=items,
        max_depth=depth,
      ),
    )
    false
  } catch {
    _ => true
  }
}

///|
test "hostile input is rejected without host evaluation or imports" {
  let c = Json::empty_object()
  assert_true(rejected(({ "$eval": "range(0,1000000)" } : Json), c))
  assert_true(rejected(({ "$eval": "1/0" } : Json), c))
  assert_true(rejected(({ "$eval": "min" } : Json), c))
  assert_true(
    rejected(({ "$eval": "constructor('return process')()" } : Json), c),
  )
  assert_true(rejected(({ "$eval": "a.b" } : Json), c))
  assert_true(rejected(({ "$eval": "{}.__proto__" } : Json), c))
  assert_true(rejected(({ "$eval": "[0][99]" } : Json), c))
  assert_true(rejected(({ "$eval": "2**999999" } : Json), c))
  assert_true(
    rejected(({ "$if": "true", "then": 1, "unexpected": 2 } : Json), c),
  )
  assert_true(rejected(({ "$switch": { "1": 1, "true": 2 } } : Json), c))
  assert_true(rejected(({ "$sort": [1, "a"] } : Json), c))
  assert_true(rejected(({ "$let": { "1bad": 2 }, "in": 3 } : Json), c))
  assert_true(rejected(Json::string("x"), ([1] : Json)))
  assert_true(rejected(Json::string("x"), ({ "bad-name": 1 } : Json)))
}

///|
test "resource budgets stop parser nesting, output expansion and invalid options" {
  let c = Json::empty_object()
  assert_true(rejected(({ "$eval": "((((((((1))))))))" } : Json), c, depth=5))
  assert_true(rejected(({ "$eval": "range(0,20)" } : Json), c, items=10))
  assert_true(rejected(({ "$eval": "1+2" } : Json), c, steps=2))
  assert_true(rejected(Json::string("12345678901"), c, items=10))
  assert_true(rejected(Json::null(), c, steps=0))
  assert_true(rejected(Json::null(), c, depth=257))
  assert_true(
    rejected(
      ({ "$fromNow": "1 day", "from": "2026-02-30T00:00:00.000Z" } : Json),
      c,
    ),
  )
  assert_true(rejected(({ "$fromNow": "1 second 2 days" } : Json), c))
}

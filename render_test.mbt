///|
test "template interpolation, escaped keys and structured eval" {
  let c : Json = { "name": "world", "n": 3 }
  assert_eq(
    render(
      (
        {
          "hello": "Hi ${name}",
          "n": { "$eval": "n+1" },
          "$$literal": "$${escaped}",
        } : Json),
      c,
    ),
    ({ "hello": "Hi world", "n": 4, "$literal": "${escaped}" } : Json),
  )
  assert_eq(render(("value: ${{a: 2}.a}" : Json), c), Json::string("value: 2"))
}

///|
test "conditional omission and lexical let bindings" {
  let c : Json = { "x": 3 }
  assert_eq(
    render(([1, { "$if": "false", "then": 2 }, 3] : Json), c),
    ([1, 3] : Json),
  )
  assert_eq(
    render(({ "a": { "$if": "false", "then": 2 }, "b": 3 } : Json), c),
    ({ "b": 3 } : Json),
  )
  assert_eq(
    render(
      (
        { "$let": { "x": 4, "y": { "$eval": "x" } }, "in": { "$eval": "x+y" } } :
        Json),
      c,
    ),
    Json::number(7),
  )
  assert_eq(
    render(
      ({ "$if": "true", "then": 1, "else": { "$eval": "missing" } } : Json),
      c,
    ),
    Json::number(1),
  )
}

///|
test "collection mapping reduction and first match" {
  let c : Json = {}
  assert_eq(
    render(({ "$map": [2, 4], "each(x,i)": { "$eval": "x+i" } } : Json), c),
    ([2, 5] : Json),
  )
  assert_eq(
    render(
      (
        {
          "$reduce": [2, 4, 6],
          "initial": 0,
          "each(acc,x)": { "$eval": "acc+x" },
        } : Json),
      c,
    ),
    Json::number(12),
  )
  assert_eq(
    render(({ "$find": [2, 4, 6], "each(x)": "x>3" } : Json), c),
    Json::number(4),
  )
  assert_eq(
    render(
      (
        { "$map": { "a": 2 }, "each(v,k)": { "${k}": { "$eval": "v+1" } } } :
        Json),
      c,
    ),
    ({ "a": 3 } : Json),
  )
}

///|
test "sorted multi match and exclusive switch" {
  let c : Json = {}
  assert_eq(
    render(({ "$match": { "2>1": "b", "1>0": "a", "false": "c" } } : Json), c),
    (["a", "b"] : Json),
  )
  assert_eq(
    render(({ "$switch": { "false": 2, "$default": 3 } } : Json), c),
    Json::number(3),
  )
  assert_eq(
    render(
      ({ "$switch": { "true": 2, "$default": { "$eval": "missing" } } } : Json),
      c,
    ),
    Json::number(2),
  )
}

///|
test "template interpolation, escaped keys and structured eval" {
  let c : Json = { "name": "world", "n": 3 }
  assert_eq(
    @moonjsone.render(
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
  assert_eq(
    @moonjsone.render(("value: ${{a: 2}.a}" : Json), c),
    Json::string("value: 2"),
  )
}

///|
test "conditional omission and lexical let bindings" {
  let c : Json = { "x": 3 }
  assert_eq(
    @moonjsone.render(([1, { "$if": "false", "then": 2 }, 3] : Json), c),
    ([1, 3] : Json),
  )
  assert_eq(
    @moonjsone.render(
      ({ "a": { "$if": "false", "then": 2 }, "b": 3 } : Json),
      c,
    ),
    ({ "b": 3 } : Json),
  )
  assert_eq(
    @moonjsone.render(
      (
        { "$let": { "x": 4, "y": { "$eval": "x" } }, "in": { "$eval": "x+y" } } :
        Json),
      c,
    ),
    Json::number(7),
  )
  assert_eq(
    @moonjsone.render(
      ({ "$if": "true", "then": 1, "else": { "$eval": "missing" } } : Json),
      c,
    ),
    Json::number(1),
  )
}

///|
test "collection mapping reduction and first match" {
  let c : Json = Json::empty_object()
  assert_eq(
    @moonjsone.render(
      ({ "$map": [2, 4], "each(x,i)": { "$eval": "x+i" } } : Json),
      c,
    ),
    ([2, 5] : Json),
  )
  assert_eq(
    @moonjsone.render(
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
    @moonjsone.render(({ "$find": [2, 4, 6], "each(x)": "x>3" } : Json), c),
    Json::number(4),
  )
  assert_eq(
    @moonjsone.render(
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
  let c : Json = Json::empty_object()
  assert_eq(
    @moonjsone.render(
      ({ "$match": { "2>1": "b", "1>0": "a", "false": "c" } } : Json),
      c,
    ),
    (["a", "b"] : Json),
  )
  assert_eq(
    @moonjsone.render(({ "$switch": { "false": 2, "$default": 3 } } : Json), c),
    Json::number(3),
  )
  assert_eq(
    @moonjsone.render(
      ({ "$switch": { "true": 2, "$default": { "$eval": "missing" } } } : Json),
      c,
    ),
    Json::number(2),
  )
}

///|
test "deep merge concatenates arrays and flatten depth is explicit" {
  let c : Json = Json::empty_object()
  assert_eq(
    @moonjsone.render(
      (
        {
          "$mergeDeep": [
            { "a": { "x": 1 }, "v": [1] },
            { "a": { "y": 2 }, "v": [2] },
          ],
        } : Json),
      c,
    ),
    ({ "a": { "x": 1, "y": 2 }, "v": [1, 2] } : Json),
  )
  assert_eq(
    @moonjsone.render(({ "$flatten": [[1, [2]], 3] } : Json), c),
    ([1, [2], 3] : Json),
  )
  assert_eq(
    @moonjsone.render(({ "$flattenDeep": [[1, [2]], 3] } : Json), c),
    ([1, 2, 3] : Json),
  )
}

///|
test "stable sorting, canonical JSON and relative time operator" {
  let c : Json = Json::empty_object()
  assert_eq(
    @moonjsone.render(
      (
        {
          "$sort": [{ "x": 2, "id": "a" }, { "x": 1 }, { "x": 2, "id": "b" }],
          "by(v)": "v.x",
        } : Json),
      c,
    ),
    ([{ "x": 1 }, { "x": 2, "id": "a" }, { "x": 2, "id": "b" }] : Json),
  )
  assert_eq(
    @moonjsone.render(
      ({ "$json": { "z": 3, "a": { "c": 1, "b": 2 } } } : Json),
      c,
    ),
    Json::string("{\"a\":{\"b\":2,\"c\":1},\"z\":3}"),
  )
  assert_eq(
    @moonjsone.render(
      ({ "$fromNow": "2 days" } : Json),
      c,
      now="2017-01-19T16:27:20.974Z",
    ),
    Json::string("2017-01-21T16:27:20.974Z"),
  )
}

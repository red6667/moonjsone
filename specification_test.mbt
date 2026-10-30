///|
test "upstream 0000 Identity" {
  let template = @json.parse(
    "{\"key\":[1,2,{\"key2\":\"val\",\"key3\":1},true],\"f\":false}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse(
    "{\"key\":[1,2,{\"key2\":\"val\",\"key3\":1},true],\"f\":false}",
  )
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0001 fromNow" {
  let template = @json.parse("{\"$fromNow\":\"\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-19T16:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0002 fromNow 2 days 3 hours" {
  let template = @json.parse("{\"$fromNow\":\"2 days 3 hours\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-21T19:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0003 $eval without context" {
  let template = @json.parse("{\"$eval\":\"1 + 2\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("3")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0004 $eval" {
  let template = @json.parse("{\"$eval\":\"key\"}")
  let context = @json.parse("{\"key\":[\"value\",1,2,true,{}]}")
  let expected = @json.parse("[\"value\",1,2,true,{}]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0005 $json" {
  let template = @json.parse("{\"$json\":[1,2,true,{},[]]}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"[1,2,true,{},[]]\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0006 $json alphabetical" {
  let template = @json.parse(
    "{\"$json\":{\"Z\":null,\"q\":1,\"a\":{\"c\":45,\"b\":[\"9\",8,{}]},\"r\":true}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse(
    "\"{\\\"Z\\\":null,\\\"a\\\":{\\\"b\\\":[\\\"9\\\",8,{}],\\\"c\\\":45},\\\"q\\\":1,\\\"r\\\":true}\"",
  )
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0007 string interpolation" {
  let template = @json.parse("{\"message\":\"hello ${key}\",\"k-${num}\":true}")
  let context = @json.parse("{\"key\":\"world\",\"num\":1}")
  let expected = @json.parse("{\"message\":\"hello world\",\"k-1\":true}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0008 string interpolation with object evaluation" {
  let template = @json.parse(
    "{\"message\":\"hello ${{a: \\\"world\\\"}.a}\",\"k-${{a: 1}.a + {a: 0}.a}\":true}",
  )
  let context = @json.parse("{\"key\":\"world\",\"num\":1}")
  let expected = @json.parse("{\"message\":\"hello world\",\"k-1\":true}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0009 multiple string interpolation (1)" {
  let template = @json.parse("{\"message\":\"${a} ${b}\"}")
  let context = @json.parse("{\"a\":\"hello\",\"b\":\"world\"}")
  let expected = @json.parse("{\"message\":\"hello world\"}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0010 multiple string interpolation (2)" {
  let template = @json.parse("{\"message\":\"${a}$$${b}\"}")
  let context = @json.parse("{\"a\":\"hello\",\"b\":\"world\"}")
  let expected = @json.parse("{\"message\":\"hello$${b}\"}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0011 multiple string interpolation (3)" {
  let template = @json.parse("{\"message\":\"${a}##${b}\"}")
  let context = @json.parse("{\"a\":\"hello\",\"b\":\"world\"}")
  let expected = @json.parse("{\"message\":\"hello##world\"}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0012 string interpolation escapes" {
  let template = @json.parse("{\"message\":\"a literal $${in a string}\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("{\"message\":\"a literal ${in a string}\"}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0013 string interpolation escapes with more $" {
  let template = @json.parse(
    "[\"${x}\",\"$${x}\",\"$$${x}\",\"$$$${x}\",\"$$$$${x}\"]",
  )
  let context = @json.parse("{\"x\":\"a\"}")
  let expected = @json.parse(
    "[\"a\",\"${x}\",\"$${x}\",\"$$${x}\",\"$$$${x}\"]",
  )
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0014 string interpolation of keys" {
  let template = @json.parse("{\"tc_${name}\":\"${value}\"}")
  let context = @json.parse("{\"name\":\"foo\",\"value\":\"bar\"}")
  let expected = @json.parse("{\"tc_foo\":\"bar\"}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0015 string interpolation with unbalanced }" {
  let template = @json.parse("{\"message\":\"tricky ${\\\"}}}}\\\"}\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("{\"message\":\"tricky }}}}\"}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0016 can't interpolate arrays" {
  let template = @json.parse("{\"message\":\"hello ${key}\"}")
  let context = @json.parse("{\"key\":[1,2,3]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0017 can't interpolate objects" {
  let template = @json.parse("\"hello ${key}\"")
  let context = @json.parse("{\"key\":{}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0018 booleans interpolate" {
  let template = @json.parse("\"${t} or ${f}: yeast is a bacterium\"")
  let context = @json.parse("{\"t\":true,\"f\":false}")
  let expected = @json.parse("\"true or false: yeast is a bacterium\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0019 numbers interpolate" {
  let template = @json.parse("\"${round}, really ${decimal}\"")
  let context = @json.parse("{\"round\":3,\"decimal\":3.75}")
  let expected = @json.parse("\"3, really 3.75\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0020 nulls interpolate" {
  let template = @json.parse("\"big pile of ${nothing}\"")
  let context = @json.parse("{\"nothing\":null}")
  let expected = @json.parse("\"big pile of \"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0021 interpolated __proto__ key" {
  let template = @json.parse("{\"__pro${e}to__\":{\"$eval\":\"1 + 1\"}}")
  let context = @json.parse("{\"e\":\"\"}")
  let expected = @json.parse("{\"__proto__\":2}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0022 invalid context" {
  let template = @json.parse("{}")
  let context = @json.parse("{\"a b c\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0023 operator nested in an object" {
  let template = @json.parse("{\"key\":{\"$reverse\":[1,2,3]}}")
  let context = @json.parse("{}")
  let expected = @json.parse("{\"key\":[3,2,1]}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0024 $if-then-else, true" {
  let template = @json.parse("{\"$if\":\"cond\",\"then\":1,\"else\":2}")
  let context = @json.parse("{\"cond\":true}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0025 $if-then-else, false" {
  let template = @json.parse("{\"$if\":\"cond\",\"then\":1,\"else\":2}")
  let context = @json.parse("{\"cond\":false}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0026 $if-then in array, true" {
  let template = @json.parse("[0,{\"$if\":\"cond\",\"then\":1}]")
  let context = @json.parse("{\"cond\":true}")
  let expected = @json.parse("[0,1]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0027 $if-then in array, false" {
  let template = @json.parse("[0,{\"$if\":\"cond\",\"then\":1}]")
  let context = @json.parse("{\"cond\":false}")
  let expected = @json.parse("[0]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0028 $if-then in object, true" {
  let template = @json.parse("{\"key\":{\"$if\":\"cond\",\"then\":1},\"k2\":3}")
  let context = @json.parse("{\"cond\":true}")
  let expected = @json.parse("{\"key\":1,\"k2\":3}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0029 $if-then in object, false" {
  let template = @json.parse("{\"key\":{\"$if\":\"cond\",\"then\":1},\"k2\":3}")
  let context = @json.parse("{\"cond\":false}")
  let expected = @json.parse("{\"k2\":3}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0030 $if -> delete-marker, true" {
  let template = @json.parse("{\"key\":{\"$if\":\"cond\"},\"k2\":3}")
  let context = @json.parse("{\"cond\":true}")
  let expected = @json.parse("{\"k2\":3}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0031 $if -> delete-marker, false" {
  let template = @json.parse("{\"key\":{\"$if\":\"cond\"},\"k2\":3}")
  let context = @json.parse("{\"cond\":false}")
  let expected = @json.parse("{\"k2\":3}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0032 $if->then, then => $eval, true" {
  let template = @json.parse("{\"$if\":\"true\",\"then\":{\"$eval\":\"key\"}}")
  let context = @json.parse("{\"key\":{\"b\":1}}")
  let expected = @json.parse("{\"b\":1}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0033 $if->else, else => $eval, false" {
  let template = @json.parse("{\"$if\":\"false\",\"else\":{\"$eval\":\"key\"}}")
  let context = @json.parse("{\"key\":{\"b\":1}}")
  let expected = @json.parse("{\"b\":1}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0034 $if->then, then => ${}, true" {
  let template = @json.parse("{\"$if\":\"true\",\"then\":\"${key}\"}")
  let context = @json.parse("{\"key\":\"one\"}")
  let expected = @json.parse("\"one\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0035 $if->else, else => ${}, false" {
  let template = @json.parse("{\"$if\":\"false\",\"else\":\"${key}\"}")
  let context = @json.parse("{\"key\":\"one\"}")
  let expected = @json.parse("\"one\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0036 $if->then, then => object, true" {
  let template = @json.parse(
    "{\"$if\":\"cond\",\"then\":{\"key\":\"hello world\"}}",
  )
  let context = @json.parse("{\"cond\":true}")
  let expected = @json.parse("{\"key\":\"hello world\"}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0037 $if->else, else => object, false" {
  let template = @json.parse(
    "{\"$if\":\"cond\",\"else\":{\"key\":\"hello world\"}}",
  )
  let context = @json.parse("{\"cond\":false}")
  let expected = @json.parse("{\"key\":\"hello world\"}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0038 $if->then, then => object, $eval, true" {
  let template = @json.parse(
    "{\"$if\":\"cond\",\"then\":{\"key\":{\"$eval\":\"key\"}}}",
  )
  let context = @json.parse("{\"cond\":true,\"key\":\"hello world\"}")
  let expected = @json.parse("{\"key\":\"hello world\"}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0039 $if->else, else => object, $eval, false" {
  let template = @json.parse(
    "{\"$if\":\"cond\",\"else\":{\"key\":{\"$eval\":\"key\"}}}",
  )
  let context = @json.parse("{\"cond\":false,\"key\":\"hello world\"}")
  let expected = @json.parse("{\"key\":\"hello world\"}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0040 $if->then, then => object, interpolation, true" {
  let template = @json.parse(
    "{\"$if\":\"cond\",\"then\":{\"key\":\"hello ${key}\"}}",
  )
  let context = @json.parse("{\"cond\":true,\"key\":\"world\"}")
  let expected = @json.parse("{\"key\":\"hello world\"}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0041 $if->else, else => object, interpolation, false" {
  let template = @json.parse(
    "{\"$if\":\"cond\",\"else\":{\"key\":\"hello ${key}\"}}",
  )
  let context = @json.parse("{\"cond\":false,\"key\":\"world\"}")
  let expected = @json.parse("{\"key\":\"hello world\"}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0042 $if->then->else, empty string" {
  let template = @json.parse("{\"$if\":\"cond\",\"then\":\"t\",\"else\":\"f\"}")
  let context = @json.parse("{\"cond\":\"\",\"key\":\"world\"}")
  let expected = @json.parse("\"f\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0043 $if->then->else, nonempty string" {
  let template = @json.parse("{\"$if\":\"cond\",\"then\":\"t\",\"else\":\"f\"}")
  let context = @json.parse("{\"cond\":\"stuff\",\"key\":\"world\"}")
  let expected = @json.parse("\"t\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0044 $if->then->else, string \"0\"" {
  let template = @json.parse("{\"$if\":\"cond\",\"then\":\"t\",\"else\":\"f\"}")
  let context = @json.parse("{\"cond\":\"0\",\"key\":\"world\"}")
  let expected = @json.parse("\"t\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0045 $if->then->else, zero" {
  let template = @json.parse("{\"$if\":\"cond\",\"then\":\"t\",\"else\":\"f\"}")
  let context = @json.parse("{\"cond\":0,\"key\":\"world\"}")
  let expected = @json.parse("\"f\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0046 $if->then->else, one" {
  let template = @json.parse("{\"$if\":\"cond\",\"then\":\"t\",\"else\":\"f\"}")
  let context = @json.parse("{\"cond\":1,\"key\":\"world\"}")
  let expected = @json.parse("\"t\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0047 $if->then->else, null" {
  let template = @json.parse("{\"$if\":\"cond\",\"then\":\"t\",\"else\":\"f\"}")
  let context = @json.parse("{\"cond\":null,\"key\":\"world\"}")
  let expected = @json.parse("\"f\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0048 $if->then->else, empty array" {
  let template = @json.parse("{\"$if\":\"cond\",\"then\":\"t\",\"else\":\"f\"}")
  let context = @json.parse("{\"cond\":[],\"key\":\"world\"}")
  let expected = @json.parse("\"f\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0049 $if->then->else, nonempty array" {
  let template = @json.parse("{\"$if\":\"cond\",\"then\":\"t\",\"else\":\"f\"}")
  let context = @json.parse("{\"cond\":[1,2],\"key\":\"world\"}")
  let expected = @json.parse("\"t\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0050 $if->then->else, empty object" {
  let template = @json.parse("{\"$if\":\"cond\",\"then\":\"t\",\"else\":\"f\"}")
  let context = @json.parse("{\"cond\":{},\"key\":\"world\"}")
  let expected = @json.parse("\"f\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0051 $if->then->else, nonempty object" {
  let template = @json.parse("{\"$if\":\"cond\",\"then\":\"t\",\"else\":\"f\"}")
  let context = @json.parse("{\"cond\":{\"a\":2},\"key\":\"world\"}")
  let expected = @json.parse("\"t\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0052 $if->then->else, function" {
  let template = @json.parse("{\"$if\":\"min\",\"then\":\"t\",\"else\":\"f\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"t\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0053 $if->then evaluating to nothing at the top level is null" {
  let template = @json.parse("{\"$if\":\"cond\",\"then\":\"t\"}")
  let context = @json.parse("{\"cond\":false}")
  let expected = @json.parse("null")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0054 $if-then-else with undefined properties" {
  let template = @json.parse(
    "{\"$if\":\"cond\",\"then\":1,\"foo\":\"bar\",\"else\":2,\"bing\":\"baz\"}",
  )
  let context = @json.parse("{\"cond\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0055 escape $eval" {
  let template = @json.parse("{\"$$eval\":\"1+2\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("{\"$eval\":\"1+2\"}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0056 escape $flatten" {
  let template = @json.parse("{\"$$flatten\":[[1,2],[3,4],[5]]}")
  let context = @json.parse("{}")
  let expected = @json.parse("{\"$flatten\":[[1,2],[3,4],[5]]}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0057 escape $fromNow" {
  let template = @json.parse("{\"$$fromNow\":\"2 days\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("{\"$fromNow\":\"2 days\"}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0058 escape $if" {
  let template = @json.parse("{\"$$if\":false}")
  let context = @json.parse("{}")
  let expected = @json.parse("{\"$if\":false}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0059 escape $json" {
  let template = @json.parse("{\"$$json\":[1,2,3]}")
  let context = @json.parse("{}")
  let expected = @json.parse("{\"$json\":[1,2,3]}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0060 escape $let" {
  let template = @json.parse(
    "{\"$$let\":{\"ts\":100,\"foo\":200},\"in\":[{\"$$eval\":\"ts+foo\"}]}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse(
    "{\"$let\":{\"ts\":100,\"foo\":200},\"in\":[{\"$eval\":\"ts+foo\"}]}",
  )
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0061 escape $map" {
  let template = @json.parse(
    "{\"$$map\":[2,4,6],\"each(x)\":{\"$$eval\":\"x + a\"}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse(
    "{\"$map\":[2,4,6],\"each(x)\":{\"$eval\":\"x + a\"}}",
  )
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0062 escape $match" {
  let template = @json.parse("{\"$$match\":[{\"x == 1\":2}]}")
  let context = @json.parse("{\"x\":1}")
  let expected = @json.parse("{\"$match\":[{\"x == 1\":2}]}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0063 escape $switch" {
  let template = @json.parse("{\"$$switch\":[{\"x == 1\":2}]}")
  let context = @json.parse("{\"x\":1}")
  let expected = @json.parse("{\"$switch\":[{\"x == 1\":2}]}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0064 escape $merge" {
  let template = @json.parse("{\"$$merge\":[{\"a\":1},{\"a\":2}]}")
  let context = @json.parse("{}")
  let expected = @json.parse("{\"$merge\":[{\"a\":1},{\"a\":2}]}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0065 escape $reverse" {
  let template = @json.parse("{\"$$reverse\":[3,2,1]}")
  let context = @json.parse("{}")
  let expected = @json.parse("{\"$reverse\":[3,2,1]}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0066 escape $sort" {
  let template = @json.parse("{\"$$sort\":[3,2,1]}")
  let context = @json.parse("{}")
  let expected = @json.parse("{\"$sort\":[3,2,1]}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0067 reserved $-keywords" {
  let template = @json.parse("{\"$nothing\":1}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0068 escape non-json-e operator" {
  let template = @json.parse("{\"$$nothing\":1}")
  let context = @json.parse("{}")
  let expected = @json.parse("{\"$nothing\":1}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0069 two escaped operators" {
  let template = @json.parse("{\"$$map\":1,\"$$let\":2}")
  let context = @json.parse("{}")
  let expected = @json.parse("{\"$map\":1,\"$let\":2}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0070 simple flatten" {
  let template = @json.parse("{\"$flatten\":[[1,2],[3,4],[5]]}")
  let context = @json.parse("{}")
  let expected = @json.parse("[1,2,3,4,5]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0071 flatten empty array" {
  let template = @json.parse("{\"$flatten\":[]}")
  let context = @json.parse("{}")
  let expected = @json.parse("[]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0072 flatten empty array of arrays" {
  let template = @json.parse("{\"$flatten\":[[]]}")
  let context = @json.parse("{}")
  let expected = @json.parse("[]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0073 flatten evaluated value" {
  let template = @json.parse("{\"$flatten\":{\"$eval\":\"[[1], [2, 3]]\"}}")
  let context = @json.parse("{}")
  let expected = @json.parse("[1,2,3]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0074 flatten null" {
  let template = @json.parse("{\"$flatten\":null}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0075 flatten an object" {
  let template = @json.parse("{\"$flatten\":{\"a\":1,\"b\":2}}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0076 flatten an array of strings" {
  let template = @json.parse("{\"$flatten\":[\"a\",\"b\"]}")
  let context = @json.parse("{}")
  let expected = @json.parse("[\"a\",\"b\"]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0077 flatten an array of numbers" {
  let template = @json.parse("{\"$flatten\":[1,2]}")
  let context = @json.parse("{}")
  let expected = @json.parse("[1,2]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0078 flatten mixed types" {
  let template = @json.parse("{\"$flatten\":[[1,2],[[\"a\",\"b\"]],[{}],[[]]]}")
  let context = @json.parse("{}")
  let expected = @json.parse("[1,2,[\"a\",\"b\"],{},[]]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0079 flatten mixed levels" {
  let template = @json.parse("{\"$flatten\":[[1,[2,3]],[4],5]}")
  let context = @json.parse("{}")
  let expected = @json.parse("[1,[2,3],4,5]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0080 flatten with undefined properties" {
  let template = @json.parse(
    "{\"$flatten\":{\"$eval\":\"[[1], [2, 3]]\"},\"foo\":\"bar\"}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0081 simple flattenDeep" {
  let template = @json.parse("{\"$flattenDeep\":[[1,[2,[3]]]]}")
  let context = @json.parse("{}")
  let expected = @json.parse("[1,2,3]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0082 flattenDeep empty array" {
  let template = @json.parse("{\"$flattenDeep\":[]}")
  let context = @json.parse("{}")
  let expected = @json.parse("[]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0083 evaluated value" {
  let template = @json.parse(
    "{\"$flattenDeep\":{\"$eval\":\"[[1], [2, [3]]]\"}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("[1,2,3]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0084 flattenDeep empty array of arrays" {
  let template = @json.parse("{\"$flattenDeep\":[[]]}")
  let context = @json.parse("{}")
  let expected = @json.parse("[]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0085 flattenDeep null" {
  let template = @json.parse("{\"$flattenDeep\":null}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0086 flattenDeep an object" {
  let template = @json.parse("{\"$flattenDeep\":{\"a\":1,\"b\":2}}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0087 flattenDeep an array of strings" {
  let template = @json.parse("{\"$flattenDeep\":[\"a\",\"b\"]}")
  let context = @json.parse("{}")
  let expected = @json.parse("[\"a\",\"b\"]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0088 flattenDeep an array of numbers" {
  let template = @json.parse("{\"$flattenDeep\":[1,2]}")
  let context = @json.parse("{}")
  let expected = @json.parse("[1,2]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0089 flattenDeep mixed types" {
  let template = @json.parse(
    "{\"$flattenDeep\":[[1,2],[[\"a\",\"b\"]],[{}],[[]]]}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("[1,2,\"a\",\"b\",{}]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0090 flattenDeep mixed levels" {
  let template = @json.parse("{\"$flattenDeep\":[[1,[2,3]],[4],5]}")
  let context = @json.parse("{}")
  let expected = @json.parse("[1,2,3,4,5]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0091 flattenDeep with undefined properties" {
  let template = @json.parse(
    "{\"$flattenDeep\":[[1,[2,3]],[4],5],\"foo\":\"bar\"}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0092 $fromNow 1 years" {
  let template = @json.parse("{\"$fromNow\":\"1 years\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2018-01-19T16:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0093 $fromNow 1 year" {
  let template = @json.parse("{\"$fromNow\":\"1 year\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2018-01-19T16:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0094 $fromNow 1 yr" {
  let template = @json.parse("{\"$fromNow\":\"1 yr\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2018-01-19T16:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0095 $fromNow 1 y" {
  let template = @json.parse("{\"$fromNow\":\"1 y\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2018-01-19T16:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0096 $fromNow 1 months" {
  let template = @json.parse("{\"$fromNow\":\"1 months\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-02-18T16:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0097 $fromNow 1 month" {
  let template = @json.parse("{\"$fromNow\":\"1 month\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-02-18T16:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0098 $fromNow 30 mo" {
  let template = @json.parse("{\"$fromNow\":\"30 mo\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2019-07-08T16:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0099 $fromNow -30 mo" {
  let template = @json.parse("{\"$fromNow\":\"-30 mo\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2014-08-03T16:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0100 $fromNow 1 weeks" {
  let template = @json.parse("{\"$fromNow\":\"1 weeks\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-26T16:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0101 $fromNow 1 week" {
  let template = @json.parse("{\"$fromNow\":\"1 week\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-26T16:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0102 $fromNow 1 wk" {
  let template = @json.parse("{\"$fromNow\":\"1 wk\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-26T16:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0103 $fromNow 1 w" {
  let template = @json.parse("{\"$fromNow\":\"1 w\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-26T16:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0104 $fromNow 2 days" {
  let template = @json.parse("{\"$fromNow\":\"2 days\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-21T16:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0105 $fromNow 2 day" {
  let template = @json.parse("{\"$fromNow\":\"2 day\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-21T16:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0106 $fromNow 2 d" {
  let template = @json.parse("{\"$fromNow\":\"2 d\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-21T16:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0107 $fromNow 2 hours" {
  let template = @json.parse("{\"$fromNow\":\"2 hours\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-19T18:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0108 $fromNow -1 hour" {
  let template = @json.parse("{\"$fromNow\":\"-1 hour\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-19T15:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0109 $fromNow 1 hour" {
  let template = @json.parse("{\"$fromNow\":\"1 hour\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-19T17:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0110 $fromNow 3h" {
  let template = @json.parse("{\"$fromNow\":\"3h\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-19T19:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0111 $fromNow 1 minutes" {
  let template = @json.parse("{\"$fromNow\":\"1 minutes\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-19T16:28:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0112 $fromNow 1 m" {
  let template = @json.parse("{\"$fromNow\":\"1 minute\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-19T16:28:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0113 $fromNow 1 m" {
  let template = @json.parse("{\"$fromNow\":\"1 minute\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-19T16:28:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0114 $fromNow 12 min" {
  let template = @json.parse("{\"$fromNow\":\"12 min\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-19T16:39:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0115 $fromNow 12min" {
  let template = @json.parse("{\"$fromNow\":\"12min\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-19T16:39:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0116 $fromNow 1m" {
  let template = @json.parse("{\"$fromNow\":\"1m\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-19T16:28:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0117 $fromNow 11m" {
  let template = @json.parse("{\"$fromNow\":\"11m\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-19T16:38:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0118 $fromNow 11 m" {
  let template = @json.parse("{\"$fromNow\":\"11 m\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-19T16:38:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0119 $fromNow 1 seconds" {
  let template = @json.parse("{\"$fromNow\":\"1 seconds\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-19T16:27:21.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0120 $fromNow 1 second" {
  let template = @json.parse("{\"$fromNow\":\"1 second\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-19T16:27:21.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0121 $fromNow 1 sec" {
  let template = @json.parse("{\"$fromNow\":\"1 sec\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-19T16:27:21.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0122 $fromNow 1 s" {
  let template = @json.parse("{\"$fromNow\":\"1 s\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-19T16:27:21.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0123 $fromNow multiple units" {
  let template = @json.parse("{\"$fromNow\":\"1y2mo3w4d5h6m7s\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2018-04-14T21:33:27.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0124 $fromNow multiple units with whitespace" {
  let template = @json.parse("{\"$fromNow\":\"1 y 2 mo 3 w 4 d 5 h 6 m 7 s\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2018-04-14T21:33:27.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0125 $fromNow multiple units positive" {
  let template = @json.parse("{\"$fromNow\":\"+1y2mo3w4d5h6m7s\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2018-04-14T21:33:27.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0126 $fromNow multiple units negative" {
  let template = @json.parse("{\"$fromNow\":\"-1y2mo3w4d5h6m7s\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2015-10-27T11:21:13.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0127 $fromNow multiple units out of order" {
  let template = @json.parse("{\"$fromNow\":\"1s 1 y\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0128 $fromNow of non-string" {
  let template = @json.parse("{\"$fromNow\":13}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0129 $fromNow with eval" {
  let template = @json.parse(
    "{\"$fromNow\":{\"$eval\":\"str(ttl) + \\\" hours\\\"\"}}",
  )
  let context = @json.parse("{\"ttl\":24}")
  let expected = @json.parse("\"2017-01-20T16:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0130 $fromNow with redefined `now`" {
  let template = @json.parse(
    "{\"$let\":{\"now\":\"2019-01-01T01:00:00.123Z\"},\"in\":{\"$fromNow\":\"3 mo\"}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("\"2019-04-01T01:00:00.123Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0131 $fromNow with reference" {
  let template = @json.parse(
    "{\"$fromNow\":\"3 mo\",\"from\":{\"$eval\":\"when\"}}",
  )
  let context = @json.parse("{\"when\":\"2019-01-01T01:00:00.123Z\"}")
  let expected = @json.parse("\"2019-04-01T01:00:00.123Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0132 $fromNow with undefined properties" {
  let template = @json.parse(
    "{\"$fromNow\":\"3 mo\",\"from\":{\"$eval\":\"now\"},\"foo\":\"bar\"}",
  )
  let context = @json.parse("{\"now\":\"2019-01-01T01:00:00.123Z\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0133 wrap expressions with $eval" {
  let template = @json.parse("{\"$json\":{\"$eval\":\"a + b + 7\"}}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("\"10\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0134 unwrap expressions not evaluated" {
  let template = @json.parse("{\"$json\":\"a + b + 7\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("\"\\\"a + b + 7\\\"\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0135 $eval inside array" {
  let template = @json.parse("{\"$json\":[2,5,{\"$eval\":\"a + b + 7\"}]}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("\"[2,5,10]\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0136 ASCII non-printable character is u-escaped" {
  let template = @json.parse("{\"$json\":[\"\\u0010\"]}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"[\\\"\\\\u0010\\\"]\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0137 ASCII printable character is not escaped" {
  let template = @json.parse("{\"$json\":[\"Z\"]}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"[\\\"Z\\\"]\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0138 Unicode BMP character is not escaped" {
  let template = @json.parse("{\"$json\":[\"\\u0103\"]}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"[\\\"\\u0103\\\"]\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0139 sorting pairs by unicode key strings sorts lexically by codepoint" {
  let template = @json.parse(
    "{\"$json\":{\"\\u3347P\":1,\"\\ue1ff\\u0100\":2,\"UE\":3}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse(
    "\"{\\\"UE\\\":3,\\\"\\u3347P\\\":1,\\\"\\ue1ff\\u0100\\\":2}\"",
  )
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0140 sorting pairs by unicode key strings sorts lexically by codepoint, even with chars above base plane" {
  let template = @json.parse(
    "{\"$json\":{\"\\ud83e\\udc09\\u732b\":\"hey\",\"Z\\ud800\\udc00P\":1,\"\\udb47\\udfff\\u0103\":2,\"UaE\":3}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse(
    "\"{\\\"UaE\\\":3,\\\"Z\\ud800\\udc00P\\\":1,\\\"\\ud83e\\udc09\\u732b\\\":\\\"hey\\\",\\\"\\udb47\\udfff\\u0103\\\":2}\"",
  )
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0141 $json with undefined properties" {
  let template = @json.parse("{\"$json\":[1,2,true,{},[]],\"foo\":\"bar\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0142 $json can be evaluated to null without an error" {
  let template = @json.parse("{\"$json\":{\"$eval\":\"input\"}}")
  let context = @json.parse("{\"input\":null}")
  let expected = @json.parse("\"null\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0143 $eval" {
  let template = @json.parse("{\"$eval\":\"key.key2\"}")
  let context = @json.parse("{\"key\":{\"key2\":[\"value\",1,2,true,{}]}}")
  let expected = @json.parse("[\"value\",1,2,true,{}]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0144 $json" {
  let template = @json.parse("{\"$json\":{\"$eval\":\"key.key2\"}}")
  let context = @json.parse("{\"key\":{\"key2\":[1,2,true,{},[]]}}")
  let expected = @json.parse("\"[1,2,true,{},[]]\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0145 string interpolation" {
  let template = @json.parse(
    "{\"message\":\"hello ${key.key2}\",\"k-${key.key3}\":true}",
  )
  let context = @json.parse("{\"key\":{\"key2\":\"world\",\"key3\":1}}")
  let expected = @json.parse("{\"message\":\"hello world\",\"k-1\":true}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0146 string interpolation, first character" {
  let template = @json.parse("{\"message\":\"${somevalue}\"}")
  let context = @json.parse("{\"somevalue\":13}")
  let expected = @json.parse("{\"message\":\"13\"}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0147 no string interpolation with $$" {
  let template = @json.parse("{\"message\":\"$${somevalue}\"}")
  let context = @json.parse("{\"somevalue\":13}")
  let expected = @json.parse("{\"message\":\"${somevalue}\"}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0148 unterminated string interpolation" {
  let template = @json.parse("{\"message\":\"${somevalue\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0149 simple let" {
  let template = @json.parse(
    "{\"$let\":{\"ts\":100,\"foo\":200},\"in\":[{\"$eval\":\"ts+foo\"},{\"$eval\":\"ts-foo\"},{\"$eval\":\"ts*foo\"}]}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("[300,-100,20000]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0150 let with evaluated values" {
  let template = @json.parse(
    "{\"$let\":{\"thirty\":{\"$eval\":\"10 + 20\"}},\"in\":{\"$eval\":\"thirty+5\"}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("35")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0151 let with evaluated context" {
  let template = @json.parse(
    "{\"$let\":{\"$eval\":\"{\\\"thirty\\\": 10 + 20}\"},\"in\":{\"$eval\":\"thirty+5\"}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("35")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0152 context overriding" {
  let template = @json.parse(
    "{\"$let\":{\"x\":20},\"in\":{\"$eval\":\"x + y\"}}",
  )
  let context = @json.parse("{\"x\":10,\"y\":1}")
  let expected = @json.parse("21")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0153 nested let" {
  let template = @json.parse(
    "{\"$let\":{\"x\":20,\"y\":10},\"in\":{\"$let\":{\"x\":30},\"in\":{\"$eval\":\"x + y + z\"}}}",
  )
  let context = @json.parse("{\"x\":1,\"y\":2,\"z\":3}")
  let expected = @json.parse("43")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0154 let with undefined properties" {
  let template = @json.parse(
    "{\"$let\":{\"x\":1,\"y\":2},\"a\":{\"$eval\":\"x + y\"}}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0155 let without in" {
  let template = @json.parse("{\"$let\":{\"x\":1,\"y\":2}}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0156 let array" {
  let template = @json.parse("{\"$let\":[1,2],\"in\":{\"$eval\":\"1 + 2\"}}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0157 let null" {
  let template = @json.parse("{\"$let\":null,\"in\":{\"$eval\":\"1 + 2\"}}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0158 checking name begin with number" {
  let template = @json.parse(
    "{\"$let\":{\"ab\":100,\"bb\":200,\"2b\":5},\"in\":[{\"$eval\":\"ab+bb\"},{\"$eval\":\"ab-bb\"},{\"$eval\":\"ab*bb\"}]}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0159 checking space in variable name" {
  let template = @json.parse(
    "{\"$let\":{\"ab\":100,\"bb\":200,\"a b\":10},\"in\":[{\"$eval\":\"ab+bb\"},{\"$eval\":\"ab-bb\"},{\"$eval\":\"ab*bb\"}]}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0160 checking special character in variable name" {
  let template = @json.parse(
    "{\"$let\":{\"ab\":100,\"bb\":200,\"a.b\":10},\"in\":[{\"$eval\":\"ab+bb\"},{\"$eval\":\"ab-bb\"},{\"$eval\":\"ab*bb\"}]}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0161 checking empty name" {
  let template = @json.parse("{\"$let\":{\"\":10},\"in\":[]}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0162 checking integrity of operation $let with exact result" {
  let template = @json.parse(
    "{\"$let\":{\"ts\":100,\"foo\":200},\"in\":[{\"$eval\":\"ts+foo\"},{\"$eval\":\"ts-foo\"},{\"$eval\":\"ts*foo\"}]}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("[300,-100,20000]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0163 checking $let and $reverse operator integrity" {
  let template = @json.parse(
    "{\"$let\":{\"x\":[1,2,3]},\"in\":[{\"$reverse\":{\"$eval\":\"x\"}}]}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("[[3,2,1]]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0164 checking $let with $if without else" {
  let template = @json.parse(
    "{\"$let\":{\"a\":{\"$if\":\"c == \\\"item\\\"\",\"then\":\"value\"}},\"in\":{\"a\":\"${a}\"}}",
  )
  let context = @json.parse("{\"c\":\"itm\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0165 let with a value of $if-then-else" {
  let template = @json.parse(
    "{\"$let\":{\"$if\":\"something == 3\",\"then\":{\"a\":10,\"b\":20},\"else\":{\"a\":20,\"b\":10}},\"in\":{\"$eval\":\"a + b\"}}",
  )
  let context = @json.parse("{\"something\":3}")
  let expected = @json.parse("30")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0166 let with a rendered key" {
  let template = @json.parse(
    "{\"$let\":{\"first_${name}\":1,\"second_${name}\":2},\"in\":{\"$eval\":\"first_prize + second_prize\"}}",
  )
  let context = @json.parse("{\"name\":\"prize\"}")
  let expected = @json.parse("3")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0167 let using values from the parent context" {
  let template = @json.parse(
    "{\"$let\":{\"b\":{\"$eval\":\"a + 10\"}},\"in\":{\"$eval\":\"a + b\"}}",
  )
  let context = @json.parse("{\"a\":5}")
  let expected = @json.parse("20")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0168 let with a non-object rendered value (array)" {
  let template = @json.parse(
    "{\"$let\":{\"$eval\":\"[1, 2]\"},\"in\":\"uhoh\"}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0169 let with a non-object rendered value (string)" {
  let template = @json.parse("{\"$let\":\"${name}\",\"in\":\"uhoh\"}")
  let context = @json.parse("{\"name\":\"fido\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0170 let with a non-object rendered value (boolean)" {
  let template = @json.parse("{\"$let\":{\"$eval\":\"true\"},\"in\":\"uhoh\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0171 fromNow with redefined `now`" {
  let template = @json.parse(
    "{\"$let\":{\"now\":\"2017-01-01T01:00:00.123Z\"},\"in\":{\"$eval\":\"fromNow('1 day')\"}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-02T01:00:00.123Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0172 defined with empty variable from a let expression" {
  let template = @json.parse(
    "{\"$let\":{\"var\":10},\"in\":{\"$if\":\"defined('var')\",\"then\":\"t\",\"else\":\"f\"}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("\"t\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0173 $let with nested redefinitions of builtins" {
  let template = @json.parse(
    "{\"$let\":{\"lowercase\":{\"$eval\":\"uppercase\"}},\"in\":{\"$let\":{\"var\":10},\"in\":{\"$if\":\"defined('var')\",\"then\":\"${lowercase('t')}\",\"else\":\"${lowercase('f')}\"}}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("\"T\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0174 $let with nested redefinitions of builtins" {
  let template = @json.parse(
    "{\"$let\":{\"fromNow\":{\"$eval\":\"uppercase\"}},\"in\":{\"$let\":{\"var\":10},\"in\":{\"$if\":\"defined('var')\",\"then\":\"${fromNow('1 hour')}\",\"else\":\"f\"}}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("\"1 HOUR\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0175 $let doesn't leak variables" {
  let template = @json.parse(
    "[{\"$let\":{\"foo\":\"bar\",\"baz\":\"qux\"},\"in\":{\"$eval\":\"foo\"}},{\"$eval\":\"foo\"}]",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0176 simple map" {
  let template = @json.parse(
    "{\"$map\":[2,4,6],\"each(x)\":{\"$eval\":\"x + a\"}}",
  )
  let context = @json.parse("{\"a\":1}")
  let expected = @json.parse("[3,5,7]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0177 map to objects" {
  let template = @json.parse(
    "{\"$map\":[2,4,6],\"each(x)\":{\"asText\":\"${x + a}\",\"integer\":{\"$eval\":\"x + a\"}}}",
  )
  let context = @json.parse("{\"a\":1}")
  let expected = @json.parse(
    "[{\"asText\":\"3\",\"integer\":3},{\"asText\":\"5\",\"integer\":5},{\"asText\":\"7\",\"integer\":7}]",
  )
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0178 complex identifier" {
  let template = @json.parse(
    "{\"$map\":[2,4,6],\"each(my_identifier97)\":{\"$eval\":\"my_identifier97 + a\"}}",
  )
  let context = @json.parse("{\"a\":1}")
  let expected = @json.parse("[3,5,7]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0179 must wrap expressions with $eval" {
  let template = @json.parse(
    "{\"$map\":[2,4,6],\"each(my_identifier97)\":\"my_identifier97 + a\"}",
  )
  let context = @json.parse("{\"a\":1}")
  let expected = @json.parse(
    "[\"my_identifier97 + a\",\"my_identifier97 + a\",\"my_identifier97 + a\"]",
  )
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0180 can take from objects" {
  let template = @json.parse(
    "{\"$map\":[{\"k\":1},{\"k\":2},{\"k\":3}],\"each(y)\":{\"$eval\":\"y.k\"}}",
  )
  let context = @json.parse("{\"a\":1}")
  let expected = @json.parse("[1,2,3]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0181 value is rendered" {
  let template = @json.parse(
    "{\"$map\":{\"$eval\":\"[{k: 1}, {k: 2}, {k: 3}]\"},\"each(y)\":{\"$eval\":\"y.k\"}}",
  )
  let context = @json.parse("{\"a\":1}")
  let expected = @json.parse("[1,2,3]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0182 can make objects too" {
  let template = @json.parse(
    "{\"$map\":[{\"k\":1},{\"k\":2},{\"k\":3}],\"each(y)\":{\"k\":{\"$eval\":\"y.k + 1\"},\"v\":\"before=${y.k}\"}}",
  )
  let context = @json.parse("{\"a\":1}")
  let expected = @json.parse(
    "[{\"k\":2,\"v\":\"before=1\"},{\"k\":3,\"v\":\"before=2\"},{\"k\":4,\"v\":\"before=3\"}]",
  )
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0183 respects delete-marker from $if" {
  let template = @json.parse(
    "{\"$map\":[{\"k\":1},{\"k\":2},{\"k\":3}],\"each(y)\":{\"$if\":\"y.k != 2\",\"then\":{\"$eval\":\"y.k\"}}}",
  )
  let context = @json.parse("{\"a\":1}")
  let expected = @json.parse("[1,3]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0184 $map works on object" {
  let template = @json.parse(
    "{\"$map\":{\"a\":1,\"b\":2,\"c\":3},\"each(y)\":{\"${y.key}x\":{\"$eval\":\"y.val + 1\"}}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("{\"ax\":2,\"bx\":3,\"cx\":4}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0185 $map each(value,key) on object" {
  let template = @json.parse(
    "{\"$map\":{\"a\":1,\"b\":2,\"c\":3},\"each(v,k)\":{\"${k}x\":{\"$eval\":\"v + 1\"}}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("{\"ax\":2,\"bx\":3,\"cx\":4}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0186 $map can add new keys to object" {
  let template = @json.parse(
    "{\"$map\":{\"a\":1,\"b\":2,\"c\":3},\"each(y)\":{\"${y.key}\":{\"$eval\":\"y.val\"},\"${y.key}x\":{\"$eval\":\"y.val + 1\"}}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse(
    "{\"a\":1,\"b\":2,\"c\":3,\"ax\":2,\"bx\":3,\"cx\":4}",
  )
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0187 $map array index variable" {
  let template = @json.parse(
    "{\"$map\":[\"a\",\"b\",\"c\"],\"each(y,i)\":\"${y}-${i}\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("[\"a-0\",\"b-1\",\"c-2\"]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0188 $map no args" {
  let template = @json.parse(
    "{\"$map\":\"a, b, c\",\"each()\":{\"$eval\":\"y.k\"}}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0189 $map too many args" {
  let template = @json.parse(
    "{\"$map\":\"a, b, c\",\"each(k,v,i)\":{\"$eval\":\"y.k\"}}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0190 $map requires an array, not string" {
  let template = @json.parse(
    "{\"$map\":\"a, b, c\",\"each(y)\":{\"$eval\":\"y.k\"}}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0191 $map requires an array, not number" {
  let template = @json.parse("{\"$map\":10.1,\"each(y)\":{\"$eval\":\"y.k\"}}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0192 $map requires an array, not null" {
  let template = @json.parse("{\"$map\":null,\"each(y)\":{\"$eval\":\"y.k\"}}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0193 map with undefined properties" {
  let template = @json.parse(
    "{\"$map\":[2,4,6],\"each(x)\":{\"$eval\":\"x + a\"},\"foo\":\"bar\"}",
  )
  let context = @json.parse("{\"a\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0194 $map as object and each(identifier) as array" {
  let template = @json.parse(
    "{\"$map\":{\"hello\":5,\"test\":9},\"each(x)\":[\"${x.key}\",{\"$eval\":\"x.val+1\"}]}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0195 $map over object, two vars" {
  let template = @json.parse(
    "{\"$map\":{\"a\":1,\"b\":2,\"c\":3},\"each(v,k)\":{\"${k}x\":{\"$eval\":\"v + 1\"}}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("{\"ax\":2,\"bx\":3,\"cx\":4}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0196 $map over object, one var" {
  let template = @json.parse(
    "{\"$map\":{\"a\":1,\"b\":2,\"c\":3},\"each(y)\":{\"${y.key}x\":{\"$eval\":\"y.val + 1\"}}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("{\"ax\":2,\"bx\":3,\"cx\":4}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0197 range without step creates list of numbers" {
  let template = @json.parse(
    "{\"$map\":{\"$eval\":\"range(1, 5)\"},\"each(x)\":{\"$eval\":\"x\"}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("[1,2,3,4]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0198 range with end > start creates empty list" {
  let template = @json.parse("{\"$eval\":\"len(range(5, 1))\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("0")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0199 range with step creates list of numbers" {
  let template = @json.parse(
    "{\"$map\":{\"$eval\":\"range(1, 10, 2)\"},\"each(x)\":{\"$eval\":\"x\"}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("[1,3,5,7,9]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0200 range with negative step creates list of numbers" {
  let template = @json.parse(
    "{\"$map\":{\"$eval\":\"range(1, -2, -1)\"},\"each(x)\":{\"$eval\":\"x\"}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("[1,0,-1]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0201 range with negative step and negative start and end creates list of numbers" {
  let template = @json.parse(
    "{\"$map\":{\"$eval\":\"range(-7, -10, -1)\"},\"each(x)\":{\"$eval\":\"x\"}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("[-7,-8,-9]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0202 range with negative step that does not divide evenly" {
  let template = @json.parse(
    "{\"$map\":{\"$eval\":\"range(20, 0, -7)\"},\"each(x)\":{\"$eval\":\"x\"}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("[20,13,6]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0203 range with step=0 throws error" {
  let template = @json.parse(
    "{\"$map\":{\"$eval\":\"range(1, 5, 0)\"},\"each(x)\":{\"$eval\":\"x\"}}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0204 range with float step throws error" {
  let template = @json.parse(
    "{\"$map\":{\"$eval\":\"range(1, 5, 1.2)\"},\"each(x)\":{\"$eval\":\"x\"}}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0205 range with float start throws error" {
  let template = @json.parse(
    "{\"$map\":{\"$eval\":\"range(1.3, 5)\"},\"each(x)\":{\"$eval\":\"x\"}}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0206 range with string start throws error" {
  let template = @json.parse(
    "{\"$map\":{\"$eval\":\"range(\\\"1\\\", 5)\"},\"each(x)\":{\"$eval\":\"x\"}}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0207 range without step creates list of objects" {
  let template = @json.parse(
    "{\"$map\":{\"$eval\":\"range(1, 4)\"},\"each(x)\":{\"asText\":\"${x}\",\"integer\":{\"$eval\":\"x\"}}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse(
    "[{\"asText\":\"1\",\"integer\":1},{\"asText\":\"2\",\"integer\":2},{\"asText\":\"3\",\"integer\":3}]",
  )
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0208 range without step creates list of strings" {
  let template = @json.parse(
    "{\"$map\":{\"$eval\":\"range(10, 12)\"},\"each(x,i)\":\"id_${x}_${i}\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("[\"id_10_0\",\"id_11_1\"]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0209 range with step creates list of strings" {
  let template = @json.parse(
    "{\"$map\":{\"$eval\":\"range(10, 20, 5)\"},\"each(x,i)\":\"id_${x}_${i}\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("[\"id_10_0\",\"id_15_1\"]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0210 range without step creates objects" {
  let template = @json.parse(
    "{\"$map\":{\"$eval\":\"range(1, 3)\"},\"each(y)\":{\"k\":{\"$eval\":\"y + 1\"},\"v\":\"before=${y}\"}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse(
    "[{\"k\":2,\"v\":\"before=1\"},{\"k\":3,\"v\":\"before=2\"}]",
  )
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0211 reduce array into number" {
  let template = @json.parse(
    "{\"$reduce\":[2,4,6],\"each(acc, x)\":{\"$eval\":\"acc + x\"},\"initial\":0}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("12")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0212 reduce array with indexes into number" {
  let template = @json.parse(
    "{\"$reduce\":[2,4,6],\"each(acc, x, i)\":{\"$eval\":\"acc + x * 10 ** i\"},\"initial\":0}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("642")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0213 reduce array into string" {
  let template = @json.parse(
    "{\"$reduce\":[2,4,6],\"each(acc, x)\":\"${acc}${x}\",\"initial\":\"pre \"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("\"pre 246\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0214 reduce array into boolean" {
  let template = @json.parse(
    "{\"$reduce\":[2,4,6],\"each(acc, x)\":{\"$eval\":\"acc || x > 5\"},\"initial\":false}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0215 reduce array into object" {
  let template = @json.parse(
    "{\"$reduce\":[2,4,6],\"each(acc, x, i)\":{\"$merge\":[{\"$eval\":\"acc\"},{\"k${i}\":{\"$eval\":\"x\"}}]},\"initial\":{\"a\":0}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("{\"a\":0,\"k0\":2,\"k1\":4,\"k2\":6}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0216 reduce over an object" {
  let template = @json.parse(
    "{\"$reduce\":{\"a\":2,\"b\":4,\"c\":6},\"each(acc, v, k)\":{\"$eval\":\"acc + v\"},\"initial\":0}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0217 reduce skips delete-marker from $if" {
  let template = @json.parse(
    "{\"$reduce\":[2,4,6],\"initial\":0,\"each(acc, v, i)\":{\"$if\":\"v != 4\",\"then\":{\"$eval\":\"acc + v\"}}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("8")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0218 reduce with undefined properties" {
  let template = @json.parse(
    "{\"$reduce\":[2,4,6],\"each(acc, x)\":{\"$eval\":\"acc + x\"},\"initial\":0,\"foo\":\"bar\"}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0219 reduce with missing initial" {
  let template = @json.parse(
    "{\"$reduce\":[2,4,6],\"each(acc, x)\":{\"$eval\":\"acc + x\"}}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0220 reduce with missing initial with undefined properties" {
  let template = @json.parse(
    "{\"$reduce\":[2,4,6],\"each(acc, x)\":{\"$eval\":\"acc + x\"},\"init\":9}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0221 reduce with missing each" {
  let template = @json.parse("{\"$reduce\":[2,4,6],\"initial\":0}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0222 reduce with missing each with undefined properties" {
  let template = @json.parse(
    "{\"$reduce\":[2,4,6],\"each\":\"acc + x\",\"initial\":0}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0223 reduce over a number" {
  let template = @json.parse(
    "{\"$reduce\":10,\"each(acc, x)\":{\"$eval\":\"acc + x\"},\"initial\":0}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0224 reduce over a string" {
  let template = @json.parse(
    "{\"$reduce\":\"A Thing that is a String\",\"each(acc, x)\":{\"$eval\":\"acc + x\"},\"initial\":0}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0225 $find, simple find" {
  let template = @json.parse("{\"$find\":[2,4,6],\"each(x)\":\"x == 2\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0226 $find, simple find with context" {
  let template = @json.parse("{\"$find\":[2,4,6],\"each(x)\":\"x == a\"}")
  let context = @json.parse("{\"a\":2}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0227 $find respects delete marker" {
  let template = @json.parse(
    "{\"a\":1,\"b\":{\"$find\":[1,2,3],\"each(x)\":\"x > 4\"}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("{\"a\":1}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0228 $find, complicated find with $let" {
  let template = @json.parse(
    "{\"$let\":{\"needle\":{\"$find\":[1,2,3],\"each(entry)\":\"entry == 2\"}},\"in\":{\"$eval\":\"needle\"}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0229 $find complex identifier" {
  let template = @json.parse(
    "{\"$find\":[2,4,6],\"each(my_identifier97)\":\"my_identifier97 == 1 || my_identifier97 == 4\"}",
  )
  let context = @json.parse("{\"a\":1}")
  let expected = @json.parse("4")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0230 $find array index variable" {
  let template = @json.parse("{\"$find\":[1,2,3],\"each(y,i)\":\"i == 2\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("3")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0231 $find no args" {
  let template = @json.parse("{\"$find\":[1,2,3],\"each()\":\"y.k\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0232 $find too many args" {
  let template = @json.parse("{\"$find\":[1,2,3],\"each(k,v,i)\":\"y.k\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0233 $find requires an array, not string" {
  let template = @json.parse("{\"$find\":\"a, b, c\",\"each(y)\":\"y.k\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0234 $find requires an array, not number" {
  let template = @json.parse("{\"$find\":10.1,\"each(y)\":\"y.k\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0235 $find requires an array, not null" {
  let template = @json.parse("{\"$find\":null,\"each(y)\":\"y.k\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0236 $find requires an array, not object" {
  let template = @json.parse("{\"$find\":{\"a\":1},\"each(y)\":\"y.k\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0237 $find with undefined properties" {
  let template = @json.parse(
    "{\"$find\":[2,4,6],\"each(x)\":\"x + a\",\"foo\":\"bar\"}",
  )
  let context = @json.parse("{\"a\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0238 $find each must be string, not number" {
  let template = @json.parse("{\"$find\":[1,2,3],\"each(a)\":1}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0239 $find each must be string, not object" {
  let template = @json.parse("{\"$find\":[1,2,3],\"each(a)\":{\"a\":1}}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0240 $match, 2 matches, ordered by lexcial sorting of property names" {
  let template = @json.parse(
    "{\"$match\":{\"cond == 3\":2,\"cond == 5\":3,\"cond < 5 && cond > 0\":4,\"true\":17}}",
  )
  let context = @json.parse("{\"cond\":3}")
  let expected = @json.parse("[4,2,17]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0241 $match, no matches" {
  let template = @json.parse(
    "{\"$match\":{\"cond > 5\":2,\"cond == 5\":3,\"cond == 4 || cond < 1\":4}}",
  )
  let context = @json.parse("{\"cond\":3}")
  let expected = @json.parse("[]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0242 $match, 1 match in array" {
  let template = @json.parse(
    "[0,{\"$match\":{\"cond == 3\":2,\"cond == 5\":3}}]",
  )
  let context = @json.parse("{\"cond\":3}")
  let expected = @json.parse("[0,[2]]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0243 $match, 0 matches in array" {
  let template = @json.parse(
    "[0,{\"$match\":{\"cond > 3\":2,\"cond == 5\":3}}]",
  )
  let context = @json.parse("{\"cond\":3}")
  let expected = @json.parse("[0,[]]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0244 $match, 1 match in object" {
  let template = @json.parse(
    "{\"key\":0,\"banana\":{\"$match\":{\"cond == 3\":2,\"cond == 5\":3}}}",
  )
  let context = @json.parse("{\"cond\":3}")
  let expected = @json.parse("{\"key\":0,\"banana\":[2]}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0245 $match, 0 matches in object" {
  let template = @json.parse(
    "{\"key\":0,\"banana\":{\"$match\":{\"cond > 3\":2,\"cond == 5\":3}}}",
  )
  let context = @json.parse("{\"cond\":3}")
  let expected = @json.parse("{\"key\":0,\"banana\":[]}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0246 $match, is not an object" {
  let template = @json.parse("{\"$match\":[{\"cond < 5 && cond > 0\":2}]}")
  let context = @json.parse("{\"cond\":3}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0247 $match, value that also needs evaluation" {
  let template = @json.parse(
    "{\"$match\":{\"cond == 3\":{\"$if\":\"ifcond\",\"then\":\"t\",\"else\":\"f\"}}}",
  )
  let context = @json.parse("{\"cond\":3,\"ifcond\":false}")
  let expected = @json.parse("[\"f\"]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0248 $switch, 1 match" {
  let template = @json.parse("{\"$switch\":{\"cond == 3\":2,\"cond == 5\":3}}")
  let context = @json.parse("{\"cond\":3}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0249 $switch, 2 matches" {
  let template = @json.parse("{\"$switch\":{\"cond == 3\":2,\"cond > 1\":3}}")
  let context = @json.parse("{\"cond\":3}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0250 $switch, no matches" {
  let template = @json.parse(
    "{\"$switch\":{\"cond > 5\":2,\"cond == 5\":3,\"cond == 4 || cond < 1\":4}}",
  )
  let context = @json.parse("{\"cond\":3}")
  let expected = @json.parse("null")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0251 $switch, 1 match in array" {
  let template = @json.parse(
    "[0,{\"$switch\":{\"cond == 3\":2,\"cond == 5\":3}}]",
  )
  let context = @json.parse("{\"cond\":3}")
  let expected = @json.parse("[0,2]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0252 $switch, 0 matches in array" {
  let template = @json.parse(
    "[0,{\"$switch\":{\"cond > 3\":2,\"cond == 5\":3}}]",
  )
  let context = @json.parse("{\"cond\":3}")
  let expected = @json.parse("[0]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0253 $switch, 1 match in object" {
  let template = @json.parse(
    "{\"key\":0,\"banana\":{\"$switch\":{\"cond == 3\":2,\"cond == 5\":3}}}",
  )
  let context = @json.parse("{\"cond\":3}")
  let expected = @json.parse("{\"key\":0,\"banana\":2}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0254 $switch, 0 matches in object" {
  let template = @json.parse(
    "{\"key\":0,\"banana\":{\"$switch\":{\"cond > 3\":2,\"cond == 5\":3}}}",
  )
  let context = @json.parse("{\"cond\":3}")
  let expected = @json.parse("{\"key\":0}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0255 $switch, is not an object" {
  let template = @json.parse("{\"$switch\":[{\"cond < 5 && cond > 0\":2}]}")
  let context = @json.parse("{\"cond\":3}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0256 $switch, value that also needs evaluation" {
  let template = @json.parse(
    "{\"$switch\":{\"cond == 3\":{\"$if\":\"ifcond\",\"then\":\"t\",\"else\":\"f\"}}}",
  )
  let context = @json.parse("{\"cond\":3,\"ifcond\":false}")
  let expected = @json.parse("\"f\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0257 $switch, fallback to $default" {
  let template = @json.parse(
    "{\"$switch\":{\"cond == 3\":1,\"$default\":\"fallback\"}}",
  )
  let context = @json.parse("{\"cond\":4}")
  let expected = @json.parse("\"fallback\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0258 $switch, $default value that also needs evaluation" {
  let template = @json.parse(
    "{\"$switch\":{\"cond == 3\":1,\"$default\":{\"$if\":\"ifcond\",\"then\":\"t\",\"else\":\"f\"}}}",
  )
  let context = @json.parse("{\"cond\":4,\"ifcond\":false}")
  let expected = @json.parse("\"f\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0259 $switch, $default with 1 match in object" {
  let template = @json.parse(
    "{\"$switch\":{\"cond == 3\":1,\"$default\":\"fallback\"}}",
  )
  let context = @json.parse("{\"cond\":3}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0260 $switch, $default of empty string" {
  let template = @json.parse("{\"$switch\":{\"false\":1,\"$default\":\"\"}}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0261 $switch, $default of empty string not a deletion marker" {
  let template = @json.parse("[{\"$switch\":{\"false\":1,\"$default\":\"\"}}]")
  let context = @json.parse("{}")
  let expected = @json.parse("[\"\"]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0262 $switch, $default of false" {
  let template = @json.parse("{\"$switch\":{\"false\":1,\"$default\":false}}")
  let context = @json.parse("{}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0263 $switch, $default of false not a deletion marker" {
  let template = @json.parse("[{\"$switch\":{\"false\":1,\"$default\":false}}]")
  let context = @json.parse("{}")
  let expected = @json.parse("[false]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0264 $switch, $default of null" {
  let template = @json.parse("{\"$switch\":{\"false\":1,\"$default\":null}}")
  let context = @json.parse("{}")
  let expected = @json.parse("null")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0265 $switch, $default of null not a deletion marker" {
  let template = @json.parse("[{\"$switch\":{\"false\":1,\"$default\":null}}]")
  let context = @json.parse("{}")
  let expected = @json.parse("[null]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0266 $switch, $default of 0" {
  let template = @json.parse("{\"$switch\":{\"false\":1,\"$default\":0}}")
  let context = @json.parse("{}")
  let expected = @json.parse("0")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0267 $switch, $default of 0 not a deletion marker" {
  let template = @json.parse("[{\"$switch\":{\"false\":1,\"$default\":0}}]")
  let context = @json.parse("{}")
  let expected = @json.parse("[0]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0268 simple merge" {
  let template = @json.parse(
    "{\"$merge\":[{\"a\":1,\"b\":1},{\"b\":2,\"c\":3},{\"d\":4}]}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("{\"a\":1,\"b\":2,\"c\":3,\"d\":4}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0269 value is evaluated" {
  let template = @json.parse(
    "{\"$merge\":[{\"a\":1,\"b\":1},{\"b\":2,\"c\":3},{\"$eval\":\"defaults\"}]}",
  )
  let context = @json.parse("{\"defaults\":{\"d\":4}}")
  let expected = @json.parse("{\"a\":1,\"b\":2,\"c\":3,\"d\":4}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0270 merge empty array" {
  let template = @json.parse("{\"$merge\":[]}")
  let context = @json.parse("{}")
  let expected = @json.parse("{}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0271 merge empty array with empty object" {
  let template = @json.parse("{\"$merge\":[{}]}")
  let context = @json.parse("{}")
  let expected = @json.parse("{}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0272 merge null" {
  let template = @json.parse("{\"$merge\":null}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0273 $merge [null]" {
  let template = @json.parse("{\"$merge\":[null]}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0274 merge with undefined properties" {
  let template = @json.parse(
    "{\"$merge\":[{\"a\":1},{\"b\":2,\"c\":3},{\"d\":4}],\"foo\":\"bar\",\"bing\":\"baz\"}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0275 merge preserves a literal __proto__ key" {
  let template = @json.parse("{\"$merge\":[{\"__proto__\":1},{\"a\":2}]}")
  let context = @json.parse("{}")
  let expected = @json.parse("{\"__proto__\":1,\"a\":2}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0276 simple non-deep mergeDeep matches merge" {
  let template = @json.parse(
    "{\"$mergeDeep\":[{\"a\":1,\"b\":1},{\"b\":2,\"c\":3},{\"d\":4}]}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("{\"a\":1,\"b\":2,\"c\":3,\"d\":4}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0277 deep merge of lists appends" {
  let template = @json.parse("{\"$mergeDeep\":[{\"a\":[1,2]},{\"a\":[3,4]}]}")
  let context = @json.parse("{}")
  let expected = @json.parse("{\"a\":[1,2,3,4]}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0278 deep merge of objects merges" {
  let template = @json.parse(
    "{\"$mergeDeep\":[{\"a\":{\"x\":1,\"y\":2}},{\"a\":{\"y\":3,\"z\":4}}]}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("{\"a\":{\"x\":1,\"y\":3,\"z\":4}}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0279 very deep merge" {
  let template = @json.parse(
    "{\"$mergeDeep\":[{\"task\":{\"payload\":{\"command\":[\"a\",\"b\"]}}},{\"task\":{\"extra\":{\"foo\":\"bar\"}}},{\"task\":{\"payload\":{\"command\":[\"c\"]}}}]}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse(
    "{\"task\":{\"extra\":{\"foo\":\"bar\"},\"payload\":{\"command\":[\"a\",\"b\",\"c\"]}}}",
  )
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0280 value is evaluated" {
  let template = @json.parse(
    "{\"$mergeDeep\":[{\"a\":1,\"b\":1},{\"b\":2,\"c\":3},{\"$eval\":\"defaults\"}]}",
  )
  let context = @json.parse("{\"defaults\":{\"d\":4}}")
  let expected = @json.parse("{\"a\":1,\"b\":2,\"c\":3,\"d\":4}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0281 mergeDeep empty array" {
  let template = @json.parse("{\"$mergeDeep\":[]}")
  let context = @json.parse("{}")
  let expected = @json.parse("{}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0282 mergeDeep empty array with empty object" {
  let template = @json.parse("{\"$mergeDeep\":[{}]}")
  let context = @json.parse("{}")
  let expected = @json.parse("{}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0283 mergeDeep null" {
  let template = @json.parse("{\"$mergeDeep\":null}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0284 $mergeDeep [null]" {
  let template = @json.parse("{\"$mergeDeep\":[null]}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0285 mergeDeep with undefined properties" {
  let template = @json.parse(
    "{\"$mergeDeep\":[{\"a\":{\"x\":1,\"y\":2}},{\"a\":{\"y\":3,\"z\":4}}],\"foo\":\"bar\",\"bing\":\"baz\"}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0286 mergeDeep preserves a literal __proto__ key" {
  let template = @json.parse("{\"$mergeDeep\":[{\"__proto__\":1},{\"a\":2}]}")
  let context = @json.parse("{}")
  let expected = @json.parse("{\"__proto__\":1,\"a\":2}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0287 mergeDeep preserves a literal __proto__ key when merging nested objects" {
  let template = @json.parse(
    "{\"$mergeDeep\":[{\"__proto__\":{\"x\":1}},{\"__proto__\":{\"y\":2}}]}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("{\"__proto__\":{\"x\":1,\"y\":2}}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0288 simple sort" {
  let template = @json.parse("{\"$sort\":[3,4,1,2]}")
  let context = @json.parse("{}")
  let expected = @json.parse("[1,2,3,4]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0289 simple sort of strings (shortest first)" {
  let template = @json.parse(
    "{\"$sort\":[\"android\",\"aardvark\",\"add\",\"adderall\"]}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("[\"aardvark\",\"add\",\"adderall\",\"android\"]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0290 simple sort of multi-digit numbers" {
  let template = @json.parse("{\"$sort\":[111,22,3]}")
  let context = @json.parse("{}")
  let expected = @json.parse("[3,22,111]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0291 sort of mixed array" {
  let template = @json.parse("{\"$sort\":[1,\"2\",2,3,\"111\",\"112\"]}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0292 simple sort with $eval" {
  let template = @json.parse("{\"$sort\":{\"$eval\":\"array\"}}")
  let context = @json.parse("{\"array\":[3,4,1,2]}")
  let expected = @json.parse("[1,2,3,4]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0293 sort by, returning number" {
  let template = @json.parse(
    "{\"$sort\":[{\"a\":20},{\"a\":10,\"b\":[]},{\"a\":3}],\"by(x)\":\"x.a\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("[{\"a\":3},{\"a\":10,\"b\":[]},{\"a\":20}]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0294 sort by, returning string" {
  let template = @json.parse(
    "{\"$sort\":[{\"s\":\"android\"},{\"s\":\"add\"},{\"s\":\"adderall\"}],\"by(x)\":\"x.s\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse(
    "[{\"s\":\"add\"},{\"s\":\"adderall\"},{\"s\":\"android\"}]",
  )
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0295 cannot sort objects without by" {
  let template = @json.parse(
    "{\"$sort\":[{\"a\":2},{\"a\":1,\"b\":[]},{\"a\":3}]}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0296 by cannot return objects" {
  let template = @json.parse(
    "{\"$sort\":[{\"a\":2},{\"a\":1,\"b\":[]},{\"a\":3}],\"by(x)\":\"x\"}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0297 cannot sort arrays without by" {
  let template = @json.parse("{\"$sort\":[[1,2,3],[4,5],[],[8,9,10]]}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0298 by cannot return arrays" {
  let template = @json.parse(
    "{\"$sort\":[[1,2,3],[4,5],[],[8,9,10]],\"by(x)\":\"x\"}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0299 cannot sort nulls" {
  let template = @json.parse("{\"$sort\":[null,null]}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0300 cannot sort nulls, even with by" {
  let template = @json.parse("{\"$sort\":[null,null],\"by(x)\":\"x\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0301 cannot sort booleans" {
  let template = @json.parse("{\"$sort\":[false,true]}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0302 cannot sort booleans, even with by" {
  let template = @json.parse("{\"$sort\":[false,true],\"by(x)\":\"x\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0303 cannot sort numbers and strings together" {
  let template = @json.parse("{\"$sort\":[1,\"a\"]}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0304 cannot sort numbers and strings together even with by" {
  let template = @json.parse("{\"$sort\":[1,\"a\"],\"by(x)\":\"x\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0305 sort requires an array (string)" {
  let template = @json.parse("{\"$sort\":\"some string\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0306 sort requires an array (number)" {
  let template = @json.parse("{\"$sort\":34}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0307 sort requires an array (object)" {
  let template = @json.parse("{\"$sort\":{\"k\":1,\"b\":4,\"x\":8}}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0308 sort requires an array (null)" {
  let template = @json.parse("{\"$sort\":null}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0309 sort with undefined properties" {
  let template = @json.parse(
    "{\"$sort\":[{\"s\":\"android\"},{\"s\":\"add\"},{\"s\":\"adderall\"}],\"by(x)\":\"x.s\",\"foo\":\"bar\"}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0310 $sort variable not used (in context)" {
  let template = @json.parse("{\"$sort\":[2,1,3],\"by(x)\":\"foo\"}")
  let context = @json.parse("{\"foo\":1}")
  let expected = @json.parse("[2,1,3]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0311 $sort variable not used (not in context)" {
  let template = @json.parse("{\"$sort\":[2,1,3],\"by(x)\":\"foo\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0312 $sort is stable" {
  let template = @json.parse(
    "{\"$sort\":[\"aa\",\"dd\",\"ac\",\"ba\",\"ab\"],\"by(x)\":\"x[0]\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("[\"aa\",\"ac\",\"ab\",\"ba\",\"dd\"]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0313 $sort of very large integers" {
  let template = @json.parse(
    "{\"$sort\":[1111111111111111111111,22222222222222222222,3333333,444]}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse(
    "[444,3333333,22222222222222222222,1111111111111111111111]",
  )
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0314 simple reverse" {
  let template = @json.parse("{\"$reverse\":[3,4,1,2]}")
  let context = @json.parse("{}")
  let expected = @json.parse("[2,1,4,3]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0315 value is rendered" {
  let template = @json.parse("{\"$reverse\":{\"$eval\":\"[99, 999, 9]\"}}")
  let context = @json.parse("{}")
  let expected = @json.parse("[9,999,99]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0316 reverse of an object" {
  let template = @json.parse("{\"$reverse\":{\"a\":1}}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0317 reverse of null" {
  let template = @json.parse("{\"$reverse\":null}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0318 reverse of a string" {
  let template = @json.parse("{\"$reverse\":\"foo\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0319 reverse of a number" {
  let template = @json.parse("{\"$reverse\":1}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0320 reverse of a boolean" {
  let template = @json.parse("{\"$reverse\":true}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0321 simple reverse with $eval" {
  let template = @json.parse("{\"$reverse\":{\"$eval\":\"key\"}}")
  let context = @json.parse("{\"key\":[3,4,1,2]}")
  let expected = @json.parse("[2,1,4,3]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0322 simple reverse + $sort" {
  let template = @json.parse("{\"$reverse\":{\"$sort\":[3,4,1,2]}}")
  let context = @json.parse("{}")
  let expected = @json.parse("[4,3,2,1]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0323 reverse with undefined properties" {
  let template = @json.parse(
    "{\"$reverse\":[3,4,1,2],\"foo\":\"bar\",\"bing\":\"baz\"}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0324 $eval of $eval" {
  let template = @json.parse("{\"$eval\":{\"$eval\":\"\\\"13\\\"\"}}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0325 $eval with trailing characters" {
  let template = @json.parse("{\"$eval\":\"\\\"13\\\" 13\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0326 $eval with undefined properties" {
  let template = @json.parse("{\"$eval\":\"13\",\"wrong\":\"a + b\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0327 $eval of an array" {
  let template = @json.parse("{\"$eval\":[\"key1\",\"key2\"]}")
  let context = @json.parse("{\"key1\":1,\"key2\":2}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0328 $eval of an object" {
  let template = @json.parse("{\"$eval\":{\"k\":\"key1\"}}")
  let context = @json.parse("{\"key1\":1,\"key2\":2}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0329 $eval of null" {
  let template = @json.parse("{\"$eval\":null}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0330 $eval of a number" {
  let template = @json.parse("{\"$eval\":11}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0331 $eval of a boolean" {
  let template = @json.parse("{\"$eval\":true}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0332 min (1)" {
  let template = @json.parse("{\"$eval\":\"min(key1, key2)\"}")
  let context = @json.parse("{\"key1\":1,\"key2\":2}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0333 min (2)" {
  let template = @json.parse("{\"$eval\":\"min(1, key2)\"}")
  let context = @json.parse("{\"key1\":1,\"key2\":2}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0334 min (3)" {
  let template = @json.parse("{\"$eval\":\"min(key1, 2)\"}")
  let context = @json.parse("{\"key1\":1,\"key2\":2}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0335 min (4)" {
  let template = @json.parse("{\"$eval\":\"min(1, 2)\"}")
  let context = @json.parse("{\"key1\":1,\"key2\":2}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0336 min (5)" {
  let template = @json.parse("{\"$eval\":\"min(2, 1)\"}")
  let context = @json.parse("{\"key1\":1,\"key2\":2}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0337 min (6)" {
  let template = @json.parse("{\"$eval\":\"min(2, 1, 3, 4, 5)\"}")
  let context = @json.parse("{\"key1\":1,\"key2\":2}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0338 min - TypeError" {
  let template = @json.parse("{\"$eval\":\"min(\\\"11\\\")\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0339 min (7)" {
  let template = @json.parse("{\"$eval\":\"min()\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0340 max (1)" {
  let template = @json.parse("{\"$eval\":\"max(key1, key2)\"}")
  let context = @json.parse("{\"key1\":1,\"key2\":2}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0341 max (2)" {
  let template = @json.parse("{\"$eval\":\"max(1, key2)\"}")
  let context = @json.parse("{\"key1\":1,\"key2\":2}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0342 max (3)" {
  let template = @json.parse("{\"$eval\":\"max(key1, 2)\"}")
  let context = @json.parse("{\"key1\":1,\"key2\":2}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0343 max (4)" {
  let template = @json.parse("{\"$eval\":\"max(1, 2)\"}")
  let context = @json.parse("{\"key1\":1,\"key2\":2}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0344 max (5)" {
  let template = @json.parse("{\"$eval\":\"max(2, 1)\"}")
  let context = @json.parse("{\"key1\":1,\"key2\":2}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0345 max (6)" {
  let template = @json.parse("{\"$eval\":\"max(2, 1, 3, 4, 5)\"}")
  let context = @json.parse("{\"key1\":1,\"key2\":2}")
  let expected = @json.parse("5")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0346 max - TypeError" {
  let template = @json.parse("{\"$eval\":\"max(\\\"12\\\")\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0347 max (7)" {
  let template = @json.parse("{\"$eval\":\"max()\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0348 sqrt (1)" {
  let template = @json.parse("{\"$eval\":\"sqrt(key)\"}")
  let context = @json.parse("{\"key\":4}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0349 sqrt (2)" {
  let template = @json.parse("{\"$eval\":\"sqrt(9)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("3")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0350 sqrt - TypeError" {
  let template = @json.parse("{\"$eval\":\"sqrt(\\\"nine\\\")\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0351 ceil (1)" {
  let template = @json.parse("{\"$eval\":\"ceil(key)\"}")
  let context = @json.parse("{\"key\":1.1}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0352 ceil (2)" {
  let template = @json.parse("{\"$eval\":\"ceil(2.003)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("3")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0353 ceil (3)" {
  let template = @json.parse("{\"$eval\":\"ceil(key)\"}")
  let context = @json.parse("{\"key\":1}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0354 ceil (4)" {
  let template = @json.parse("{\"$eval\":\"ceil(key)\"}")
  let context = @json.parse("{\"key\":1.0}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0355 ceil - TypeError" {
  let template = @json.parse("{\"$eval\":\"ceil(true)\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0356 floor (1)" {
  let template = @json.parse("{\"$eval\":\"floor(key)\"}")
  let context = @json.parse("{\"key\":1.1}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0357 floor (2)" {
  let template = @json.parse("{\"$eval\":\"floor(2.003)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0358 floor (3)" {
  let template = @json.parse("{\"$eval\":\"floor(key)\"}")
  let context = @json.parse("{\"key\":1}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0359 floor (4)" {
  let template = @json.parse("{\"$eval\":\"floor(key)\"}")
  let context = @json.parse("{\"key\":1.0}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0360 floor - TypeError" {
  let template = @json.parse("{\"$eval\":\"floor(key)\"}")
  let context = @json.parse("{\"key\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0361 abs (1)" {
  let template = @json.parse("{\"$eval\":\"abs(key)\"}")
  let context = @json.parse("{\"key\":-1.1}")
  let expected = @json.parse("1.1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0362 abs (2)" {
  let template = @json.parse("{\"$eval\":\"abs(-1.1)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("1.1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0363 abs (3)" {
  let template = @json.parse("{\"$eval\":\"abs(key)\"}")
  let context = @json.parse("{\"key\":-1}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0364 abs (4)" {
  let template = @json.parse("{\"$eval\":\"abs(key)\"}")
  let context = @json.parse("{\"key\":-1.0}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0365 abs (5)" {
  let template = @json.parse("{\"$eval\":\"abs(-1)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0366 abs (6)" {
  let template = @json.parse("{\"$eval\":\"abs(-1.0)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0367 abs (7)" {
  let template = @json.parse("{\"$eval\":\"abs(key)\"}")
  let context = @json.parse("{\"key\":1.1}")
  let expected = @json.parse("1.1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0368 abs (8)" {
  let template = @json.parse("{\"$eval\":\"abs(1.1)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("1.1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0369 abs (9)" {
  let template = @json.parse("{\"$eval\":\"abs(key)\"}")
  let context = @json.parse("{\"key\":1}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0370 abs (10)" {
  let template = @json.parse("{\"$eval\":\"abs(key)\"}")
  let context = @json.parse("{\"key\":1.0}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0371 abs (11)" {
  let template = @json.parse("{\"$eval\":\"abs(1)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0372 abs (12)" {
  let template = @json.parse("{\"$eval\":\"abs(1.0)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0373 abs - TypeError" {
  let template = @json.parse("{\"$eval\":\"abs({})\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0374 lowercase (1)" {
  let template = @json.parse("{\"$eval\":\"lowercase(key)\"}")
  let context = @json.parse("{\"key\":\"HEllo\"}")
  let expected = @json.parse("\"hello\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0375 lowercase (2)" {
  let template = @json.parse("{\"$eval\":\"lowercase(\\\"HEllo\\\")\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"hello\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0376 TypeError lowercase (1)" {
  let template = @json.parse("{\"$eval\":\"lowercase(key)\"}")
  let context = @json.parse("{\"key\":{}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0377 TypeError lowercase (2)" {
  let template = @json.parse("{\"$eval\":\"lowercase({})\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0378 TypeError lowercase (3)" {
  let template = @json.parse("{\"$eval\":\"lowercase(key)\"}")
  let context = @json.parse("{\"key\":[]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0379 TypeError lowercase (4)" {
  let template = @json.parse("{\"$eval\":\"lowercase([])\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0380 TypeError lowercase (5)" {
  let template = @json.parse("{\"$eval\":\"lowercase(key)\"}")
  let context = @json.parse("{\"key\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0381 TypeError lowercase (6)" {
  let template = @json.parse("{\"$eval\":\"lowercase(1)\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0382 uppercase (1)" {
  let template = @json.parse("{\"$eval\":\"uppercase(key)\"}")
  let context = @json.parse("{\"key\":\"HEllo\"}")
  let expected = @json.parse("\"HELLO\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0383 uppercase (2)" {
  let template = @json.parse("{\"$eval\":\"uppercase(\\\"HEllo\\\")\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"HELLO\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0384 TypeError uppercase (1)" {
  let template = @json.parse("{\"$eval\":\"uppercase(key)\"}")
  let context = @json.parse("{\"key\":{}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0385 TypeError uppercase (2)" {
  let template = @json.parse("{\"$eval\":\"uppercase({})\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0386 TypeError uppercase (3)" {
  let template = @json.parse("{\"$eval\":\"uppercase(key)\"}")
  let context = @json.parse("{\"key\":[]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0387 TypeError uppercase (4)" {
  let template = @json.parse("{\"$eval\":\"uppercase([])\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0388 TypeError uppercase (5)" {
  let template = @json.parse("{\"$eval\":\"uppercase(key)\"}")
  let context = @json.parse("{\"key\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0389 TypeError uppercase (6)" {
  let template = @json.parse("{\"$eval\":\"uppercase(1)\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0390 len (1)" {
  let template = @json.parse("{\"$eval\":\"len(key)\"}")
  let context = @json.parse("{\"key\":[1,2,3]}")
  let expected = @json.parse("3")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0391 len (2)" {
  let template = @json.parse("{\"$eval\":\"len([1, 2, 3])\"}")
  let context = @json.parse("{\"key\":[1,2,3]}")
  let expected = @json.parse("3")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0392 len (3)" {
  let template = @json.parse("{\"$eval\":\"len(key)\"}")
  let context = @json.parse("{\"key\":\"abc\"}")
  let expected = @json.parse("3")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0393 len of grinning face unicode character" {
  let template = @json.parse("{\"$eval\":\"len(key)\"}")
  let context = @json.parse("{\"key\":\"\\ud83d\\ude01\"}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0394 len (4)" {
  let template = @json.parse("{\"$eval\":\"len(\\\"abc\\\")\"}")
  let context = @json.parse("{\"key\":[1,2,3]}")
  let expected = @json.parse("3")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0395 TypeError len (1)" {
  let template = @json.parse("{\"$eval\":\"len(key)\"}")
  let context = @json.parse("{\"key\":{}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0396 TypeError len (2)" {
  let template = @json.parse("{\"$eval\":\"len({})\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0397 TypeError len (3)" {
  let template = @json.parse("{\"$eval\":\"len(key)\"}")
  let context = @json.parse("{\"key\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0398 TypeError len (4)" {
  let template = @json.parse("{\"$eval\":\"len(1)\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0399 str of num via context" {
  let template = @json.parse("{\"$eval\":\"str(key)\"}")
  let context = @json.parse("{\"key\":1}")
  let expected = @json.parse("\"1\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0400 str of num" {
  let template = @json.parse("{\"$eval\":\"str(1)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"1\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0401 str of string via context" {
  let template = @json.parse("{\"$eval\":\"str(key)\"}")
  let context = @json.parse("{\"key\":\"hello\"}")
  let expected = @json.parse("\"hello\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0402 str of string" {
  let template = @json.parse("{\"$eval\":\"str(\\\"hello\\\")\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"hello\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0403 str of bool via context" {
  let template = @json.parse("{\"$eval\":\"str(key)\"}")
  let context = @json.parse("{\"key\":true}")
  let expected = @json.parse("\"true\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0404 str of true" {
  let template = @json.parse("{\"$eval\":\"str(true)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"true\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0405 str (key) with null" {
  let template = @json.parse("{\"$eval\":\"str(x)\"}")
  let context = @json.parse("{\"x\":null}")
  let expected = @json.parse("\"null\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0406 str of bool via context" {
  let template = @json.parse("{\"$eval\":\"str(key)\"}")
  let context = @json.parse("{\"key\":false}")
  let expected = @json.parse("\"false\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0407 str of false" {
  let template = @json.parse("{\"$eval\":\"str(false)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"false\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0408 str of floating-point 4.25" {
  let template = @json.parse("{\"$eval\":\"str(val)\"}")
  let context = @json.parse("{\"val\":4.25}")
  let expected = @json.parse("\"4.25\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0409 str of floating-point 4.2" {
  let template = @json.parse("{\"$eval\":\"str(val)\"}")
  let context = @json.parse("{\"val\":4.2}")
  let expected = @json.parse("\"4.2\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0410 str of unicode" {
  let template = @json.parse("{\"$eval\":\"str(val)\"}")
  let context = @json.parse("{\"val\":\"let's make a \\u2603\"}")
  let expected = @json.parse("\"let's make a \\u2603\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0411 str of empty object" {
  let template = @json.parse("{\"$eval\":\"str({})\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0412 str of object" {
  let template = @json.parse("{\"$eval\":\"str({a:10})\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0413 str of array" {
  let template = @json.parse("{\"$eval\":\"str([1, 2, 3])\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0414 str(key) with array" {
  let template = @json.parse("{\"$eval\":\"str(key)\"}")
  let context = @json.parse("{\"key\":[1,2,3]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0415 number" {
  let template = @json.parse("{\"foo\":{\"$eval\":\"number(round)\"}}")
  let context = @json.parse("{\"round\":\"3\"}")
  let expected = @json.parse("{\"foo\":3}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0416 number (with point)" {
  let template = @json.parse("{\"foo\":{\"$eval\":\"number(round)\"}}")
  let context = @json.parse("{\"round\":\"3.5\"}")
  let expected = @json.parse("{\"foo\":3.5}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0417 negative number" {
  let template = @json.parse("{\"foo\":{\"$eval\":\"number(round)\"}}")
  let context = @json.parse("{\"round\":\"-14\"}")
  let expected = @json.parse("{\"foo\":-14}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0418 negative number (with point)" {
  let template = @json.parse("{\"foo\":{\"$eval\":\"number(round)\"}}")
  let context = @json.parse("{\"round\":\"-14.15\"}")
  let expected = @json.parse("{\"foo\":-14.15}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0419 number zero" {
  let template = @json.parse("{\"foo\":{\"$eval\":\"number(round)\"}}")
  let context = @json.parse("{\"round\":\"0\"}")
  let expected = @json.parse("{\"foo\":0}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0420 giving a number to number fails" {
  let template = @json.parse("{\"foo\":{\"$eval\":\"number(round)\"}}")
  let context = @json.parse("{\"round\":0}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0421 giving a bool to number fails" {
  let template = @json.parse("{\"foo\":{\"$eval\":\"number(round)\"}}")
  let context = @json.parse("{\"round\":false}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0422 giving null to number fails" {
  let template = @json.parse("{\"foo\":{\"$eval\":\"number(round)\"}}")
  let context = @json.parse("{\"round\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0423 giving an array to number fails" {
  let template = @json.parse("{\"foo\":{\"$eval\":\"number(round)\"}}")
  let context = @json.parse("{\"round\":[1]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0424 giving an object to number fails" {
  let template = @json.parse("{\"foo\":{\"$eval\":\"number(round)\"}}")
  let context = @json.parse("{\"round\":{\"one\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0425 strip space" {
  let template = @json.parse("{\"$eval\":\"strip('  abc   ')\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"abc\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0426 strip mixed whitspace" {
  let template = @json.parse(
    "{\"$eval\":\"strip(' \\f\\n\\r\\t\\u000babc \\f\\n\\r\\t\\u000b')\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("\"abc\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0427 rstrip space" {
  let template = @json.parse("{\"$eval\":\"rstrip('  abc   ')\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"  abc\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0428 rstrip mixed whitspace" {
  let template = @json.parse(
    "{\"$eval\":\"rstrip(' \\f\\n\\r\\t\\u000babc \\f\\n\\r\\t\\u000b')\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("\" \\f\\n\\r\\t\\u000babc\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0429 lstrip space" {
  let template = @json.parse("{\"$eval\":\"lstrip('  abc   ')\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"abc   \"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0430 lstrip mixed whitspace" {
  let template = @json.parse(
    "{\"$eval\":\"lstrip(' \\f\\n\\r\\t\\u000babc \\f\\n\\r\\t\\u000b')\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("\"abc \\f\\n\\r\\t\\u000b\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0431 split string with delimiter" {
  let template = @json.parse("{\"$eval\":\"split('left:right', ':')\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("[\"left\",\"right\"]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0432 split string without delimiter" {
  let template = @json.parse("{\"$eval\":\"split('spellme', '')\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("[\"s\",\"p\",\"e\",\"l\",\"l\",\"m\",\"e\"]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0433 split with empty string" {
  let template = @json.parse("{\"$eval\":\"split('', ':')\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("[\"\"]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0434 split string with no match" {
  let template = @json.parse("{\"$eval\":\"split('no semicolon', ':')\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("[\"no semicolon\"]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0435 split with number delimiter" {
  let template = @json.parse("{\"$eval\":\"split('left1right', 1)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("[\"left\",\"right\"]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0436 split error with object" {
  let template = @json.parse("{\"$eval\":\"split({})\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0437 split error with array" {
  let template = @json.parse("{\"$eval\":\"split([])\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0438 split with only one argument" {
  let template = @json.parse("{\"$eval\":\"split('abc')\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0439 join with string separator" {
  let template = @json.parse("{\"$eval\":\"join(['join', 'me'], ' ')\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"join me\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0440 join with same" {
  let template = @json.parse("{\"$eval\":\"join([',', ','], ',')\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\",,,\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0441 join with number separator" {
  let template = @json.parse("{\"$eval\":\"join([1, 3], 2)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"123\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0442 join with strings separated with number" {
  let template = @json.parse("{\"$eval\":\"join(['one', 'three'], 2)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"one2three\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0443 join with numbers separated with string" {
  let template = @json.parse("{\"$eval\":\"join([1, 3], 'two')\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"1two3\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0444 join with string" {
  let template = @json.parse("{\"$eval\":\"join('cannot join string')\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0445 join with object" {
  let template = @json.parse("{\"$eval\":\"join({})\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0446 join with boolean" {
  let template = @json.parse("{\"$eval\":\"join(false)\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0447 fromNow" {
  let template = @json.parse("{\"$eval\":\"fromNow(\\\"\\\")\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-19T16:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0448 fromNow - 2 days 3 hours" {
  let template = @json.parse("{\"$eval\":\"fromNow(\\\"2 days 3 hours\\\")\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-21T19:27:20.974Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0449 fromNow with reference" {
  let template = @json.parse(
    "{\"$eval\":\"fromNow('1 day', '2017-01-01T01:00:00.123Z')\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("\"2017-01-02T01:00:00.123Z\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0450 fromNow - TypeError" {
  let template = @json.parse("{\"$eval\":\"fromNow(13)\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0451 typeof str" {
  let template = @json.parse("{\"$eval\":\"typeof('abc')\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"string\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0452 typeof number (int)" {
  let template = @json.parse("{\"$eval\":\"typeof(4)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"number\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0453 typeof number (float)" {
  let template = @json.parse("{\"$eval\":\"typeof(4.0)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"number\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0454 typeof boolean (true)" {
  let template = @json.parse("{\"$eval\":\"typeof(true)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"boolean\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0455 typeof boolean (false)" {
  let template = @json.parse("{\"$eval\":\"typeof(false)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"boolean\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0456 typeof array (empty)" {
  let template = @json.parse("{\"$eval\":\"typeof([])\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"array\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0457 typeof array" {
  let template = @json.parse("{\"$eval\":\"typeof([1, 2, 3])\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"array\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0458 typeof object" {
  let template = @json.parse("{\"$eval\":\"typeof({})\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"object\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0459 typeof null" {
  let template = @json.parse("{\"$eval\":\"typeof(x)\"}")
  let context = @json.parse("{\"x\":null}")
  let expected = @json.parse("\"null\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0460 typeof null, interpolated" {
  let template = @json.parse("\"${typeof(x)}\"")
  let context = @json.parse("{\"x\":null}")
  let expected = @json.parse("\"null\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0461 typeof null in if" {
  let template = @json.parse(
    "{\"$if\":\"typeof(null) == \\\"null\\\"\",\"then\":\"foo\",\"else\":\"bar\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("\"foo\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0462 typeof function" {
  let template = @json.parse("{\"$eval\":\"typeof(typeof)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"function\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0463 override builtin (1), uppercase" {
  let template = @json.parse("{\"$eval\":\"uppercase + 1\"}")
  let context = @json.parse("{\"uppercase\":1}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0464 override builtin (2), min" {
  let template = @json.parse("{\"$eval\":\"min\"}")
  let context = @json.parse("{\"min\":\"hello world!\"}")
  let expected = @json.parse("\"hello world!\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0465 defined without context variable" {
  let template = @json.parse(
    "{\"$if\":\"defined('var')\",\"then\":\"t\",\"else\":\"f\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("\"f\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0466 defined with empty string as context variable" {
  let template = @json.parse(
    "{\"$if\":\"defined('var')\",\"then\":\"t\",\"else\":\"f\"}",
  )
  let context = @json.parse("{\"var\":\"\"}")
  let expected = @json.parse("\"t\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0467 missing right square bracket" {
  let template = @json.parse("{\"foo\":\"${bar[2:}\"}")
  let context = @json.parse("{\"bar\":\"mystring\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0468 decimal literal" {
  let template = @json.parse("{\"$eval\":\"10.5\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("10.5")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0469 hex literal" {
  let template = @json.parse("{\"$eval\":\"0xff\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0470 string literal with single quote" {
  let template = @json.parse("{\"$eval\":\"'three!'\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"three!\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0471 string literal with double quote" {
  let template = @json.parse("{\"$eval\":\"\\\"three!\\\"\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"three!\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0472 string literal escape with backslash (not supported)" {
  let template = @json.parse(
    "{\"$eval\":\"\\\"backslash\\\\\\\\\\\"maybe\\\"\"}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0473 string literal escape with doubling (not supported)" {
  let template = @json.parse("{\"$eval\":\"\\\"doubled\\\"\\\"maybe\\\"\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0474 boolean literals" {
  let template = @json.parse("{\"$eval\":\"[true, false]\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("[true,false]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0475 null literal" {
  let template = @json.parse("{\"$eval\":\"[null, null]\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("[null,null]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0476 leading zeroes (not octal)" {
  let template = @json.parse("{\"$eval\":\"0777\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("777")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0477 addition" {
  let template = @json.parse("{\"$eval\":\"a + b + 7\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("10")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0478 multiplication" {
  let template = @json.parse("{\"$eval\":\"a * b * 3\"}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let expected = @json.parse("18")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0479 string concatenation" {
  let template = @json.parse("{\"$eval\":\"\\\"a\\\" + \\\"b\\\"\"}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let expected = @json.parse("\"ab\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0480 $eval must take string" {
  let template = @json.parse("{\"$eval\":[\"a\",\"b\"]}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0481 array access [index]" {
  let template = @json.parse("{\"$eval\":\"a[0]\"}")
  let context = @json.parse("{\"a\":[1,2,3,4]}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0482 array access [index]" {
  let template = @json.parse("{\"$eval\":\"a[2]\"}")
  let context = @json.parse("{\"a\":[1,2,3,4]}")
  let expected = @json.parse("3")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0483 array access [-index]" {
  let template = @json.parse("{\"$eval\":\"a[-1]\"}")
  let context = @json.parse("{\"a\":[1,2,3,4]}")
  let expected = @json.parse("4")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0484 array access [-index]" {
  let template = @json.parse("{\"$eval\":\"a[-2]\"}")
  let context = @json.parse("{\"a\":[1,2,3,4]}")
  let expected = @json.parse("3")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0485 array access at negative length" {
  let template = @json.parse("{\"$eval\":\"a[-5]\"}")
  let context = @json.parse("{\"a\":[1,2,3,4,5]}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0486 array access at negative length (single item)" {
  let template = @json.parse("{\"$eval\":\"a[-1]\"}")
  let context = @json.parse("{\"a\":[1]}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0487 array access [index expression]" {
  let template = @json.parse("{\"$eval\":\"a[b]\"}")
  let context = @json.parse("{\"a\":[10,11,12],\"b\":1}")
  let expected = @json.parse("11")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0488 array access [index expression with +]" {
  let template = @json.parse("{\"$eval\":\"a[b+1]\"}")
  let context = @json.parse("{\"a\":[10,11,12],\"b\":1}")
  let expected = @json.parse("12")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0489 array slicing [begin:end], [begin, end)" {
  let template = @json.parse("{\"$eval\":\"a[0:2]\"}")
  let context = @json.parse("{\"a\":[1,2,3,4]}")
  let expected = @json.parse("[1,2]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0490 array slicing [begin:], [begin, end)" {
  let template = @json.parse("{\"$eval\":\"a[0:]\"}")
  let context = @json.parse("{\"a\":[1,2,3,4]}")
  let expected = @json.parse("[1,2,3,4]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0491 array slicing [begin:], [begin, end)" {
  let template = @json.parse("{\"$eval\":\"a[1:]\"}")
  let context = @json.parse("{\"a\":[1,2,3,4]}")
  let expected = @json.parse("[2,3,4]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0492 array slicing [-begin:], [begin, end)" {
  let template = @json.parse("{\"$eval\":\"a[-3:]\"}")
  let context = @json.parse("{\"a\":[1,2,3,4]}")
  let expected = @json.parse("[2,3,4]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0493 array slicing [-begin:-end], [begin, end)" {
  let template = @json.parse("{\"$eval\":\"a[-3:-1]\"}")
  let context = @json.parse("{\"a\":[1,2,3,4]}")
  let expected = @json.parse("[2,3]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0494 array slicing [:end], [begin, end)" {
  let template = @json.parse("{\"$eval\":\"a[:3]\"}")
  let context = @json.parse("{\"a\":[1,2,3,4]}")
  let expected = @json.parse("[1,2,3]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0495 array slicing [:-end], [begin, end)" {
  let template = @json.parse("{\"$eval\":\"a[:-2]\"}")
  let context = @json.parse("{\"a\":[1,2,3,4]}")
  let expected = @json.parse("[1,2]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0496 array slice partially out of range" {
  let template = @json.parse("{\"$eval\":\"a[2:10]\"}")
  let context = @json.parse("{\"a\":[1,2,3,4]}")
  let expected = @json.parse("[3,4]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0497 array slice completely out of range" {
  let template = @json.parse("{\"$eval\":\"a[8:10]\"}")
  let context = @json.parse("{\"a\":[1,2,3,4]}")
  let expected = @json.parse("[]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0498 array slice negative out of range" {
  let template = @json.parse("{\"$eval\":\"a[2:-10]\"}")
  let context = @json.parse("{\"a\":[1,2,3,4]}")
  let expected = @json.parse("[]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0499 array slice negative range" {
  let template = @json.parse("{\"$eval\":\"a[2:-3]\"}")
  let context = @json.parse("{\"a\":[1,2,3,4]}")
  let expected = @json.parse("[]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0500 array slice reverse range" {
  let template = @json.parse("{\"$eval\":\"a[3:2]\"}")
  let context = @json.parse("{\"a\":[1,2,3,4]}")
  let expected = @json.parse("[]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0501 function min(contextValue, contextValue)" {
  let template = @json.parse("{\"$eval\":\"min(a, b)\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0502 function max(contextValue, contextValue)" {
  let template = @json.parse("{\"$eval\":\"max(a, b)\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0503 function min(contextValue, value)" {
  let template = @json.parse("{\"$eval\":\"min(a, -1)\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("-1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0504 function max(contextValue, value)" {
  let template = @json.parse("{\"$eval\":\"max(a, 3)\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("3")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0505 identifier beginning with in" {
  let template = @json.parse("{\"$eval\":\"input + 1\"}")
  let context = @json.parse("{\"input\":6}")
  let expected = @json.parse("7")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0506 identifier beginning with true / false" {
  let template = @json.parse("{\"$eval\":\"true_facts || false_lies\"}")
  let context = @json.parse("{\"true_facts\":true,\"false_lies\":false}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0507 identifier beginning with null" {
  let template = @json.parse("{\"$eval\":\"null_hypothesis\"}")
  let context = @json.parse("{\"null_hypothesis\":\"no difference\"}")
  let expected = @json.parse("\"no difference\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0508 addition" {
  let template = @json.parse("{\"$eval\":\"a + b + 7\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("10")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0509 multiplication" {
  let template = @json.parse("{\"$eval\":\"a * b * 3\"}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let expected = @json.parse("18")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0510 multiplication (2)" {
  let template = @json.parse("{\"$eval\":\"(a * -1000)\"}")
  let context = @json.parse("{\"a\":180000000000.0}")
  let expected = @json.parse("-180000000000000.0")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0511 multiplication with addition" {
  let template = @json.parse("{\"$eval\":\"a * 3 + 4\"}")
  let context = @json.parse("{\"a\":2}")
  let expected = @json.parse("10")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0512 multiplication with subtraction" {
  let template = @json.parse("{\"$eval\":\"a * 3 - 4\"}")
  let context = @json.parse("{\"a\":2}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0513 multiplication with division" {
  let template = @json.parse("{\"$eval\":\"a * 3 / 2\"}")
  let context = @json.parse("{\"a\":4}")
  let expected = @json.parse("6")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0514 multiplication with exponentiation" {
  let template = @json.parse("{\"$eval\":\"a * 3 ** 4\"}")
  let context = @json.parse("{\"a\":2}")
  let expected = @json.parse("162")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0515 multiplication with grouped addition" {
  let template = @json.parse("{\"$eval\":\"a * (3 + 4)\"}")
  let context = @json.parse("{\"a\":2}")
  let expected = @json.parse("14")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0516 multiplication with grouped subtraction" {
  let template = @json.parse("{\"$eval\":\"a * (3 - 4)\"}")
  let context = @json.parse("{\"a\":2}")
  let expected = @json.parse("-2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0517 multiplication with grouped division" {
  let template = @json.parse("{\"$eval\":\"a * (4 / 2)\"}")
  let context = @json.parse("{\"a\":4}")
  let expected = @json.parse("8")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0518 grouped multiplication with exponentiation" {
  let template = @json.parse("{\"$eval\":\"(a * 3) ** 2\"}")
  let context = @json.parse("{\"a\":4}")
  let expected = @json.parse("144")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0519 division (1)" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let expected = @json.parse("1.5")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0520 division (2)" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":3.0,\"b\":2.0}")
  let expected = @json.parse("1.5")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0521 division (3)" {
  let template = @json.parse("{\"$eval\":\"b / a\"}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let expected = @json.parse("0.6666666666666666")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0522 division (4)" {
  let template = @json.parse("{\"$eval\":\"b / a\"}")
  let context = @json.parse("{\"a\":3.0,\"b\":2.0}")
  let expected = @json.parse("0.6666666666666666")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0523 division by zero" {
  let template = @json.parse("{\"$eval\":\"1 / 0\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0524 division with addition" {
  let template = @json.parse("{\"$eval\":\"a / 3 + 4\"}")
  let context = @json.parse("{\"a\":12}")
  let expected = @json.parse("8")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0525 division with subtraction" {
  let template = @json.parse("{\"$eval\":\"a / 3 - 4\"}")
  let context = @json.parse("{\"a\":6}")
  let expected = @json.parse("-2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0526 division with division" {
  let template = @json.parse("{\"$eval\":\"a / 3 / 2\"}")
  let context = @json.parse("{\"a\":12}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0527 division with exponentiation" {
  let template = @json.parse("{\"$eval\":\"a / 3 ** 4\"}")
  let context = @json.parse("{\"a\":162}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0528 division with grouped addition" {
  let template = @json.parse("{\"$eval\":\"a / (3 + 4)\"}")
  let context = @json.parse("{\"a\":14}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0529 division with grouped subtraction" {
  let template = @json.parse("{\"$eval\":\"a / (3 - 4)\"}")
  let context = @json.parse("{\"a\":6}")
  let expected = @json.parse("-6")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0530 division with grouped division" {
  let template = @json.parse("{\"$eval\":\"a / (6 / 2)\"}")
  let context = @json.parse("{\"a\":12}")
  let expected = @json.parse("4")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0531 grouped division with exponentiation" {
  let template = @json.parse("{\"$eval\":\"(a / 3) ** 4\"}")
  let context = @json.parse("{\"a\":12}")
  let expected = @json.parse("256")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0532 exponentiation (1)" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":2,\"b\":3}")
  let expected = @json.parse("8")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0533 exponentiation (2)" {
  let template = @json.parse("{\"$eval\":\"a ** b + 2\"}")
  let context = @json.parse("{\"a\":2,\"b\":3}")
  let expected = @json.parse("10")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0534 exponentiation (3)" {
  let template = @json.parse("{\"$eval\":\"a ** b * 2\"}")
  let context = @json.parse("{\"a\":2,\"b\":3}")
  let expected = @json.parse("16")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0535 exponentiation (4)" {
  let template = @json.parse("{\"$eval\":\"a * a ** b\"}")
  let context = @json.parse("{\"a\":2,\"b\":3}")
  let expected = @json.parse("16")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0536 exponentiation, right associativity (1)" {
  let template = @json.parse("{\"$eval\":\"a ** a ** b == a ** (a ** b)\"}")
  let context = @json.parse("{\"a\":2,\"b\":3}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0537 exponentiation, right associativity (2)" {
  let template = @json.parse("{\"$eval\":\"a ** a ** b\"}")
  let context = @json.parse("{\"a\":2,\"b\":3}")
  let expected = @json.parse("256")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0538 exponentiation, right associativity (3)" {
  let template = @json.parse("{\"$eval\":\"2 ** 2 ** 3 == 2 ** (2 ** 3)\"}")
  let context = @json.parse("{\"a\":2,\"b\":3}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0539 exponentiation, right associativity (4)" {
  let template = @json.parse("{\"$eval\":\"2 ** 2 ** 3\"}")
  let context = @json.parse("{\"a\":2,\"b\":3}")
  let expected = @json.parse("256")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0540 unary negation" {
  let template = @json.parse("{\"$eval\":\"-a\"}")
  let context = @json.parse("{\"a\":2}")
  let expected = @json.parse("-2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0541 unary plus" {
  let template = @json.parse("{\"$eval\":\"+a\"}")
  let context = @json.parse("{\"a\":2}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0542 addition of strings to numbers" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0543 addition of strings to null" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0544 addition of strings to booleans" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0545 addition of strings to objects" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0546 addition of strings to arrays" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0547 subtraction of strings from strings" {
  let template = @json.parse("{\"$eval\":\"a-b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0548 subtraction of strings from numbers" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0549 subtraction of strings from null" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0550 subtraction of strings from booleans" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0551 subtraction of strings from objects" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0552 subtraction of strings from arrays" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0553 multiplication of strings to strings" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0554 multiplication of strings to numbers" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0555 multiplication of strings to null" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0556 multiplication of strings to booleans" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0557 multiplication of strings to objects" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0558 multiplication of strings to arrays" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0559 division of strings by strings" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0560 division of strings by numbers" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0561 division of strings by null" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0562 division of strings by booleans" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0563 division of strings by objects" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0564 division of strings by arrays" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0565 exponentiation of strings by strings" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0566 exponentiation of strings by numbers" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0567 exponentiation of strings by null" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0568 exponentiation of strings by booleans" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0569 exponentiation of strings by objects" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0570 exponentiation of strings by arrays" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0571 unary negation of string" {
  let template = @json.parse("{\"$eval\":\"-a\"}")
  let context = @json.parse("{\"a\":\"a\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0572 unary plus of string" {
  let template = @json.parse("{\"$eval\":\"+a\"}")
  let context = @json.parse("{\"a\":\"a\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0573 unary negation of true" {
  let template = @json.parse("{\"$eval\":\"-true\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0574 unary plus of true" {
  let template = @json.parse("{\"$eval\":\"+true\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0575 unary negation of false" {
  let template = @json.parse("{\"$eval\":\"-false\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0576 unary plus of false" {
  let template = @json.parse("{\"$eval\":\"+false\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0577 unary negation of null" {
  let template = @json.parse("{\"$eval\":\"-null\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0578 unary plus of null" {
  let template = @json.parse("{\"$eval\":\"+null\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0579 addition of numbers to strings" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":13,\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0580 addition of numbers to null" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":13,\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0581 addition of numbers to booleans" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":13,\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0582 addition of numbers to objects" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":13,\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0583 addition of numbers to arrays" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":13,\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0584 subtraction of numbers from strings" {
  let template = @json.parse("{\"$eval\":\"a-b\"}")
  let context = @json.parse("{\"a\":13,\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0585 subtraction of numbers from null" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":13,\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0586 subtraction of numbers from booleans" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":13,\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0587 subtraction of numbers from objects" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":13,\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0588 subtraction of numbers from arrays" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":13,\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0589 multiplication of numbers to strings" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":13,\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0590 multiplication of numbers to null" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":13,\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0591 multiplication of numbers to booleans" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":13,\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0592 multiplication of numbers to objects" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":13,\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0593 multiplication of numbers to arrays" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":13,\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0594 division of numbers by strings" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":13,\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0595 division of numbers by null" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":13,\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0596 division of numbers by booleans" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":13,\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0597 division of numbers by objects" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":13,\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0598 division of numbers by arrays" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":13,\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0599 exponentiation of numbers by strings" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":13,\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0600 exponentiation of numbers by null" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":13,\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0601 exponentiation of numbers by booleans" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":13,\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0602 exponentiation of numbers by objects" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":13,\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0603 exponentiation of numbers by arrays" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":13,\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0604 addition of null to strings" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":null,\"b\":\"a\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0605 addition of null to numbers" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":null,\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0606 addition of null to null" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":null,\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0607 addition of null to booleans" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":null,\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0608 addition of null to objects" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":null,\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0609 addition of null to arrays" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":null,\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0610 subtraction of null from strings" {
  let template = @json.parse("{\"$eval\":\"a-b\"}")
  let context = @json.parse("{\"a\":null,\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0611 subtraction of null from numbers" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":null,\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0612 subtraction of null from null" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":null,\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0613 subtraction of null from booleans" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":null,\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0614 subtraction of null from objects" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":null,\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0615 subtraction of null from arrays" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":null,\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0616 multiplication of null to strings" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":null,\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0617 multiplication of null to numbers" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":null,\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0618 multiplication of null to null" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":null,\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0619 multiplication of null to booleans" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":null,\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0620 multiplication of null to objects" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":null,\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0621 multiplication of null to arrays" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":null,\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0622 division of null by strings" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":null,\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0623 division of null by numbers" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":null,\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0624 division of null by null" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":null,\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0625 division of null by booleans" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":null,\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0626 division of null by objects" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":null,\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0627 division of null by arrays" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":null,\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0628 exponentiation of null by strings" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":null,\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0629 exponentiation of null by numbers" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":null,\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0630 exponentiation of null by null" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":null,\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0631 exponentiation of null by booleans" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":null,\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0632 exponentiation of null by objects" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":null,\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0633 exponentiation of null by arrays" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":null,\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0634 unary negation of null" {
  let template = @json.parse("{\"$eval\":\"-a\"}")
  let context = @json.parse("{\"a\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0635 unary plus of null" {
  let template = @json.parse("{\"$eval\":\"+a\"}")
  let context = @json.parse("{\"a\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0636 addition of boolean to strings" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":true,\"b\":\"a\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0637 addition of boolean to numbers" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":true,\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0638 addition of boolean to null" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":true,\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0639 addition of boolean to booleans" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":true,\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0640 addition of boolean to objects" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":true,\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0641 addition of boolean to arrays" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":true,\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0642 subtraction of boolean from strings" {
  let template = @json.parse("{\"$eval\":\"a-b\"}")
  let context = @json.parse("{\"a\":true,\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0643 subtraction of boolean from numbers" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":true,\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0644 subtraction of boolean from null" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":true,\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0645 subtraction of boolean from booleans" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":true,\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0646 subtraction of boolean from objects" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":true,\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0647 subtraction of boolean from arrays" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":true,\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0648 multiplication of boolean to strings" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":true,\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0649 multiplication of boolean to numbers" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":true,\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0650 multiplication of boolean to null" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":true,\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0651 multiplication of boolean to booleans" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":true,\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0652 multiplication of boolean to objects" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":true,\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0653 multiplication of boolean to arrays" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":true,\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0654 division of boolean by strings" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":true,\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0655 division of boolean by numbers" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":true,\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0656 division of boolean by null" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":true,\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0657 division of boolean by booleans" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":true,\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0658 division of boolean by objects" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":true,\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0659 division of boolean by arrays" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":true,\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0660 exponentiation of boolean by strings" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":true,\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0661 exponentiation of boolean by numbers" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":true,\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0662 exponentiation of boolean by null" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":true,\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0663 exponentiation of boolean by booleans" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":true,\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0664 exponentiation of boolean by objects" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":true,\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0665 exponentiation of boolean by arrays" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":true,\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0666 unary negation of boolean" {
  let template = @json.parse("{\"$eval\":\"-a\"}")
  let context = @json.parse("{\"a\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0667 unary plus of boolean" {
  let template = @json.parse("{\"$eval\":\"+a\"}")
  let context = @json.parse("{\"a\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0668 addition of object to strings" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":\"a\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0669 addition of object to numbers" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0670 addition of object to null" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0671 addition of object to booleans" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0672 addition of object to objects" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0673 addition of object to arrays" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0674 subtraction of object from strings" {
  let template = @json.parse("{\"$eval\":\"a-b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0675 subtraction of object from numbers" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0676 subtraction of object from null" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0677 subtraction of object from booleans" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0678 subtraction of object from objects" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0679 subtraction of object from arrays" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0680 multiplication of object to strings" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0681 multiplication of object to numbers" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0682 multiplication of object to null" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0683 multiplication of object to booleans" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0684 multiplication of object to objects" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0685 multiplication of object to arrays" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0686 division of object by strings" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0687 division of object by numbers" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0688 division of object by null" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0689 division of object by booleans" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0690 division of object by objects" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0691 division of object by arrays" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0692 exponentiation of object by strings" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0693 exponentiation of object by numbers" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0694 exponentiation of object by null" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0695 exponentiation of object by booleans" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0696 exponentiation of object by objects" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0697 exponentiation of object by arrays" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":{\"x\":10},\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0698 unary negation of object" {
  let template = @json.parse("{\"$eval\":\"-a\"}")
  let context = @json.parse("{\"a\":{\"x\":10}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0699 unary plus of object" {
  let template = @json.parse("{\"$eval\":\"+a\"}")
  let context = @json.parse("{\"a\":{\"x\":10}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0700 addition of array to strings" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":\"a\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0701 addition of array to numbers" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0702 addition of array to null" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0703 addition of array to booleans" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0704 addition of array to objects" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0705 addition of array to arrays" {
  let template = @json.parse("{\"$eval\":\"a + b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0706 subtraction of array from strings" {
  let template = @json.parse("{\"$eval\":\"a-b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0707 subtraction of array from numbers" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0708 subtraction of array from null" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0709 subtraction of array from booleans" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0710 subtraction of array from objects" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0711 subtraction of array from arrays" {
  let template = @json.parse("{\"$eval\":\"a - b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0712 multiplication of array to strings" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0713 multiplication of array to numbers" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0714 multiplication of array to null" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0715 multiplication of array to booleans" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0716 multiplication of array to objects" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0717 multiplication of array to arrays" {
  let template = @json.parse("{\"$eval\":\"a * b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0718 division of array by strings" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0719 division of array by numbers" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0720 division of array by null" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0721 division of array by booleans" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0722 division of array by objects" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0723 division of array by arrays" {
  let template = @json.parse("{\"$eval\":\"a / b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0724 exponentiation of array by strings" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":\"b\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0725 exponentiation of array by numbers" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0726 exponentiation of array by null" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0727 exponentiation of array by booleans" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0728 exponentiation of array by objects" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":{\"x\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0729 exponentiation of array by arrays" {
  let template = @json.parse("{\"$eval\":\"a ** b\"}")
  let context = @json.parse("{\"a\":[1,2],\"b\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0730 unary negation of array" {
  let template = @json.parse("{\"$eval\":\"-a\"}")
  let context = @json.parse("{\"a\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0731 unary plus of array" {
  let template = @json.parse("{\"$eval\":\"+a\"}")
  let context = @json.parse("{\"a\":[1,2]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0732 logical not (1)" {
  let template = @json.parse("{\"$eval\":\"!tt\"}")
  let context = @json.parse("{\"tt\":true,\"ff\":false}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0733 logical not (2)" {
  let template = @json.parse("{\"$eval\":\"!ff\"}")
  let context = @json.parse("{\"tt\":true,\"ff\":false}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0734 or operator (1)" {
  let template = @json.parse("{\"$eval\":\"tt || tt\"}")
  let context = @json.parse("{\"tt\":true,\"ff\":false}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0735 or operator (2)" {
  let template = @json.parse("{\"$eval\":\"tt || ff\"}")
  let context = @json.parse("{\"tt\":true,\"ff\":false}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0736 or operator (3)" {
  let template = @json.parse("{\"$eval\":\"ff || tt\"}")
  let context = @json.parse("{\"tt\":true,\"ff\":false}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0737 or operator (4)" {
  let template = @json.parse("{\"$eval\":\"ff || ff\"}")
  let context = @json.parse("{\"tt\":true,\"ff\":false}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0738 and operator (1)" {
  let template = @json.parse("{\"$eval\":\"tt && tt\"}")
  let context = @json.parse("{\"tt\":true,\"ff\":false}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0739 and operator (2)" {
  let template = @json.parse("{\"$eval\":\"tt && ff\"}")
  let context = @json.parse("{\"tt\":true,\"ff\":false}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0740 and operator (3)" {
  let template = @json.parse("{\"$eval\":\"ff && tt\"}")
  let context = @json.parse("{\"tt\":true,\"ff\":false}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0741 and operator (4)" {
  let template = @json.parse("{\"$eval\":\"ff && ff\"}")
  let context = @json.parse("{\"tt\":true,\"ff\":false}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0742 and operator with not operator" {
  let template = @json.parse("{\"$eval\":\"tt && !ff\"}")
  let context = @json.parse("{\"tt\":true,\"ff\":false}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0743 or operator with not operator" {
  let template = @json.parse("{\"$eval\":\"ff || !ff\"}")
  let context = @json.parse("{\"tt\":true,\"ff\":false}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0744 complex logical operation (1)" {
  let template = @json.parse("{\"$eval\":\"4 < 6 && 2 == 1 + 1\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0745 complex logical operation (2)" {
  let template = @json.parse("{\"$eval\":\"!(4 < 6) && 2 == 1 + 1\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0746 complex logical operation (3)" {
  let template = @json.parse("{\"$eval\":\"2 == 1 + 1 && 4 < 6\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0747 complex logical operation (4)" {
  let template = @json.parse("{\"$eval\":\"4 >= 6 || 2 == 1 + 1\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0748 string not" {
  let template = @json.parse("{\"$eval\":\"!a\"}")
  let context = @json.parse("{\"a\":\"abc\"}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0749 empty string not" {
  let template = @json.parse("{\"$eval\":\"!a\"}")
  let context = @json.parse("{\"a\":\"\"}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0750 number not" {
  let template = @json.parse("{\"$eval\":\"!a\"}")
  let context = @json.parse("{\"a\":123}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0751 zero not" {
  let template = @json.parse("{\"$eval\":\"!a\"}")
  let context = @json.parse("{\"a\":0}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0752 null not" {
  let template = @json.parse("{\"$eval\":\"!a\"}")
  let context = @json.parse("{\"a\":null}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0753 object not" {
  let template = @json.parse("{\"$eval\":\"!a\"}")
  let context = @json.parse("{\"a\":{\"x\":1}}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0754 empty object not" {
  let template = @json.parse("{\"$eval\":\"!a\"}")
  let context = @json.parse("{\"a\":{}}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0755 array not" {
  let template = @json.parse("{\"$eval\":\"!a\"}")
  let context = @json.parse("{\"a\":[1,2]}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0756 empty array not" {
  let template = @json.parse("{\"$eval\":\"!a\"}")
  let context = @json.parse("{\"a\":[]}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0757 function not" {
  let template = @json.parse("{\"$eval\":\"!min\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0758 string and string" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":\"abc\"}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0759 string or string" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":\"abc\"}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0760 string and number" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":123}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0761 string or number" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":123}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0762 string and null" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":null}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0763 string or null" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":null}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0764 string and boolean" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":true}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0765 string or boolean" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":true}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0766 string and object" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":{}}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0767 string or object" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":{}}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0768 string and array" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":[]}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0769 string or array" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":[]}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0770 number and string" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":345,\"b\":\"abc\"}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0771 number or string" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":345,\"b\":\"abc\"}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0772 number and number" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":345,\"b\":123}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0773 number or number" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":345,\"b\":123}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0774 number and null" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":345,\"b\":null}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0775 number or null" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":345,\"b\":null}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0776 number and boolean" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":345,\"b\":true}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0777 number or boolean" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":345,\"b\":true}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0778 number and object" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":345,\"b\":{}}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0779 number or object" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":345,\"b\":{}}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0780 number and array" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":345,\"b\":[]}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0781 number or array" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":345,\"b\":[]}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0782 null and string" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":null,\"b\":\"abc\"}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0783 null or string" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":null,\"b\":\"abc\"}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0784 null and number" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":null,\"b\":123}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0785 null or number" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":null,\"b\":123}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0786 null and null" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":null,\"b\":null}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0787 null or null" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":null,\"b\":null}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0788 null and boolean" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":null,\"b\":true}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0789 null or boolean" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":null,\"b\":true}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0790 null and object" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":null,\"b\":{}}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0791 null or object" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":null,\"b\":{}}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0792 null and array" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":null,\"b\":[]}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0793 null or array" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":null,\"b\":[]}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0794 boolean and string" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":true,\"b\":\"abc\"}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0795 boolean or string" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":true,\"b\":\"abc\"}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0796 boolean and number" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":true,\"b\":123}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0797 boolean or number" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":true,\"b\":123}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0798 boolean and null" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":true,\"b\":null}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0799 boolean or null" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":true,\"b\":null}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0800 boolean and boolean" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":true,\"b\":true}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0801 boolean or boolean" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":true,\"b\":true}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0802 boolean and object" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":true,\"b\":{}}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0803 boolean or object" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":true,\"b\":{}}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0804 boolean and array" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":true,\"b\":[]}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0805 boolean or array" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":true,\"b\":[]}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0806 object and string" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":{},\"b\":\"abc\"}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0807 object or string" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":{},\"b\":\"abc\"}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0808 object and number" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":{},\"b\":123}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0809 object or number" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":{},\"b\":123}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0810 object and null" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":{},\"b\":null}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0811 object or null" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":{},\"b\":null}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0812 object and boolean" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":{},\"b\":true}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0813 object or boolean" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":{},\"b\":true}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0814 object and object" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":{},\"b\":{}}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0815 object or object" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":{},\"b\":{}}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0816 object and array" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":{},\"b\":[]}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0817 object or array" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":{},\"b\":[]}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0818 array and string" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":[],\"b\":\"abc\"}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0819 array or string" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":[],\"b\":\"abc\"}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0820 array and number" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":[],\"b\":123}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0821 array or number" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":[],\"b\":123}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0822 array and null" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":[],\"b\":null}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0823 array or null" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":[],\"b\":null}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0824 array and boolean" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":[],\"b\":true}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0825 array or boolean" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":[],\"b\":true}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0826 array and object" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":[],\"b\":{}}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0827 array or object" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":[],\"b\":{}}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0828 array and array" {
  let template = @json.parse("{\"$eval\":\"a && b\"}")
  let context = @json.parse("{\"a\":[],\"b\":[]}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0829 array or array" {
  let template = @json.parse("{\"$eval\":\"a || b\"}")
  let context = @json.parse("{\"a\":[],\"b\":[]}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0830 short-circuit evaluation for and" {
  let template = @json.parse("{\"$eval\":\"false && b\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0831 short-circuit evaluation for or" {
  let template = @json.parse("{\"$eval\":\"true || b\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0832 string concatenation (1)" {
  let template = @json.parse("{\"$eval\":\"\\\"a\\\" + \\\"b\\\"\"}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let expected = @json.parse("\"ab\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0833 TypeError: string + number (1)" {
  let template = @json.parse("{\"$eval\":\"\\\"a\\\" + b\"}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0834 TypeError: string + number (2)" {
  let template = @json.parse("{\"$eval\":\"\\\"\\\" + a + b\"}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0835 TypeError: string + number (3)" {
  let template = @json.parse("{\"$eval\":\"\\\"\\\" + (a + b)\"}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0836 TypeError: number + string (4)" {
  let template = @json.parse("{\"$eval\":\"(a + b) + \\\"abc\\\"\"}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0837 string indexing (1)" {
  let template = @json.parse("{\"$eval\":\"key[1]\"}")
  let context = @json.parse("{\"key\":\"12345\"}")
  let expected = @json.parse("\"2\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0838 string indexing (2)" {
  let template = @json.parse("{\"$eval\":\"key[-2]\"}")
  let context = @json.parse("{\"key\":\"12345\"}")
  let expected = @json.parse("\"4\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0839 string indexing (3)" {
  let template = @json.parse("{\"$eval\":\"\\\"12345\\\"[1]\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"2\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0840 string indexing (4)" {
  let template = @json.parse("{\"$eval\":\"\\\"12345\\\"[-2]\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("\"4\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0841 string indexing (unicode)" {
  let template = @json.parse("{\"$eval\":\"[key[0], key[2], key[-1]]\"}")
  let context = @json.parse("{\"key\":\"\\u2622abc\\ud83d\\ude01\"}")
  let expected = @json.parse("[\"\\u2622\",\"b\",\"\\ud83d\\ude01\"]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0842 string indexing (noninteger)" {
  let template = @json.parse("{\"$eval\":\"\\\"12345\\\"[2.5]\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0843 string slicing (1)" {
  let template = @json.parse("{\"$eval\":\"key[1:-1]\"}")
  let context = @json.parse("{\"key\":\"12345\"}")
  let expected = @json.parse("\"234\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0844 string slicing (2)" {
  let template = @json.parse("{\"$eval\":\"key[-2:]\"}")
  let context = @json.parse("{\"key\":\"12345\"}")
  let expected = @json.parse("\"45\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0845 string slicing (noninteger first index)" {
  let template = @json.parse("{\"$eval\":\"key[1.5:3]\"}")
  let context = @json.parse("{\"key\":\"12345\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0846 string slicing (noninteger second index)" {
  let template = @json.parse("{\"$eval\":\"key[1:3.5]\"}")
  let context = @json.parse("{\"key\":\"12345\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0847 string slicing (noninteger indexes)" {
  let template = @json.parse("{\"$eval\":\"key[1.5:3.5]\"}")
  let context = @json.parse("{\"key\":\"12345\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0848 string slicing type error (1)" {
  let template = @json.parse("{\"$eval\":\"key[\\\"a\\\":]\"}")
  let context = @json.parse("{\"key\":\"12345\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0849 string slicing type error (2)" {
  let template = @json.parse("{\"$eval\":\"key[:\\\"a\\\"]\"}")
  let context = @json.parse("{\"key\":\"12345\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0850 string length attribute is an error" {
  let template = @json.parse("{\"$eval\":\"key.length\"}")
  let context = @json.parse("{\"key\":\"12345\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0851 string length attribute is an error even by index" {
  let template = @json.parse("{\"$eval\":\"key[\\\"length\\\"]\"}")
  let context = @json.parse("{\"key\":\"12345\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0852 other string attributes are not set" {
  let template = @json.parse("{\"$eval\":\"key.toUpperCase()\"}")
  let context = @json.parse("{\"key\":\"abc\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0853 non-identifier after dot" {
  let template = @json.parse("{\"$eval\":\"key.{\"}")
  let context = @json.parse("{\"key\":{}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0854 property with numeric value" {
  let template = @json.parse("{\"$eval\":\"key\"}")
  let context = @json.parse("{\"key\":1}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0855 property with string value" {
  let template = @json.parse("{\"$eval\":\"key\"}")
  let context = @json.parse("{\"key\":\"a\"}")
  let expected = @json.parse("\"a\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0856 property with boolean value" {
  let template = @json.parse("{\"$eval\":\"key\"}")
  let context = @json.parse("{\"key\":true}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0857 property with object value" {
  let template = @json.parse("{\"$eval\":\"key\"}")
  let context = @json.parse("{\"key\":{\"a\":1}}")
  let expected = @json.parse("{\"a\":1}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0858 property with null value" {
  let template = @json.parse("{\"$eval\":\"key\"}")
  let context = @json.parse("{\"key\":\"null\"}")
  let expected = @json.parse("\"null\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0859 property that is also a function name" {
  let template = @json.parse("{\"$eval\":\"min\"}")
  let context = @json.parse("{\"min\":\"abc\"}")
  let expected = @json.parse("\"abc\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0860 missing property" {
  let template = @json.parse("{\"$eval\":\"key.b\"}")
  let context = @json.parse("{\"key\":{\"a\":1}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0861 missing property by name" {
  let template = @json.parse("{\"$eval\":\"key[\\\"b\\\"]\"}")
  let context = @json.parse("{\"key\":{\"a\":1}}")
  let expected = @json.parse("null")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0862 single property access with object value" {
  let template = @json.parse("{\"$eval\":\"key.key2\"}")
  let context = @json.parse("{\"key\":{\"key2\":3}}")
  let expected = @json.parse("3")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0863 nested property access with object value" {
  let template = @json.parse("{\"$eval\":\"key.key2.key3\"}")
  let context = @json.parse("{\"key\":{\"key2\":{\"key3\":{\"a\":1}}}}")
  let expected = @json.parse("{\"a\":1}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0864 nested property access with numeric value" {
  let template = @json.parse("{\"$eval\":\"key[\\\"key2\\\"][\\\"key3\\\"]\"}")
  let context = @json.parse("{\"key\":{\"key2\":{\"key3\":1}}}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0865 nested property access with dot following ]" {
  let template = @json.parse("{\"$eval\":\"key[\\\"key2\\\"].key3\"}")
  let context = @json.parse("{\"key\":{\"key2\":{\"key3\":1}}}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0866 nested property with object in parentheses" {
  let template = @json.parse("{\"$eval\":\"(key)[\\\"key2\\\"]\"}")
  let context = @json.parse("{\"key\":{\"key2\":true}}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0867 nested property with object expression" {
  let template = @json.parse("{\"$eval\":\"(keys[keyid])[\\\"key2\\\"]\"}")
  let context = @json.parse("{\"keyid\":1,\"keys\":[false,{\"key2\":true}]}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0868 property access with expression value" {
  let template = @json.parse("{\"$eval\":\"values[key]\"}")
  let context = @json.parse(
    "{\"key\":\"abc\",\"values\":{\"abc\":2,\"def\":3}}",
  )
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0869 property starting with underscore" {
  let template = @json.parse("{\"$eval\":\"_key\"}")
  let context = @json.parse("{\"_key\":\"abc\"}")
  let expected = @json.parse("\"abc\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0870 property containing underscore" {
  let template = @json.parse("{\"$eval\":\"my_key\"}")
  let context = @json.parse("{\"my_key\":\"abc\"}")
  let expected = @json.parse("\"abc\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0871 property containing hyphen" {
  let template = @json.parse("{\"$eval\":\"my-key\"}")
  let context = @json.parse("{\"my-key\":\"abc\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0872 property starting with capital" {
  let template = @json.parse("{\"$eval\":\"Key\"}")
  let context = @json.parse("{\"Key\":\"abc\"}")
  let expected = @json.parse("\"abc\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0873 property containing capital" {
  let template = @json.parse("{\"$eval\":\"kEy\"}")
  let context = @json.parse("{\"kEy\":\"abc\"}")
  let expected = @json.parse("\"abc\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0874 case sensitivity of keys" {
  let template = @json.parse("{\"$eval\":\"Key\"}")
  let context = @json.parse("{\"key\":\"abc\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0875 property starting with number" {
  let template = @json.parse("{\"$eval\":\"2fast\"}")
  let context = @json.parse("{\"2fast\":\"abc\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0876 property containing number" {
  let template = @json.parse("{\"$eval\":\"furious5\"}")
  let context = @json.parse("{\"furious5\":\"abc\"}")
  let expected = @json.parse("\"abc\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0877 nested property starting with underscore" {
  let template = @json.parse("{\"$eval\":\"key._foo\"}")
  let context = @json.parse("{\"key\":{\"_foo\":\"abc\"}}")
  let expected = @json.parse("\"abc\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0878 nested property containing underscore" {
  let template = @json.parse("{\"$eval\":\"key.foo_bar\"}")
  let context = @json.parse("{\"key\":{\"foo_bar\":\"abc\"}}")
  let expected = @json.parse("\"abc\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0879 nested property containing hyphen" {
  let template = @json.parse("{\"$eval\":\"key.my-foo\"}")
  let context = @json.parse("{\"key\":{\"my-foo\":\"abc\"}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0880 nested property containing hyphen using brackets" {
  let template = @json.parse("{\"$eval\":\"key['my-foo']\"}")
  let context = @json.parse("{\"key\":{\"my-foo\":\"abc\"}}")
  let expected = @json.parse("\"abc\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0881 nested property starting with capital" {
  let template = @json.parse("{\"$eval\":\"key.Foo\"}")
  let context = @json.parse("{\"key\":{\"Foo\":\"abc\"}}")
  let expected = @json.parse("\"abc\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0882 nested property containing capital" {
  let template = @json.parse("{\"$eval\":\"key.fOo\"}")
  let context = @json.parse("{\"key\":{\"fOo\":\"abc\"}}")
  let expected = @json.parse("\"abc\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0883 case sensitivity of nested keys" {
  let template = @json.parse("{\"$eval\":\"key.Foo\"}")
  let context = @json.parse("{\"key\":{\"foo\":\"abc\"}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0884 property access with number" {
  let template = @json.parse("{\"$eval\":\"obj[key]\"}")
  let context = @json.parse("{\"obj\":{\"13\":15},\"key\":13}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0885 property of number" {
  let template = @json.parse("{\"$eval\":\"key.valueOf\"}")
  let context = @json.parse("{\"key\":123}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0886 property of null" {
  let template = @json.parse("{\"$eval\":\"key.foo\"}")
  let context = @json.parse("{\"key\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0887 property of boolean" {
  let template = @json.parse("{\"$eval\":\"key.valueOf\"}")
  let context = @json.parse("{\"key\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0888 property of array" {
  let template = @json.parse("{\"$eval\":\"key.valueOf\"}")
  let context = @json.parse("{\"key\":[]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0889 non-identifier after dot" {
  let template = @json.parse("{\"$eval\":\"key.{\"}")
  let context = @json.parse("{\"key\":{}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0890 non-identifier after dot (2)" {
  let template = @json.parse("{\"$eval\":\"key.{\"}")
  let context = @json.parse("{\"key\":{}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0891 numeric" {
  let template = @json.parse("{\"$eval\":\"key[0]\"}")
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0892 numeric, nonzero index" {
  let template = @json.parse("{\"$eval\":\"key[2]\"}")
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let expected = @json.parse("3")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0893 numeric, noninteger index" {
  let template = @json.parse("{\"$eval\":\"key[2.5]\"}")
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0894 arithemtic with results" {
  let template = @json.parse(
    "{\"$eval\":\"key[0] + key[1] + key[2] + key[3] + key[4]\"}",
  )
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let expected = @json.parse("15")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0895 string index" {
  let template = @json.parse("{\"$eval\":\"key[\\\"a\\\"]\"}")
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0896 too-large index" {
  let template = @json.parse("{\"$eval\":\"key[999]\"}")
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0897 negative index" {
  let template = @json.parse("{\"$eval\":\"key[-1]\"}")
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let expected = @json.parse("5")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0898 nested, in property accesses" {
  let template = @json.parse("{\"$eval\":\"key.key2.key3[0]\"}")
  let context = @json.parse("{\"key\":{\"key2\":{\"key3\":[1,2,3,4,5]}}}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0899 nested, in property access by string" {
  let template = @json.parse(
    "{\"$eval\":\"key[\\\"key2\\\"][\\\"key3\\\"][0]\"}",
  )
  let context = @json.parse("{\"key\":{\"key2\":{\"key3\":[1,2,3,4,5]}}}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0900 nested, nonzero index" {
  let template = @json.parse("{\"$eval\":\"key.key2.key3[2]\"}")
  let context = @json.parse("{\"key\":{\"key2\":{\"key3\":[1,2,3,4,5]}}}")
  let expected = @json.parse("3")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0901 nested, nonzero index, in property access by string" {
  let template = @json.parse(
    "{\"$eval\":\"key[\\\"key2\\\"][\\\"key3\\\"][2]\"}",
  )
  let context = @json.parse("{\"key\":{\"key2\":{\"key3\":[1,2,3,4,5]}}}")
  let expected = @json.parse("3")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0902 nested, with arithmetic" {
  let template = @json.parse(
    "{\"$eval\":\"key.key2.key3[0] + key.key2.key3[1] + key.key2.key3[2] + key.key2.key3[3] + key.key2.key3[4]\"}",
  )
  let context = @json.parse("{\"key\":{\"key2\":{\"key3\":[1,2,3,4,5]}}}")
  let expected = @json.parse("15")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0903 nested, with arithmetic, in property access by string" {
  let template = @json.parse(
    "{\"$eval\":\"key[\\\"key2\\\"][\\\"key3\\\"][0] + key[\\\"key2\\\"][\\\"key3\\\"][1] + key[\\\"key2\\\"][\\\"key3\\\"][2] + key[\\\"key2\\\"][\\\"key3\\\"][3] + key[\\\"key2\\\"][\\\"key3\\\"][4]\"}",
  )
  let context = @json.parse("{\"key\":{\"key2\":{\"key3\":[1,2,3,4,5]}}}")
  let expected = @json.parse("15")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0904 indexing number" {
  let template = @json.parse("{\"$eval\":\"key[2]\"}")
  let context = @json.parse("{\"key\":123}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0905 indexing null" {
  let template = @json.parse("{\"$eval\":\"key[2]\"}")
  let context = @json.parse("{\"key\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0906 indexing boolean" {
  let template = @json.parse("{\"$eval\":\"key[2]\"}")
  let context = @json.parse("{\"key\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0907 indexing object" {
  let template = @json.parse("{\"$eval\":\"key[2]\"}")
  let context = @json.parse("{\"key\":{\"x\":10}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0908 array length property is an error" {
  let template = @json.parse("{\"$eval\":\"key.length\"}")
  let context = @json.parse("{\"key\":[1,3,5]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0909 array length property is an error even by index" {
  let template = @json.parse("{\"$eval\":\"key[\\\"length\\\"]\"}")
  let context = @json.parse("{\"key\":[1,3,5]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0910 other array attributes are not available" {
  let template = @json.parse("{\"$eval\":\"key.sort\"}")
  let context = @json.parse("{\"key\":[5,3,1]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0911 array slicing (full slice)" {
  let template = @json.parse("{\"$eval\":\"key[0:5]\"}")
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let expected = @json.parse("[1,2,3,4,5]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0912 array slicing (prefix)" {
  let template = @json.parse("{\"$eval\":\"key[0:3]\"}")
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let expected = @json.parse("[1,2,3]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0913 array slicing (out of order)" {
  let template = @json.parse("{\"$eval\":\"key[3:2]\"}")
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let expected = @json.parse("[]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0914 array slicing (negative indices)" {
  let template = @json.parse("{\"$eval\":\"key[-5:-1]\"}")
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let expected = @json.parse("[1,2,3,4]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0915 array slicing (negative indices larger than length)" {
  let template = @json.parse("{\"$eval\":\"key[-10:-1]\"}")
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let expected = @json.parse("[1,2,3,4]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0916 array slicing (noninteger first index)" {
  let template = @json.parse("{\"$eval\":\"key[2.5: 4]\"}")
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0917 array slicing (noninteger last index)" {
  let template = @json.parse("{\"$eval\":\"key[2: 3.5]\"}")
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0918 array slicing (noninteger indexes)" {
  let template = @json.parse("{\"$eval\":\"key[2.5: 3.5]\"}")
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0919 array slicing (floor)" {
  let template = @json.parse("{\"$eval\":\"key[:floor(len(key)/2)]\"}")
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let expected = @json.parse("[1,2]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0920 array slicing (no end index)" {
  let template = @json.parse("{\"$eval\":\"key[-4:]\"}")
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let expected = @json.parse("[2,3,4,5]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0921 array slicing (no start index)" {
  let template = @json.parse("{\"$eval\":\"key[:-3]\"}")
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let expected = @json.parse("[1,2]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0922 array slicing type error (1)" {
  let template = @json.parse("{\"$eval\":\"key[\\\"a\\\":]\"}")
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0923 array slicing type error (2)" {
  let template = @json.parse("{\"$eval\":\"key[:\\\"a\\\"]\"}")
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0924 array slicing type error (3)" {
  let template = @json.parse("{\"$eval\":\"key[\\\"a\\\":\\\"b\\\"]\"}")
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0925 array slicing type error (4)" {
  let template = @json.parse("{\"$eval\":\"key[1:\\\"a\\\"]\"}")
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0926 array slicing type error (5)" {
  let template = @json.parse("{\"$eval\":\"key[\\\"a\\\":2]\"}")
  let context = @json.parse("{\"key\":[1,2,3,4,5]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0927 slicing number" {
  let template = @json.parse("{\"$eval\":\"key[2:]\"}")
  let context = @json.parse("{\"key\":123}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0928 slicing null" {
  let template = @json.parse("{\"$eval\":\"key[2:]\"}")
  let context = @json.parse("{\"key\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0929 slicing boolean" {
  let template = @json.parse("{\"$eval\":\"key[2:]\"}")
  let context = @json.parse("{\"key\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0930 slicing object" {
  let template = @json.parse("{\"$eval\":\"key[2:]\"}")
  let context = @json.parse("{\"key\":{\"x\":10}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0931 string slicing - full" {
  let template = @json.parse("{\"$eval\":\"key[0:6]\"}")
  let context = @json.parse("{\"key\":\"hello\"}")
  let expected = @json.parse("\"hello\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0932 string slicing - prefix" {
  let template = @json.parse("{\"$eval\":\"key[0:3]\"}")
  let context = @json.parse("{\"key\":\"hello\"}")
  let expected = @json.parse("\"hel\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0933 string slicing - omitted first index" {
  let template = @json.parse("{\"$eval\":\"key[:3]\"}")
  let context = @json.parse("{\"key\":\"hello\"}")
  let expected = @json.parse("\"hel\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0934 string slicing - omitted second index" {
  let template = @json.parse("{\"$eval\":\"key[3:]\"}")
  let context = @json.parse("{\"key\":\"hello\"}")
  let expected = @json.parse("\"lo\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0935 string slicing - negative index, omitted second index" {
  let template = @json.parse("{\"$eval\":\"key[-3:]\"}")
  let context = @json.parse("{\"key\":\"hello\"}")
  let expected = @json.parse("\"llo\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0936 string slicing - negative index" {
  let template = @json.parse("{\"$eval\":\"key[-3:4]\"}")
  let context = @json.parse("{\"key\":\"hello\"}")
  let expected = @json.parse("\"ll\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0937 string slicing - negative greater than length" {
  let template = @json.parse("{\"$eval\":\"key[-9:]\"}")
  let context = @json.parse("{\"key\":\"hello\"}")
  let expected = @json.parse("\"hello\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0938 string slicing - unicode indices" {
  let template = @json.parse("{\"$eval\":\"[key[0:1], key[1:4], key[-1:]]\"}")
  let context = @json.parse("{\"key\":\"\\u2622abc\\ud83d\\ude01\"}")
  let expected = @json.parse("[\"\\u2622\",\"abc\",\"\\ud83d\\ude01\"]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0939 function call (1)" {
  let template = @json.parse("{\"$eval\":\"min(a, b)\"}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0940 function call (2)" {
  let template = @json.parse("{\"$eval\":\"min(3, b)\"}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0941 function call (3)" {
  let template = @json.parse("{\"$eval\":\"min(a, 2)\"}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0942 function call (4)" {
  let template = @json.parse("{\"$eval\":\"min(3, 2)\"}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let expected = @json.parse("2")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0943 function call (5)" {
  let template = @json.parse("{\"$eval\":\"max(a, b)\"}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let expected = @json.parse("3")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0944 function call (6)" {
  let template = @json.parse("{\"$eval\":\"max(3, b)\"}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let expected = @json.parse("3")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0945 function call (7)" {
  let template = @json.parse("{\"$eval\":\"max(a, 2)\"}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let expected = @json.parse("3")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0946 function call (8)" {
  let template = @json.parse("{\"$eval\":\"max(3, 2)\"}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let expected = @json.parse("3")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0947 function call (9)" {
  let template = @json.parse("{\"$eval\":\"min(a, b) + max(a, b)\"}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let expected = @json.parse("5")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0948 function call (10)" {
  let template = @json.parse("{\"$eval\":\"min(3, b) + max(3, b)\"}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let expected = @json.parse("5")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0949 function call (11)" {
  let template = @json.parse("{\"$eval\":\"min(a, 2) + max(a, 2)\"}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let expected = @json.parse("5")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0950 function call (12)" {
  let template = @json.parse("{\"$eval\":\"min(3, 2) + max(3, 2)\"}")
  let context = @json.parse("{\"a\":3,\"b\":2}")
  let expected = @json.parse("5")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0951 function call (13)" {
  let template = @json.parse(
    "{\"$let\":{\"functions\":[{\"$eval\":\"min\"},{\"$eval\":\"max\"}]},\"in\":{\"$eval\":\"functions[1](2, 3)\"}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("3")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0952 function call (14)" {
  let template = @json.parse("{\"$eval\":\"[max,min][1](5, 1)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0953 function name is not callable" {
  let template = @json.parse("{\"$eval\":\"function(10)\"}")
  let context = @json.parse("{\"function\":\"hi\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0954 parenthesized function expression" {
  let template = @json.parse("{\"$eval\":\"(min)(10, 20)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("10")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0955 dotted function expression" {
  let template = @json.parse(
    "{\"$let\":{\"negated\":{\"max\":{\"$eval\":\"min\"},\"min\":{\"$eval\":\"max\"}}},\"in\":{\"$eval\":\"(negated.min)(10, 20)\"}}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("20")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0956 accessor after function call" {
  let template = @json.parse(
    "{\"$eval\":\"split(\\\"left:right\\\", \\\":\\\")[1]\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("\"right\"")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0957 in operator on string, success (1)" {
  let template = @json.parse("{\"$eval\":\"\\\"abc\\\" in \\\"aabc\\\"\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0958 in operator on string, failure (2)" {
  let template = @json.parse("{\"$eval\":\"\\\"efg\\\" in \\\"aabc\\\"\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0959 in operator on string, success (3)" {
  let template = @json.parse("{\"$eval\":\"\\\"abc\\\" in key\"}")
  let context = @json.parse("{\"key\":\"aabc\"}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0960 in operator on string, failure (4)" {
  let template = @json.parse("{\"$eval\":\"\\\"efg\\\" in key\"}")
  let context = @json.parse("{\"key\":\"aabc\"}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0961 in operator on string, failure (5)" {
  let template = @json.parse("{\"$eval\":\"\\\"2\\\" in key\"}")
  let context = @json.parse("{\"key\":\"aabc\"}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0962 in operator on array, success (1)" {
  let template = @json.parse(
    "{\"$eval\":\"\\\"abc\\\" in [1, \\\"abc\\\", \\\"def\\\"]\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0963 in operator on array, success (2)" {
  let template = @json.parse(
    "{\"$eval\":\"1 in [1, \\\"abc\\\", \\\"def\\\"]\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0964 in operator on array, success (3)" {
  let template = @json.parse("{\"$eval\":\"\\\"abc\\\" in key\"}")
  let context = @json.parse("{\"key\":[1,\"abc\",\"def\"]}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0965 in operator on array, success (3)" {
  let template = @json.parse("{\"$eval\":\"1 in key\"}")
  let context = @json.parse("{\"key\":[1,\"abc\",\"def\"]}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0966 in operator on array, failure (1)" {
  let template = @json.parse(
    "{\"$eval\":\"\\\"efg\\\" in [1, \\\"abc\\\", \\\"def\\\"]\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0967 in operator on array, failure (2)" {
  let template = @json.parse(
    "{\"$eval\":\"2 in [1, \\\"abc\\\", \\\"def\\\"]\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0968 in operator on array, failure (2)" {
  let template = @json.parse("{\"$eval\":\"\\\"efg\\\" in key\"}")
  let context = @json.parse("{\"key\":[1,\"abc\",\"def\"]}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0969 in operator on array, failure (4)" {
  let template = @json.parse("{\"$eval\":\"2 in key\"}")
  let context = @json.parse("{\"key\":[1,\"abc\",\"def\"]}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0970 in operator on object, success (1)" {
  let template = @json.parse(
    "{\"$eval\":\"\\\"a\\\" in {\\\"a\\\": 1, b: 2}\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0971 in operator on object, success (2)" {
  let template = @json.parse("{\"$eval\":\"\\\"a\\\" in key\"}")
  let context = @json.parse("{\"key\":{\"a\":1,\"b\":2}}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0972 in operator on object, success (3)" {
  let template = @json.parse(
    "{\"$eval\":\"\\\"3.4\\\" in {\\\"3.4\\\": 1, \\\"b\\\": 2}\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0973 in operator on object, failure (1)" {
  let template = @json.parse(
    "{\"$eval\":\"\\\"c\\\" in {a: 1, \\\"b\\\": 2}\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0974 in operator on object, failure (2)" {
  let template = @json.parse("{\"$eval\":\"\\\"c\\\" in key\"}")
  let context = @json.parse("{\"key\":{\"a\":1,\"b\":2}}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0975 in operator on object, failure (3)" {
  let template = @json.parse(
    "{\"$eval\":\"\\\"a\\\" in {\\\"3\\\": 1, \\\"b\\\": 2}\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0976 in operator on object, failure (4)" {
  let template = @json.parse(
    "{\"$eval\":\"\\\"3.4\\\" in {\\\"3\\\": 1, \\\"b\\\": 2}\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0977 TypeError: in operator on Object, error (1)" {
  let template = @json.parse("{\"$eval\":\"[] in key\"}")
  let context = @json.parse("{\"key\":{\"a\":1,\"b\":2}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0978 TypeError: in operator on Object, error (2)" {
  let template = @json.parse("{\"$eval\":\"{} in key\"}")
  let context = @json.parse("{\"key\":{\"a\":1,\"b\":2}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0979 TypeError: in operator on Object, error (3)" {
  let template = @json.parse("{\"$eval\":\"1 in key\"}")
  let context = @json.parse("{\"key\":{\"a\":1,\"b\":2}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0980 TypeError: in operator on Array, Array not found" {
  let template = @json.parse("{\"$eval\":\"[] in key\"}")
  let context = @json.parse("{\"key\":[2,3,4]}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0981 TypeError: in operator on String, error (1)" {
  let template = @json.parse("{\"$eval\":\"[] in key\"}")
  let context = @json.parse("{\"key\":\"hello world!\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0982 TypeError: in operator on String, error (2)" {
  let template = @json.parse("{\"$eval\":\"{} in key\"}")
  let context = @json.parse("{\"key\":\"hello world!\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0983 TypeError: in operator on String, error (3)" {
  let template = @json.parse("{\"$eval\":\"1 in key\"}")
  let context = @json.parse("{\"key\":\"hello world!\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0984 TypeError: in operator on Array, object not found" {
  let template = @json.parse("{\"$eval\":\"{} in key\"}")
  let context = @json.parse("{\"key\":[2,3,4]}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0985 no type conversion from num to string in array" {
  let template = @json.parse("{\"$eval\":\"5 in [\\\"5\\\", \\\"five\\\"]\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0986 no type conversion from string to num in array" {
  let template = @json.parse("{\"$eval\":\"\\\"5\\\" in [5]\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0987 cannot search for num in object" {
  let template = @json.parse("{\"$eval\":\"5 in {\\\"5\\\": \\\"five\\\"}\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 0988 deep equality, object on left side, found" {
  let template = @json.parse(
    "{\"$eval\":\"{a: 45} in [\\\"string\\\", 46, {a: 45}]\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0989 deep equality, object on left side, not found" {
  let template = @json.parse(
    "{\"$eval\":\"{a: {b: 13}} in [\\\"string\\\", 46, {a: {b: 14}}]\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0990 deep equality, Array on left side, found" {
  let template = @json.parse(
    "{\"$eval\":\"[44, 45] in [\\\"string\\\", 46, [44, 45]]\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0991 deep equality, Array on left side, not found" {
  let template = @json.parse(
    "{\"$eval\":\"[44, 45] in [\\\"string\\\", 46, [44]]\"}",
  )
  let context = @json.parse("{}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0992 precedence of in over ||" {
  let template = @json.parse("{\"$eval\":\"a in b || true\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":\"ab\"}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0993 precedence of in over &&" {
  let template = @json.parse("{\"$eval\":\"a in b && true\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":\"bc\"}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0994 compare precedence of in and ==" {
  let template = @json.parse("{\"$eval\":\"a in b || x==y\"}")
  let context = @json.parse("{\"a\":\"a\",\"b\":\"ab\",\"x\":5,\"y\":7}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0995 equality (1)" {
  let template = @json.parse("{\"$eval\":\"1 == 1\"}")
  let context = @json.parse("{\"a\":1,\"b\":1}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0996 equality (2)" {
  let template = @json.parse("{\"$eval\":\"1 == 2\"}")
  let context = @json.parse("{\"a\":1,\"b\":1}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0997 equality (3)" {
  let template = @json.parse("{\"$eval\":\"4 == 3.2 + 0.8\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0998 equality (4)" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":1,\"b\":1}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 0999 equality (5)" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1000 object equality, true" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":{\"x\":1,\"y\":2},\"b\":{\"x\":1,\"y\":2}}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1001 object equality, false" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":{\"x\":1,\"y\":2},\"b\":{\"x\":2,\"y\":2}}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1002 object in-equality, true" {
  let template = @json.parse("{\"$eval\":\"a != b\"}")
  let context = @json.parse("{\"a\":{\"x\":1,\"y\":2},\"b\":{\"x\":2,\"y\":2}}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1003 object in-equality, false" {
  let template = @json.parse("{\"$eval\":\"a != b\"}")
  let context = @json.parse("{\"a\":{\"x\":1,\"y\":2},\"b\":{\"x\":1,\"y\":2}}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1004 complex object equality, true" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse(
    "{\"a\":{\"x\":1,\"y\":{\"e\":{\"g\":{\"one\":1}}}},\"b\":{\"x\":1,\"y\":{\"e\":{\"g\":{\"one\":1}}}}}",
  )
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1005 complex object equality, false" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse(
    "{\"a\":{\"x\":1,\"y\":{\"e\":{\"g\":{\"one\":1}}}},\"b\":{\"x\":1,\"y\":{\"e\":{\"g\":{\"two\":2}}}}}",
  )
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1006 complex object in-equality, true" {
  let template = @json.parse("{\"$eval\":\"a != b\"}")
  let context = @json.parse(
    "{\"a\":{\"x\":1,\"y\":{\"e\":{\"g\":{\"one\":1}}}},\"b\":{\"x\":1,\"y\":{\"e\":{\"g\":{\"two\":2}}}}}",
  )
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1007 complex object in-equality, false" {
  let template = @json.parse("{\"$eval\":\"a != b\"}")
  let context = @json.parse(
    "{\"a\":{\"x\":1,\"y\":{\"e\":{\"g\":{\"one\":1}}}},\"b\":{\"x\":1,\"y\":{\"e\":{\"g\":{\"one\":1}}}}}",
  )
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1008 in-equality (1)" {
  let template = @json.parse("{\"$eval\":\"1 != 1\"}")
  let context = @json.parse("{\"a\":1,\"b\":1}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1009 in-equality (2)" {
  let template = @json.parse("{\"$eval\":\"1 != 2\"}")
  let context = @json.parse("{\"a\":1,\"b\":1}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1010 in-equality (3)" {
  let template = @json.parse("{\"$eval\":\"a != b\"}")
  let context = @json.parse("{\"a\":1,\"b\":1}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1011 in-equality (4)" {
  let template = @json.parse("{\"$eval\":\"a != b\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1012 less than (1)" {
  let template = @json.parse("{\"$eval\":\"1 < 2\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1013 less than (2)" {
  let template = @json.parse("{\"$eval\":\"2 < 1\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1014 less than (3)" {
  let template = @json.parse("{\"$eval\":\"\\\"a\\\" < \\\"b\\\"\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1015 less than (4)" {
  let template = @json.parse("{\"$eval\":\"\\\"b\\\" < \\\"a\\\"\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1016 less than (5)" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1017 less than (6)" {
  let template = @json.parse("{\"$eval\":\"b < a\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1018 greater than (1)" {
  let template = @json.parse("{\"$eval\":\"2 > 1\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1019 greater than (2)" {
  let template = @json.parse("{\"$eval\":\"1 > 2\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1020 greater than (3)" {
  let template = @json.parse("{\"$eval\":\"\\\"b\\\" > \\\"a\\\"\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1021 greater than (4)" {
  let template = @json.parse("{\"$eval\":\"\\\"a\\\" > \\\"b\\\"\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1022 greater than (5)" {
  let template = @json.parse("{\"$eval\":\"b > a\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1023 greater than (6)" {
  let template = @json.parse("{\"$eval\":\"a > b\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1024 less than equal (1)" {
  let template = @json.parse("{\"$eval\":\"a <= b\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1025 less than equal (2)" {
  let template = @json.parse("{\"$eval\":\"a <= b\"}")
  let context = @json.parse("{\"a\":1,\"b\":1}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1026 less than equal (3)" {
  let template = @json.parse("{\"$eval\":\"b <= a\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1027 less than equal (4)" {
  let template = @json.parse("{\"$eval\":\"b <= a\"}")
  let context = @json.parse("{\"a\":1,\"b\":1}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1028 greater than equal (1)" {
  let template = @json.parse("{\"$eval\":\"b >= a\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1029 greater than equal (2)" {
  let template = @json.parse("{\"$eval\":\"a >= b\"}")
  let context = @json.parse("{\"a\":1,\"b\":1}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1030 greater than equal (3)" {
  let template = @json.parse("{\"$eval\":\"a >= b\"}")
  let context = @json.parse("{\"a\":1,\"b\":2}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1031 greater than equal (4)" {
  let template = @json.parse("{\"$eval\":\"a >= b\"}")
  let context = @json.parse("{\"a\":1,\"b\":1}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1032 deep object equality" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse(
    "{\"a\":{\"left\":1,\"right\":{\"left\":2,\"right\":3}},\"b\":{\"left\":1,\"right\":{\"left\":2,\"right\":3}}}",
  )
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1033 boolean equality" {
  let template = @json.parse("{\"$eval\":\"true == true\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1034 null equality" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":null,\"b\":null}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1035 string equality" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":\"xyz\",\"b\":\"xyz\"}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1036 deep object inequality" {
  let template = @json.parse("{\"$eval\":\"a != b\"}")
  let context = @json.parse(
    "{\"a\":{\"left\":1,\"right\":{\"left\":2,\"right\":3}},\"b\":{\"left\":1,\"right\":{\"left\":3,\"right\":2}}}",
  )
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1037 deep array equality" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":[1,[2,3]],\"b\":[1,[2,3]]}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1038 deep array inequality" {
  let template = @json.parse("{\"$eval\":\"a != b\"}")
  let context = @json.parse("{\"a\":[1,[2,3]],\"b\":[1,[3,2]]}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1039 ordering of string and string" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":\"def\"}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1040 ordering of string and number" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":27}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1041 ordering of string and null" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1042 ordering of string and boolean" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1043 ordering of string and object" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":{}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1044 ordering of string and array" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":[]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1045 ordering of number and string" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":123,\"b\":\"def\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1046 ordering of number and number" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":123,\"b\":27}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1047 ordering of number and null" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":123,\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1048 ordering of number and boolean" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":123,\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1049 ordering of number and object" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":123,\"b\":{}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1050 ordering of number and array" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":123,\"b\":[]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1051 ordering of null and string" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":null,\"b\":\"def\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1052 ordering of null and number" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":null,\"b\":27}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1053 ordering of null and null" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":null,\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1054 ordering of null and boolean" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":null,\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1055 ordering of null and object" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":null,\"b\":{}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1056 ordering of null and array" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":null,\"b\":[]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1057 ordering of boolean and string" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":true,\"b\":\"def\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1058 ordering of boolean and number" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":true,\"b\":27}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1059 ordering of boolean and null" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":true,\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1060 ordering of boolean and boolean" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":true,\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1061 ordering of boolean and object" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":true,\"b\":{}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1062 ordering of boolean and array" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":true,\"b\":[]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1063 ordering of object and string" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":{},\"b\":\"def\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1064 ordering of object and number" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":{},\"b\":27}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1065 ordering of object and null" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":{},\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1066 ordering of object and boolean" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":{},\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1067 ordering of object and object" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":{},\"b\":{}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1068 ordering of object and array" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":{},\"b\":[]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1069 ordering of array and string" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":[],\"b\":\"def\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1070 ordering of array and number" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":[],\"b\":27}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1071 ordering of array and null" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":[],\"b\":null}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1072 ordering of array and boolean" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":[],\"b\":true}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1073 ordering of array and array" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":[],\"b\":{}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1074 ordering of array and array" {
  let template = @json.parse("{\"$eval\":\"a < b\"}")
  let context = @json.parse("{\"a\":[],\"b\":[]}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1075 equality of string and string" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":\"def\"}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1076 equality of string and number" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":27}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1077 equality of string and null" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":null}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1078 equality of string and boolean" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":true}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1079 equality of string and object" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":{}}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1080 equality of string and array" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":\"abc\",\"b\":[]}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1081 equality of number and string" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":123,\"b\":\"def\"}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1082 equality of number and number" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":123,\"b\":27}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1083 equality of number and null" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":123,\"b\":null}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1084 equality of number and boolean" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":123,\"b\":true}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1085 equality of number and object" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":123,\"b\":{}}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1086 equality of number and array" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":123,\"b\":[]}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1087 equality of null and string" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":null,\"b\":\"def\"}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1088 equality of null and number" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":null,\"b\":27}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1089 equality of null and null" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":null,\"b\":null}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1090 equality of null and boolean" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":null,\"b\":true}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1091 equality of null and object" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":null,\"b\":{}}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1092 equality of null and array" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":null,\"b\":[]}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1093 equality of boolean and string" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":true,\"b\":\"def\"}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1094 equality of boolean and number" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":true,\"b\":27}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1095 equality of boolean and null" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":true,\"b\":null}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1096 equality of boolean and boolean" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":true,\"b\":true}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1097 equality of boolean and object" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":true,\"b\":{}}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1098 equality of boolean and array" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":true,\"b\":[]}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1099 equality of object and string" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":{},\"b\":\"def\"}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1100 equality of object and number" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":{},\"b\":27}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1101 equality of object and null" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":{},\"b\":null}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1102 equality of object and boolean" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":{},\"b\":true}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1103 equality of object and object" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":{},\"b\":{}}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1104 equality of object and array" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":{},\"b\":[]}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1105 equality of array and string" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":[],\"b\":\"def\"}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1106 equality of array and number" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":[],\"b\":27}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1107 equality of array and null" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":[],\"b\":null}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1108 equality of array and boolean" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":[],\"b\":true}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1109 equality of array and object" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":[],\"b\":{}}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1110 equality of array and array" {
  let template = @json.parse("{\"$eval\":\"a == b\"}")
  let context = @json.parse("{\"a\":[],\"b\":[]}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1111 equality of functions" {
  let template = @json.parse("{\"$eval\":\"min == min\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("true")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1112 inequality of functions" {
  let template = @json.parse("{\"$eval\":\"min == max\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1113 equality of function and string" {
  let template = @json.parse("{\"$eval\":\"min == \\\"min\\\"\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1114 equality of function and number" {
  let template = @json.parse("{\"$eval\":\"min == 13\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("false")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1115 parse list (1)" {
  let template = @json.parse("{\"$eval\":\"[1,2,3,4]\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("[1,2,3,4]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1116 parse list (2)" {
  let template = @json.parse("{\"$eval\":\"[1,2,3,4][0]\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("1")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1117 parse list (3)" {
  let template = @json.parse("{\"$eval\":\"[1,2,3,4][0:-1]\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("[1,2,3]")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1118 parse list (4)" {
  let template = @json.parse("{\"$eval\":\"[1,2,3,4\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1119 parse object (1)" {
  let template = @json.parse("{\"$eval\":\"{a: key, \\\"b\\\": key + 1}\"}")
  let context = @json.parse("{\"key\":1}")
  let expected = @json.parse("{\"a\":1,\"b\":2}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1120 parse object (2)" {
  let template = @json.parse("{\"$eval\":\"{\\\"a\\\": key, b: key + 1}\"}")
  let context = @json.parse("{\"key\":1}")
  let expected = @json.parse("{\"a\":1,\"b\":2}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1121 parse object (3)" {
  let template = @json.parse(
    "{\"$eval\":\"{\\\"a\\\": key, \\\"b\\\": key + 1}\"}",
  )
  let context = @json.parse("{\"key\":1}")
  let expected = @json.parse("{\"a\":1,\"b\":2}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1122 parse object (4)" {
  let template = @json.parse(
    "{\"$eval\":\"{\\\"a\\\": key, b: [key,key+1,key+2]}\"}",
  )
  let context = @json.parse("{\"key\":1}")
  let expected = @json.parse("{\"a\":1,\"b\":[1,2,3]}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1123 parse object (5)" {
  let template = @json.parse(
    "{\"$eval\":\"{a: key, \\\"b\\\": [key,key+1,key+2]}\"}",
  )
  let context = @json.parse("{\"key\":1}")
  let expected = @json.parse("{\"a\":1,\"b\":[1,2,3]}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1124 parse object (6)" {
  let template = @json.parse(
    "{\"$eval\":\"{\\\"a\\\": key, \\\"b\\\": [key,key+1,key+2]}\"}",
  )
  let context = @json.parse("{\"key\":1}")
  let expected = @json.parse("{\"a\":1,\"b\":[1,2,3]}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1125 parse object (7)" {
  let template = @json.parse("{\"$eval\":\"{a: key, b: [key,key+1,key+2]}\"}")
  let context = @json.parse("{\"key\":1}")
  let expected = @json.parse("{\"a\":1,\"b\":[1,2,3]}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1126 parse object (8)" {
  let template = @json.parse("{\"$eval\":\"{a: key, b: min(key + 1, 1)}\"}")
  let context = @json.parse("{\"key\":1}")
  let expected = @json.parse("{\"a\":1,\"b\":1}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1127 parse object (9)" {
  let template = @json.parse(
    "{\"$eval\":\"{\\\"a\\\": key, b: min(key + 1, 1)}\"}",
  )
  let context = @json.parse("{\"key\":1}")
  let expected = @json.parse("{\"a\":1,\"b\":1}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1128 parse object (10)" {
  let template = @json.parse(
    "{\"$eval\":\"{a: key, \\\"b\\\": min(key + 1, 1)}\"}",
  )
  let context = @json.parse("{\"key\":1}")
  let expected = @json.parse("{\"a\":1,\"b\":1}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1129 parse object (11)" {
  let template = @json.parse(
    "{\"$eval\":\"{\\\"a\\\": key, \\\"b\\\": min(key + 1, 1)}\"}",
  )
  let context = @json.parse("{\"key\":1}")
  let expected = @json.parse("{\"a\":1,\"b\":1}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1130 parse object (12)" {
  let template = @json.parse("{\"$eval\":\"{a: key, b: key + 1\"}")
  let context = @json.parse("{\"key\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1131 parse literal object with a __proto__ key" {
  let template = @json.parse(
    "{\"$eval\":\"{\\\"__proto__\\\": key, \\\"a\\\": key + 1}\"}",
  )
  let context = @json.parse("{\"key\":1}")
  let expected = @json.parse("{\"__proto__\":1,\"a\":2}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1132 parse object with a bar __proto__ literal key" {
  let template = @json.parse("{\"$eval\":\"{__proto__: key, a: key + 1}\"}")
  let context = @json.parse("{\"key\":1}")
  let expected = @json.parse("{\"__proto__\":1,\"a\":2}")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

///|
test "upstream 1133 unary - type error" {
  let template = @json.parse("{\"$eval\":\"-key\"}")
  let context = @json.parse("{\"key\":\"hello\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1134 unary + type error" {
  let template = @json.parse("{\"$eval\":\"+key\"}")
  let context = @json.parse("{\"key\":\"hello\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1135 undefined variable" {
  let template = @json.parse("{\"$eval\":\"key2\"}")
  let context = @json.parse("{\"key\":\"hello\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1136 missing closing parenthesis" {
  let template = @json.parse("{\"$eval\":\"key1 + (key2 + key1\"}")
  let context = @json.parse("{\"key1\":1,\"key2\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1137 missing opening parenthesis" {
  let template = @json.parse("{\"$eval\":\"key1 + key2 + key1)\"}")
  let context = @json.parse("{\"key1\":1,\"key2\":1}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1138 missing closing \"" {
  let template = @json.parse("{\"$eval\":\"\\\"hello\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1139 missing opening \"" {
  let template = @json.parse("{\"$eval\":\"hello\\\"\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1140 Infix + type error" {
  let template = @json.parse("{\"$eval\":\"true + false\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1141 Infix - type error" {
  let template = @json.parse("{\"$eval\":\"\\\"hello\\\" - 3\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1142 Infix * type error" {
  let template = @json.parse("{\"$eval\":\"\\\"hello\\\" * 3\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1143 Infix / type error" {
  let template = @json.parse("{\"$eval\":\"\\\"hello\\\" / 3\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1144 Infix - type error" {
  let template = @json.parse("{\"$eval\":\"3 - \\\"hello\\\"\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1145 Infix * type error" {
  let template = @json.parse("{\"$eval\":\"3 * \\\"hello\\\"\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1146 Infix / type error" {
  let template = @json.parse("{\"$eval\":\"3 / \\\"hello\\\"\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1147 Infix ** type error" {
  let template = @json.parse("{\"$eval\":\"\\\"hello\\\" ** 3\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1148 Infix ** type error" {
  let template = @json.parse("{\"$eval\":\"3 ** \\\"hello\\\"\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1149 Infix < type error" {
  let template = @json.parse("{\"$eval\":\"\\\"hello\\\" < 3\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1150 Infix > type error" {
  let template = @json.parse("{\"$eval\":\"\\\"hello\\\" > 3\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1151 Infix <= type error" {
  let template = @json.parse("{\"$eval\":\"\\\"hello\\\" <= 3\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1152 Infix >= type error" {
  let template = @json.parse("{\"$eval\":\"\\\"hello\\\" >= 3\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1153 Infix < type error" {
  let template = @json.parse("{\"$eval\":\"3 < \\\"hello\\\"\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1154 Infix > type error" {
  let template = @json.parse("{\"$eval\":\"3 > \\\"hello\\\"\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1155 Infix <= type error" {
  let template = @json.parse("{\"$eval\":\"3 <= \\\"hello\\\"\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1156 Infix >= type error" {
  let template = @json.parse("{\"$eval\":\"3 >= \\\"hello\\\"\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1157 Infix access array or string with non-integer type error" {
  let template = @json.parse(
    "{\"$if\":\"extra.attributes['someattr'] == 'x'\",\"then\":true}",
  )
  let context = @json.parse("{\"extra\":{\"attributes\":\"a string!\"}}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1158 Nested error has appropriate message" {
  let template = @json.parse("{\"foo\":[1,{\"123\":[{\"$eval\":10}]}]}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1159 object with missing value " {
  let template = @json.parse("{\"$eval\":\"{a: 1, \\\"b\\\": }\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1160 object missing key and value after comma" {
  let template = @json.parse("{\"$eval\":\"{a: 1,\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1161 array missing value after comma" {
  let template = @json.parse("{\"$eval\":\"[2,1,]\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1162 list with missing first value" {
  let template = @json.parse("{\"$eval\":\"[,2,3]\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1163 list with missing value" {
  let template = @json.parse("{\"$eval\":\"[1,,3]\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1164 empty brackets in property access" {
  let template = @json.parse("{\"$eval\":\"a[]\"}")
  let context = @json.parse("{\"a\":\"0123456789\"}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1165 function call with missing closing bracket" {
  let template = @json.parse("{\"$eval\":\"max(2, 0\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1166 function call with missing argument in brackets" {
  let template = @json.parse("{\"$eval\":\"max(, 0)\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1167 uncalled function" {
  let template = @json.parse("{\"$eval\":\"fromNow\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1168 list expression with uncalled functions" {
  let template = @json.parse("{\"$eval\":\"[min, max]\"}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1169 list with uncalled function inside" {
  let template = @json.parse("[{\"$eval\":\"min\"}]")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1170 object containing uncalled function" {
  let template = @json.parse("{\"maximum\":{\"$eval\":\"max\"}}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1171 deep data structure with uncalled functions" {
  let template = @json.parse(
    "[{\"minimum\":{\"$eval\":\"min\"}},{\"maximum\":{\"$eval\":\"max\"}}]",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1172 $json with an uncalled function" {
  let template = @json.parse("{\"$json\":{\"$eval\":\"lowercase\"}}")
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1173 $json with deep uncalled functions" {
  let template = @json.parse(
    "{\"$json\":[{\"minimum\":{\"$eval\":\"min\"}},{\"maximum\":{\"$eval\":\"max\"}}]}",
  )
  let context = @json.parse("{}")
  let failed = try {
    ignore(@moonjsone.render(template, context, now="2017-01-19T16:27:20.974Z"))
    false
  } catch {
    _ => true
  }
  assert_true(failed)
}

///|
test "upstream 1174 issue 354" {
  let template = @json.parse("{\"$eval\":\"max(3, 2)\"}")
  let context = @json.parse("{}")
  let expected = @json.parse("3")
  let actual = @moonjsone.render(
    template,
    context,
    now="2017-01-19T16:27:20.974Z",
  )
  assert_eq(actual, expected)
}

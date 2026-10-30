///|
fn main raise {
  let context = @json.parse("{\"count\":3,\"prefix\":\"case\"}")
  let template = @json.parse(
    "{\"$map\":{\"$eval\":\"range(0,count)\"},\"each(i)\":{\"id\":\"${prefix}-${i}\",\"amount\":{\"$eval\":\"(i+1)*10\"},\"enabled\":{\"$eval\":\"i<2\"}}}",
  )
  let output = @moonjsone.render(template, context)
  println(output.stringify())
}

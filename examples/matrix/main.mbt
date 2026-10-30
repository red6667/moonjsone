///|
fn main raise {
  let context = @json.parse(
    "{\"os\":[\"linux\",\"windows\"],\"versions\":[20,22]}",
  )
  let template = @json.parse(
    "{\"$flatten\":{\"$map\":{\"$eval\":\"os\"},\"each(platform)\":{\"$map\":{\"$eval\":\"versions\"},\"each(version)\":{\"job\":\"test-${platform}-${version}\",\"os\":{\"$eval\":\"platform\"},\"runtime\":{\"$eval\":\"version\"}}}}}",
  )
  let output = @moonjsone.render(template, context)
  println(output.stringify())
}

///|
fn main raise {
  let context = @json.parse(
    "{\"service\":\"catalog\",\"regions\":[\"east\",\"west\"],\"replicas\":3}",
  )
  let template = @json.parse(
    "{\"$map\":{\"$eval\":\"regions\"},\"each(region)\":{\"apiVersion\":\"apps/v1\",\"kind\":\"Deployment\",\"metadata\":{\"name\":\"${service}-${region}\"},\"spec\":{\"replicas\":{\"$eval\":\"replicas\"},\"template\":{\"spec\":{\"containers\":[{\"name\":\"${service}\",\"image\":\"registry/${service}:1.0\",\"env\":[{\"name\":\"REGION\",\"value\":\"${region}\"}]}]}}}}}",
  )
  let output = @moonjsone.render(template, context)
  println(output.stringify())
}

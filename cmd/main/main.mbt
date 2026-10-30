///|
#cfg(target="js")
fn argument_prefix_length() -> Int32 {
  2
}

///|
#cfg(not(target="js"))
fn argument_prefix_length() -> Int32 {
  1
}

///|
fn main {
  let args = @env.args()
  let prefix = argument_prefix_length()
  if args.length() != prefix + 1 {
    println("MoonJSONE: moon run cmd/main -- '<JSON request or batch>'")
  } else {
    println(@moonjsone.execute(args[prefix]))
  }
}

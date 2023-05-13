

function main()
  l = () -> sleep(1)
  t = @elapsed l()
  println(t)
end

main()
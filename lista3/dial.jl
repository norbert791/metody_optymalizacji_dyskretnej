include("graphAlgorithms.jl")

import .MyGraphAlgorithms

function main()
  MyGraphAlgorithms.runForAlgorithm(MyGraphAlgorithms.dialAlgorithm, "Dial")  
end #main

main()


for fileName in readdir("experimentsOutput")

  fileName = "./experimentsOutput/$fileName"
  fileContent = ""

  open(fileName, "r") do file
    fileContent = readlines(file)
  end #open

  open(fileName, "w") do file
    write(file, "instance,numOfVertices,numOfEdges,averageTime\n")
    for line in fileContent
      write(file, "$line\n")
    end #for
  end #open
end #for
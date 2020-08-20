
os.loadAPI("/rom/apisFiles/item.lua")
os.loadAPI("/rom/apisFiles/gps.lua")
os.loadAPI("/rom/apisFiles/file.lua")
os.loadAPI("/rom/apisFiles/recipe.lua")

function nextChunk()
	--End of spiral - center of spiral
	currentX = file.get(31)-file.get(1)
	currentZ = file.get(32)-file.get(3)
	nextX = currentX
	nextZ = currentZ

	if (currentX <= 0 and currentZ >= 0 and math.floor(-currentX/16) == math.floor(currentZ/16)) then
		toDo = "increaseX"
	elseif (currentX >= 0 and currentZ >= 0 and math.floor(currentX/16)-1 == math.floor(currentZ/16)) then
		toDo = "decreaseZ"
	elseif (currentX >= 0 and currentZ <= 0 and math.floor(currentX/16) == math.floor(-currentZ/16)) then
		toDo = "decreaseX"
	elseif (currentX <= 0 and currentZ <= 0 and math.floor(currentX/16) == math.floor(currentZ/16)) then
		toDo = "increaseZ"
	end
	if toDo == "increaseX" then
		nextX = currentX + 16
	elseif toDo == "decreaseZ" then
		nextZ = currentZ - 16
	elseif toDo == "decreaseX" then
		nextX = currentX - 16
	elseif toDo == "increaseZ" then
		nextZ = currentZ + 16
	end

	file.store(31, nextX+file.get(1))
	file.store(32, nextZ+file.get(3))
end

rednet.open("top")
while true do
  local slavePresent = rednet.receive()

  if slavePresent == true then
    nextChunk()
    --Transfer the data of which chunk to quarry next
    rednet.broadcast(file.get(31))
    os.sleep(1)
    rednet.broadcast(file.get(32))
    os.sleep(1)
    rednet.broadcast(file.get(33))
    os.sleep(1)
    rednet.broadcast(file.get(34))
  end
end

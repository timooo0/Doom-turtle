
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
	--Starts towards to +z direciton, then counterclockwise
	if (currentX <= 0 and currentZ <= 0 and math.floor(currentX/16) == math.floor(currentZ/16)) then
		toDo = "increaseZ"
		print(1)
	elseif (currentX <= 0 and currentZ >= 0 and math.floor(-currentX/16) == (math.floor(currentZ/16))-1) then
		toDo = "increaseX"
		print(2)
	elseif (currentX >= 0 and currentZ >= 0 and math.floor(currentX/16) == math.floor(currentZ/16)) then
		toDo = "decreaseZ"
		print(3)
	elseif (currentX >= 0 and currentZ <= 0 and math.floor(currentX/16) == math.floor(-currentZ/16)) then
		toDo = "decreaseX"
		print(4)

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
	print(nextX, nextZ)
	print(nextX+file.get(1), nextZ+file.get(3))
	file.store(31, nextX+file.get(1))
	file.store(32, nextZ+file.get(3))
end
rednet.open("top")

--For Testing
fs.delete("/data.txt")
if fs.exists("/data.txt") == false then
--Create the Data.txt file and fill items
	fs.copy("/rom/global files/dataTemplate.txt","/data.txt")
end

file.store(33,-322)
file.store(1, file.get(33))
file.store(31, file.get(33))
file.store(34,-305)
file.store(3, file.get(34))
file.store(32, file.get(34))


while false do
	local init = rednet.receive()
	if init == true then
		local message = select(2, rednet.receive())
		file.store(1, message)
		local message = select(2, rednet.receive())
		file.store(3, message)
	end
end

--Initialization to prevent double quarrying the starting chunks
for i = 1, 3 do
nextChunk()
end

while true do
	print(1)
	local message = select(2, rednet.receive())
	print(2)
  if message == true then
		print("Yeah")
    nextChunk()
    --Transfer the data of which chunk to quarry next
    rednet.broadcast(file.get(31))
    os.sleep(1)
    rednet.broadcast(file.get(32))
  end

end

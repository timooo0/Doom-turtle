self = require("self")
buildTreeFarm = require("buildTreeFarm")
startBase = require("startBase")
newTreeFarm = require("newTreeFarm")
chunkMap = require("chunkMap")
-- chestArray = require("chestArray")
os.loadAPI("/rom/apis/gps.lua")

for i=1,4 do
  for j=1,3 do
    print(i,j)
    if j == 2 then
      break
    end
  end
end

function nextChunk()
	--End of spiral - center of spiral
	currentX = file.get(31)-file.get(1)
	currentZ = file.get(32)-file.get(3)
	nextX = currentX
	nextZ = currentZ

	if (currentX <= 0 and currentZ >= 0 and math.floor(-currentX/2) == math.floor(currentZ/2)) then
		toDo = "increaseX"
	elseif (currentX >= 0 and currentZ >= 0 and math.floor(currentX/2)-1 == math.floor(currentZ/2)) then
		toDo = "decreaseZ"
	elseif (currentX >= 0 and currentZ <= 0 and math.floor(currentX/2) == math.floor(-currentZ/2)) then
		toDo = "decreaseX"
	elseif (currentX <= 0 and currentZ <= 0 and math.floor(currentX/2) == math.floor(currentZ/2)) then
		toDo = "increaseZ"
	end
	if toDo == "increaseX" then
		nextX = currentX + 2
	elseif toDo == "decreaseZ" then
		nextZ = currentZ - 2
	elseif toDo == "decreaseX" then
		nextX = currentX - 2
	elseif toDo == "increaseZ" then
		nextZ = currentZ + 2
	end

	file.store(31, nextX)
	file.store(32, nextZ)

end

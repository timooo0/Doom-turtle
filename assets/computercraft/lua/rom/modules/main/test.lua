self = require("self")
os.loadAPI("/rom/apisFiles/item.lua")
os.loadAPI("/rom/apisFiles/gps.lua")
os.loadAPI("/rom/apisFiles/file.lua")
os.loadAPI("/rom/apisFiles/recipe.lua")


item.selectItem("minecraft:coal")
turtle.refuel()
gps.faceLeft()
item.selectItem("computercraft:peripheral")
gps.breakFront()
turtle.place()
item.selectItem("computercraft:disk_expanded")
turtle.drop()
fs.copy("/rom/programs/startup.lua", "disk/startup.lua")
fs.copy("/rom/programs/startup.lua", "startup.lua")
gps.moveUp()
item.selectItem("computercraft:turtle_expanded")
turtle.place()







turtle.refuel()
write("x position: ")
local xPos = read()
file.store(1,xPos)
write("y position: ")
local yPos = read()
file.store(2,yPos)
write("z position: ")
local zPos = read()
file.store(3,zPos)
write("facing in direction:  ")
local face = read()
file.store(4,face)
item.resetItemCounts()
item.boodschappen("computercraft:turtle_expanded", 1)
gps.moveHighWay(file.get(1)+32,132,file.get(3)+16)
gps.moveChunk(0,1)
gps.face(3)
read()
turtle.refuel()

write("x position: ")
local xPos = read()
file.store(1,xPos)
write("y position: ")
local yPos = read()
file.store(2,yPos)
write("z position: ")
local zPos = read()
file.store(3,zPos)
write("facing in direction:  ")
local face = read()
file.store(4,face)

gps.moveChunk(0,15)
read()

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

local turtleFactory = {}

function turtleFactory.Function()
turtle.refuel()
quarry = require("quarry")
os.loadAPI("/rom/apisFiles/item.lua")
os.loadAPI("/rom/apisFiles/gps.lua")
os.loadAPI("/rom/apisFiles/file.lua")
os.loadAPI("/rom/apisFiles/recipe.lua")


fs.delete("/items.txt")
if fs.exists("/items.txt") == false then
--Create the Data.txt file and fill items
	fs.copy("/rom/global files/itemsTemplate.txt","/items.txt")
end

fs.delete("/map.txt")
if fs.exists("/map.txt") == false then
	fs.copy("/rom/global files/mapTemplate.txt","/map.txt")
end

xCenter = file.get(1)
zCenter = file.get(3)

for i = 1, 2000 do
	currentX = file.get(1)-xCenter
	currentZ = file.get(3)-zCenter
	nextX = currentX
	nextZ = currentZ

	--print(nextX, nextZ)
	if false then
		print("hi")
		if (currentX <= currentZ and currentZ > 0) or (currentX <= 0 and currentZ >= 0 and -math.floor(currentX/2) == math.floor(currentZ/2)) then
			nextX = currentX + 2
			print("1")
		elseif (currentX > currentZ  and currentX > 0 and math.floor(currentX/2) ~= math.floor(-currentZ/2)) or (currentX >= 0 and currentZ >= 0 and math.floor(currentX/2) == math.floor(currentZ/2))then
			nextZ = currentZ - 2
			print("2")
		elseif (currentX > currentZ and currentZ < 0) or (currentX >= 0 and currentZ <= 0 and math.floor(currentX/2) == -math.floor(currentZ/2)) then
			nextX = currentX - 2
			print("3")
		elseif (currentX < currentZ and currentX < 0) or (currentX <= 0 and currentZ <= 0 and math.floor(currentX/2) == math.floor(currentZ/2)) then
			nextZ = currentZ + 2
			print("4")
		end
	end
	print(currentX,currentZ)
	if (currentX <= 0 and currentZ >= 0 and math.floor(-currentX/2) == math.floor(currentZ/2)) then
		toDo = "increaseX"
	elseif (currentX >= 0 and currentZ >= 0 and math.floor(currentX/2)-1 == math.floor(currentZ/2)) then
		toDo = "decreaseZ"
	elseif (currentX >= 0 and currentZ <= 0 and math.floor(currentX/2) == math.floor(-currentZ/2)) then
		toDo = "decreaseX"
	elseif (currentX <= 0 and currentZ <= 0 and math.floor(currentX/2) == math.floor(currentZ/2)) then
		toDo = "increaseZ"
	end
	print(toDo)
	if toDo == "increaseX" then
		nextX = currentX + 2
	elseif toDo == "decreaseZ" then
		nextZ = currentZ - 2
	elseif toDo == "decreaseX" then
		nextX = currentX - 2
	elseif toDo == "increaseZ" then
		nextZ = currentZ + 2
	end

	--print(nextX, nextZ)
	gps.moveAbs(nextX+xCenter, file.get(2), nextZ+zCenter)
end





read()



file.mapWrite(64,64,"VALUE")
print(file.mapRead(64,64))
print(file.mapRead(16,16))
read()
gps.moveBack()
gps.faceRight()
for i = 1,16 do
	turtle.suck()
end
item.InvenToItemDict()
for i = 1,16 do
	turtle.select(i)
	turtle.drop()
end

gps.faceRight()
for i = 1,16 do
	turtle.suck()
end
item.InvenToItemDict()
for i = 1,16 do
	turtle.select(i)
	turtle.drop()
end
print("done")

turtle.select(1)
item.getFromChest("minecraft:coal",64)



components = true
--Craft a Mining Turtle
item.craftItemBranch("computercraft:turtle_expanded", 1)
item.craftItemBranch("minecraft:diamond_pickaxe", 1)
--checkcomponents
gps.faceLeft()

item.getFromChest("computercraft:turtle_expanded", 1)
if turtle.getItemCount(16) < 1 then
	components = false
end
turtle.select(16)
turtle.drop()
item.getFromChest("minecraft:diamond_pickaxe", 1)
if turtle.getItemCount(16) < 1 then
	components = false
end
turtle.select(16)
turtle.drop()



if components == true then
	item.craftItem(recipe.miningTurtle)
	turtle.drop()
	print("I made a mining turtle")
else
	mustQuarry = true
end

if mustQuarry == true then
	print("Init")
	x = file.get(1)
	y = file.get(2)
	z = file.get(3)
	facing = file.get(4)

	--The Quarry Size
	file.store(9, 47)
	--file.store(10, 16)
	file.store(11, file.get(6)-3)

	-- Initialization
	--file.store(12, 0)
	file.store(13, 0)

	--Restart Resistance
	file.store(14, "Quarry")
	--Initialization
	file.store(15, 1)
	file.store(16, "false")
	file.store(18, "false")

	--
	for i = 1,16 do
		turtle.suck()
	end
	gps.faceRight()
	for i = 1,16 do
		turtle.select(i)
		turtle.drop()
	end
	gps.faceLeft()
	gps.breakFront()
	gps.faceLeft()

	--Move around the modem
	gps.move()
	gps.faceRight()
	gps.move()
	gps.faceLeft()
	gps.move(2)
	gps.faceLeft()
	gps.move()
	gps.faceRight()

	gps.move(44)




	quarry.Function()
end





--Too close the function
end
return turtleFactory

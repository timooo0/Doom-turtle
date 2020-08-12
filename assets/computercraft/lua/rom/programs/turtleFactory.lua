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
file.store(31, file.get(1))
file.store(32, file.get(3))

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
gps.faceAround()
gps.move()

for i = 1,16 do
	gps.moveBack()
	gps.faceAround()
	--Make a turtle (maybe)
	components = true
	--Craft a Mining Turtle
	item.craftItemBranch("computercraft:turtle_expanded", 1)
	item.craftItemBranch("minecraft:diamond_pickaxe", 1)
	item.craftItemBranch("minecraft:chest", 1)
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
		print("I made a mining turtle")

		item.getFromChest("minecraft:chest", 1)

		gps.faceRight()
		item.getFromChest("minecraft:coal", 16)
		gps.faceAround()

		gps.move(2)
		item.selectItem("computercraft:turtle_expanded")
		turtle.place()

		item.dumpItem("minecraft:coal", 16)
		item.storeItemDict("minecraft:coal", -16)
		item.dumpItem("minecraft:chest", 1)
		item.storeItemDict("minecraft:chest", -1)


		gps.moveBack(1)
		item.selectItem("computercraft:wired_modem_full")
		turtle.place()


	else
		mustWait = true
		print("I am waiting")
		os.sleep(10000)
	end



	file.checkShutdown()
	restartIndex = file.get(17)
	--give the new turtle the current coordiantes via rednet
	os.sleep(200)
	rednet.open("front")

	if file.get(4) == 0 or file.get(4) == 2 then
		rednet.broadcast(file.get(1))
		os.sleep(1)
		rednet.broadcast(file.get(2))
		os.sleep(1)

		if file.get(4) == 0 then
			rednet.broadcast(file.get(3)-2)
			rednet.broadcast(file.get(4))

		else
			rednet.broadcast(file.get(3)+2)
			rednet.broadcast(file.get(4))

		end
	end

	if file.get(4) == 1 or file.get(4) == 3 then

		if file.get(4) == 1 then
			rednet.broadcast(file.get(1)+2)
			rednet.broadcast(file.get(2))
			rednet.broadcast(file.get(3))
			rednet.broadcast(file.get(4))

		else
			rednet.broadcast(file.get(1)-2)
			rednet.broadcast(file.get(2))
			rednet.broadcast(file.get(3))
			rednet.broadcast(file.get(4))

		end
	end

	os.sleep(1)
	rednet.broadcast("quarrySlave")

	nextChunk()
	os.sleep(1)
	rednet.broadcast(file.get(31))
	os.sleep(1)
	rednet.broadcast(file.get(32))

	file.store(17,restartIndex+1)
end



--Too close the function
end
return turtleFactory

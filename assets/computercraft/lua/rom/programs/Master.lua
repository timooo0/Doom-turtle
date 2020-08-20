
quarry = require("quarry")
startBase = require("startBase")
buildTreeFarm = require("buildTreeFarm")
newTreeFarm = require("newTreeFarm")
turtleFactory = require("turtleFactory")
quarrySlave = require("quarrySlave")
chestArray = require("chestArray")

os.loadAPI("/rom/apisFiles/item.lua")
os.loadAPI("/rom/apisFiles/file.lua")
--Initialization

--Set true when testing with non ID=0 turtles
local test = true
if test == false then
	id = os.getComputerID()
else
	id = 177
	--id = 0
end
fs.delete("/data.txt")
if fs.exists("/data.txt") == false then
--Create the Data.txt file and fill items
	fs.copy("/rom/global files/dataTemplate.txt","/data.txt")
	if os.getComputerID() == id then
		--file.store(14, "turtleFactory")
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

		--For some Testing
		--file.store(14, "turtleFactory")
		--turtle.refuel()
		--file.store(14, "buildTreeFarm")

		file.store(14, "startBase")
		file.store(17, 16)

		--file.store(14,"chestArray")
	end
end

--For some Testing
--item.selectItem("minecraft:coal")
--turtle.transferTo(1)
--turtle.select(1)
--turtle.refuel(turtle.getItemCount(1)-1)
--file.store(14, "quarrySlave")
file.checkShutdown()
if file.get(14) == "Start" then
	if os.getComputerID()	 == id then

		--Create the "items.txt" file:
		if fs.exists("/items.txt") == false then
			fs.copy("/rom/global files/itemsTemplate.txt","/items.txt")
		end

		if fs.exists("/map.txt") == false then
			fs.copy("/rom/global files/mapTemplate.txt","/map.txt")
		end

		--Process from start
		require("StartTree")

		--Restart Resistance
		file.store(14, "Quarry")
		file.store(26, "false")

	else
		item.selectItem("minecraft:coal")
		turtle.refuel(turtle.getItemCount()-1)
		turtle.transferTo(1)
		turtle.select(1)


		if turtle.forward() == true then
			turtle.back()
		else
			turtle.turnLeft()
			turtle.turnLeft()
		end
		print("hi")

		rednet.open("back")
		for i=1,4 do
			local message = select(2,rednet.receive())
			print(message)
			file.store(i,message)
		end
		local message = select(2,rednet.receive())
		print(message)
		file.store(14,message)



		--Extra data transfer for the quarrySlave
		if message == "quarrySlave" then
			local message = select(2, rednet.receive())
			file.store(31, message)

			local message = select(2, rednet.receive())
			file.store(32, message)

			local message = select(2, rednet.receive())
			file.store(33, message)

			local message = select(2, rednet.receive())
			file.store(34, message)
		end

	end
end


file.checkShutdown()
--Quarry
if file.get(14) == "Quarry" then
	--For testing
	fs.delete("/items.txt")

	if fs.exists("/items.txt") == false then
	--Create the Data.txt file and fill items
		fs.copy("/rom/global files/itemsTemplate.txt","/items.txt")
	end

	print("Init")
	x = file.get(1)
	y = file.get(2)
	z = file.get(3)
	facing = file.get(4)
	--The starting Coordinates
	file.store(5, x)
	file.store(6, y)
	file.store(7, z)
	file.store(8, facing)
	--The Quarry Size
	file.store(9, 32)
	file.store(10, 32)
	file.store(11, file.get(6)-3)
	-- Initialization
	--file.store(12, 0)
	file.store(13, 0)
	--Initialization
	file.store(15, 0)
	file.store(16, "false")
	file.store(18, "false")

	while file.get(16) ~= "true" or file.get(18) ~= "true" do


		enoughItems = file.get(16)
		enoughSand = file.get(18)
		print(enoughItems)
		if enoughItems == "false" then
			print('hoi')
			--biggerQuarry = file.get(15)
			--16 is for 1 chunk size
			--file.store(10, 1*biggerQuarry)
			--file.store(12, 1*(biggerQuarry-1))

			quarry.Function()

			--biggerQuarry = file.get(15)
			--biggerQuarry = biggerQuarry+1
			--file.store(15, biggerQuarry)
		elseif enoughSand == "false" and enoughItems == "true" then
			--biggerQuarry = file.get(15)
			--16 is for 1 chunk size
			--file.store(10, 1*biggerQuarry)
			--file.store(12, 1*(biggerQuarry-1))
			file.store(11, file.get(6)-53)
			quarry.Function()

			--biggerQuarry = file.get(15)
			--biggerQuarry = biggerQuarry+3
			--file.store(15, biggerQuarry)

		else
			file.store(14, "startBase")
		end

		--Restart Resistance

		--Checks wether we have enough to build turtle
			enoughItems = "true"
			enoughSand = "true"

			if item.getItemDict("minecraft:iron_ore") < 7 or item.getItemDict("minecraft:redstone") < 2 or item.getItemDict("minecraft:cobblestone") < 23 or item.getItemDict("minecraft:dirt,0") < 88 or item.getItemDict("minecraft:diamond") < 3 then
				enoughItems = "false"
			end
			if item.getItemDict("minecraft:sand") < 6 then
				enoughSand = "false"
				file.store(18, enoughSand)
			end

			file.store(16, enoughItems)
			file.store(18, enoughSand)
			file.store(14, "Quarry")

	end
	file.store(14, "startBase")
end

file.checkShutdown()
if file.get(14) == "startBase" then
--Tree Farm
	--For Testing

	x = file.get(1)
	y = file.get(2)
	z = file.get(3)
	facing = file.get(4)
	--The starting Coordinates
	file.store(5, x)
	file.store(6, y)
	file.store(7, z)
	file.store(8, facing)

	--For Testing
	item.selectItem("minecraft:coal")
	turtle.transferTo(1)
	turtle.select(1)
	turtle.refuel(turtle.getItemCount(1)-1)

	startBase.Function()

	--Update our resource counts
	--item.storeItemDict("minecraft:iron_ore", -7)
	--item.storeItemDict("minecraft:redstone", -2)
	--item.storeItemDict("minecraft:cobblestone", -23)
	--item.storeItemDict("minecraft:dirt,0", -88)
	--item.storeItemDict("minecraft:diamond", -3)
	--Damage is 1 because Spruce tree, pls start with spruce tree
	--item.storeItemDict("minecraft:planks,1", -26)

	file.store(14, "turtleFactory")
end

if file.get(14) == "turtleFactory" then
--Quarry and Make more turtles.
	turtleFactory.Function()
end

if file.get(14) == "quarrySlave" then
	--Quarry a Chunk
	quarrySlave.Function()
end

file.checkShutdown()
if file.get(14) == "buildTreeFarm" then
--Build Tree Farm
	buildTreeFarm.Function()
	file.store(14,"farmTree")
end

file.checkShutdown()
if file.get(14) == "farmTree" then
--Run the tree farm
	newTreeFarm.Function()
end

file.checkShutdown()
if file.get(14) == "chestArray" then
--Run the chestArray
		--Make sure there is no coal in the first slot, and move the chests there
		turtle.select(1)
		turtle.refuel()
		item.selectItem("minecraft:chest")
		turtle.transferTo(1)

		chestArray.Function()
end

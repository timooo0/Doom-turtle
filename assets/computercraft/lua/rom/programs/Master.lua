
quarry = require("quarry")
startBase = require("startBase")
buildTreeFarm = require("buildTreeFarm")
newTreeFarm = require("newTreeFarm")

os.loadAPI("/rom/apis/item.lua")
os.loadAPI("/rom/apis/file.lua")
--Initialization
--Set true when testing with non ID=0 turtles
local test = false
if test == true then
	id = os.getComputerID() 
else
	id = 0
end

if fs.exists("/data.txt") == false then
--Create the Data.txt file and fill items
	fs.copy("/rom/global files/dataTemplate.txt","/data.txt")
	if os.getComputerID() == id then
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
	end
end

if fs.exists("/items.txt") == false then
	fs.copy("/rom/global files/itemsTemplate.txt","/items.txt")
end


file.checkShutdown()
if file.get(14) == "Start" then
	if os.getComputerID()	 == id then
		--Process from start
		require("StartTree")
	
		--Restart Resistance
		file.store(14, "QuarryInitialization")
		file.store(26, "false")
		
	else
		item.selectItem("minecraft:coal")
		turtle.refuel()
		
		if turtle.forward() == true then
			turtle.back()
		else
			turtle.turnLeft()
			turtle.turnLeft()
		end
		
		rednet.open("back")
		for i=1,4 do
			local message = select(2,rednet.receive())
			print(message)
			file.store(i,message)
		end
		local message = select(2,rednet.receive())
		print(message)
		file.store(14,message)
		

		
	end
end	

--Quarry
file.checkShutdown()
if file.get(14) == "QuarryInitialization" then
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
		
		file.store(20, 0)
		file.store(21, 0)
		file.store(22, 0)
		file.store(23, 0)
end

file.checkShutdown()
if file.get(14) == "Quarry" then
	while file.get(16) ~= "true" or file.get(18) ~= "true" do
	

		enoughItems = file.get(16)
		enoughSand = file.get(18)
		print(enoughItems)
		if enoughItems == "false" then
			print('hoi')
			biggerQuarry = file.get(15)
			--16 is for 1 chunk size
			file.store(10, 1*biggerQuarry)
			file.store(12, 1*(biggerQuarry-1))

			quarry.Function()
			
			biggerQuarry = file.get(15)
			biggerQuarry = biggerQuarry+1
			file.store(15, biggerQuarry)
		elseif enoughSand == "false" and enoughItems == "true" then
			biggerQuarry = file.get(15)
			--16 is for 1 chunk size
			file.store(10, 1*biggerQuarry)
			file.store(12, 1*(biggerQuarry-1))
			file.store(11, file.get(6)-53)
			print("noyes")
			quarry.Function()
			
			biggerQuarry = file.get(15)
			biggerQuarry = biggerQuarry+3
			file.store(15, biggerQuarry)
			
		else
			file.store(14, "startBase")
		end
		
		--Restart Resistance

		--Checks wether we have enough to build turtle
			enoughItems = "true"
			enoughSand = "true"

			if file.get(20) < 7 or file.get(21) < 2 or file.get(23) < 23 or file.get(25) < 88 or file.get(30) < 3 then
				enoughItems = "false"
			end
			if file.get(22) < 6 then
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

	startBase.Function()
	--Update our resource counts
	file.store(20, file.get(20)-7)
	file.store(21, file.get(21)-2)
	file.store(23, file.get(23)-23)
	file.store(25, file.get(25)-88)
	file.store(30, file.get(30)-3)
	
	file.store(14, "turtleFactory")
end

if file.get(14) == "turtleFactory" then
--Quarry and Make more turtles.
end

file.checkShutdown()
if file.get(14) == "buildTreeFarm" then
--Tree Farm
	buildTreeFarm.Function()
	file.store(14,"farmTree")
end

file.checkShutdown()
if file.get(14) == "farmTree" then
--Run the tree farm
	newTreeFarm.Function()
end


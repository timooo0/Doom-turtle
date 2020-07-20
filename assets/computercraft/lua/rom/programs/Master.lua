self = require("self")
quarry = require("quarry")
startBase = require("startBase")
buildTreeFarm = require("buildTreeFarm")
newTreeFarm = require("newTreeFarm")
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
		self.store(1,xPos)
		write("y position: ")
		local yPos = read()
		self.store(2,yPos)
		write("z position: ")
		local zPos = read()
		self.store(3,zPos)
		write("facing in direction:  ")
		local face = read()
		self.store(4,face)
	end
end




self.checkShutdown()
if self.get(14) == "Start" then
	if os.getComputerID()	 == id then
		--Process from start
		require("StartTree")
	
		--Restart Resistance
		self.store(14, "QuarryInitialization")
		self.store(26, "false")
		
	else
		self.selectItem("minecraft:coal")
		turtle.refuel()
		rednet.open("back")
		for i=1,4 do
			local message = select(2,rednet.receive())
			print(message)
			self.store(i,message)
		end
		local message = select(2,rednet.receive())
		print(message)
		self.store(14,message)
	end
end	

--Quarry
self.checkShutdown()
if self.get(14) == "QuarryInitialization" then
		print("Init")
		x = self.get(1)
		y = self.get(2)
		z = self.get(3)
		facing = tonumber(self.get(4))
	--The starting Coordinates
		self.store(5, x)
		self.store(6, y)
		self.store(7, z)
		self.store(8, facing)

	--The Quarry Size
		self.store(9, 47)
		--self.store(10, 16)
		self.store(11, self.get(6)-3)

	-- Initialization
		--self.store(12, 0)
		self.store(13, 0)


	
	--Restart Resistance
		self.store(14, "Quarry")
		--Initialization
		self.store(15, 1)
		self.store(16, "false")
		
		self.store(18, "false")
		
		self.store(20, 0)
		self.store(21, 0)
		self.store(22, 0)
		self.store(23, 0)
end

self.checkShutdown()
if self.get(14) == "Quarry" then
	while self.get(16) ~= "true" or self.get(18) ~= "true" do
	

		enoughItems = self.get(16)
		enoughSand = self.get(18)
		print(enoughItems)
		if enoughItems == "false" then
			print('hoi')
			biggerQuarry = tonumber(self.get(15))
			--16 is for 1 chunk size
			self.store(10, 1*biggerQuarry)
			self.store(12, 1*(biggerQuarry-1))

			quarry.Function()
			
			biggerQuarry = tonumber(self.get(15))
			biggerQuarry = biggerQuarry+1
			self.store(15, biggerQuarry)
		elseif enoughSand == "false" and enoughItems == "true" then
			biggerQuarry = tonumber(self.get(15))
			--16 is for 1 chunk size
			self.store(10, 1*biggerQuarry)
			self.store(12, 1*(biggerQuarry-1))
			self.store(11, self.get(6)-53)
			print("noyes")
			quarry.Function()
			
			biggerQuarry = tonumber(self.get(15))
			biggerQuarry = biggerQuarry+3
			self.store(15, biggerQuarry)
			
		else
			self.store(14, "startBase")
		end
		
		--Restart Resistance

		--Checks wether we have enough to build turtle
			enoughItems = "true"
			enoughSand = "true"

			if self.get(20) < 7 or self.get(21) < 2 or self.get(23) < 23 or self.get(30) < 3 then
				enoughItems = "false"
			end
			if tonumber(self.get(22)) < 6 then
				enoughSand = "false"
				self.store(18, enoughSand)
			end
			
			self.store(16, enoughItems)
			self.store(18, enoughSand)
			self.store(14, "Quarry")
			
	end
	self.store(14, "startBase")
end

self.checkShutdown()
if self.get(14) == "startBase" then
--Tree Farm

	startBase.Function()
	self.store(14, "turtleFactory")
end

if self.get(14) == "turtleFactory" then
--Quarry and Make more turtles.
end

self.checkShutdown()
if self.get(14) == "buildTreeFarm" then
--Tree Farm
	buildTreeFarm.Function()
	self.store(14,"farmTree")
end

self.checkShutdown()
if self.get(14) == "farmTree" then
--Run the tree farm
	newTreeFarm.Function()
end


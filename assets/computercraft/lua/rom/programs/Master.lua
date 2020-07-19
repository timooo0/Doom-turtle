self = require("self")

--Initialization
if fs.exists("/Data.txt") == false then
--Create the Data.txt file and fill items
	fs.copy("/rom/global files/dataTemplate.txt","/Data.txt")
	if os.getComputerID() == 0 then
		write("x position: ")
		local xPos = read()
		self.store(1,xPos)
		write("y position: ")
		local yPos = read()
		self.store(2,xPos)
		write("z position: ")
		local xPos = read()
		self.store(3,xPos)
		write("facing in direction:  ")
		local xPos = read()
		self.store(4,xPos)
	end
end


self.checkShutdown()
if self.get(14) == "Start" then
	if os.getComputerID()	 == 0 then
		--Process from start
		shell.run("StartTree")
	
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
		x = tonumber(self.get(1))
		y = tonumber(self.get(2))
		z = tonumber(self.get(3))
		facing = tonumber(self.get(4))
	--The starting Coordinates
		self.store(5, x)
		self.store(6, y)
		self.store(7, z)
		self.store(8, facing)

	--The Quarry Size
		self.store(9, 31)
		--self.store(10, 16)
		self.store(11, 60)

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

	
	
	enoughItems = self.get(16)
	enoughSand = self.get(18)
	print(enoughItems)
	if enoughItems == "false" then
		print('hoi')
		biggerQuarry = tonumber(self.get(15))
		--16 is for 1 chunk size
		self.store(10, 1*biggerQuarry)
		self.store(12, 1*(biggerQuarry-1))

		shell.run("Quarry")
	elseif enoughSand == "false" and enoughItems == "true" then
		biggerQuarry = tonumber(self.get(15))
		--16 is for 1 chunk size
		self.store(10, 1*biggerQuarry)
		self.store(12, 1*(biggerQuarry-1))
		self.store(11, 12)
		
		shell.run("Quarry")
	else
		self.store(14, "startBase")
	end
end
self.checkShutdown()
if self.get(14) == "QuarryMore" then
	--Restart Resistance
		biggerQuarry = tonumber(self.get(15))
		biggerQuarry = biggerQuarry+1
		self.store(15, biggerQuarry)
	--Checks wether we have enough to build turtle
		enoughItems = "true"
		enoughSand = "true"

		if tonumber(self.get(20)) < 7 or tonumber(self.get(21)) < 1 or tonumber(self.get(23)) < 15 then
			enoughItems = "false"
		end
		if tonumber(self.get(22)) < 6 then
			enoughSand = "false"
			self.store(18, enoughSand)
		end
		
		self.store(16, enoughItems)
		self.store(18, enoughSand)
		self.store(14, "Quarry")
		shell.run("Master")
		
end

self.checkShutdown()
if self.get(14) == "startBase" then
--Tree Farm
	self.store(17, 0)
	shell.run("startBase")
end

self.checkShutdown()
if self.get(14) == "buildTreeFarm" then
--Tree Farm
	shell.run("buildTreeFarm")
end

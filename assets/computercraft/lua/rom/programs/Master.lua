self = require("self")

--Initialization

if fs.exists("/Data.txt") == false then
--Create the Data.txt file and fill items
	fs.copy("/rom/programs/dataTemplate.txt","/Data.txt")
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


if self.get(14) == "Start" then
--Process from start
	shell.run("StartTree")
	
--Restart Resistance
	self.store(14, "QuarryInitialization")
	
end	
--Quarry

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
		self.store(9, 3)
		self.store(10, 16)
		self.store(11, 6)

	-- Initialization
		self.store(12, 0)
		self.store(13, 0)


	
--Restart Resistance
	self.store(14, "Quarry")
	--Initialization
	self.store(15, 1)
	self.store(16, 0)
end
if self.get(14) == "Quarry" then
	--Checks wether we have enough to build turtle
	enoughItems = tonumber(self.get(16))
	print(enoughItems)
	if enoughItems == 0 then
		print('hoi')
		biggerQuarry = tonumber(self.get(15))
		self.store(10, 16*biggerQuarry)
		self.store(12, 16*(biggerQuarry-1))
		shell.run("Quarry")
		biggerQuarry = biggerQuarry+1
		self.store(15, biggerQuarry)
		--Check enough items
		if false then
			enoughItems = true
			self.store(16, true)
		end
	end
	
	--Check wether collected everything necessary
	
	
	--Restart Resistance
	self.store(14, "TreeFarm")
end

if self.get(14) == "TreeFarm" then
--Tree Farm
	print("TreeFarmStarting")
	
	
end


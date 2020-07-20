--Quarry
local quarry = {}

function quarry.Function()
--Initializes "self" functions
self = require("self")
print("Quarry")
--Loads the parameters from "data.txt":

	--Current Coordinates
	x = tonumber(self.get(1))
	y = tonumber(self.get(2))
	z = tonumber(self.get(3))
	facing = tonumber(self.get(4))

	--The starting Coordinates
	xStart = tonumber(self.get(5))
	yStart = tonumber(self.get(6))
	zStart = tonumber(self.get(7))
	facingStart = tonumber(self.get(8))

	--The Quarry Size
	local lengthquarry = tonumber(self.get(9))-1
	local widthquarry = tonumber(self.get(10))
	local depthquarry = tonumber(self.get(11))

	--Where it left off:
	local layerwidth =  tonumber(self.get(12))
	local layerdepth =  tonumber(self.get(13))

--Functions:

	--Drop items in the chest in front of it (needs to be trapped or regular)
	function itemdelivery()								
		bool,data=turtle.inspect()
		if data.name == "minecraft:chest" or data.name == "minecraft:trapped_chest" then
			for inventoryslot = 2,16 do
				turtle.select(inventoryslot)
				os.sleep(2/20)
				turtle.drop()
			end
		else
			print("No Chest to drop off my items")
		end
	end

	--Refuel
	function fuel()								
		if turtle.getFuelLevel() < 160 and turtle.getItemCount(1) > 2 then
			turtle.select(1)
			turtle.refuel(2)
			print("fueling")
		end
	end

	--Dump all non-needed items
	function dumpitems()
		for i = 2, 16 do
			turtle.select(i)
			if turtle.getItemCount() ~= 0 then
				if turtle.getItemDetail().name ~= "minecraft:iron_ore" and turtle.getItemDetail().name ~= "minecraft:redstone" and turtle.getItemDetail().name ~= "minecraft:sand" and turtle.getItemDetail().name ~= "minecraft:cobblestone" and turtle.getItemDetail().name ~= "minecraft:diamond" and turtle.getItemDetail().name ~= "minecraft:dirt" then
					turtle.drop()
				end
			end
		end
	end

	function dumpExcess(name, need, dataLine)
		count = self.countItems(name)
		get = tonumber(self.get(tonumber(dataLine)))
		self.dumpItem(name, count-tonumber(need)+get)
		self.store(dataLine, self.countItems(name)+get)
	end

fuel()

--Moving back to where it left off
	--Y
		for yreturn = 1, yStart-y do
			self.moveup()
		end
	--X
		while facing ~= 1 do
			self.faceLeft()
		end
		if xStart > x then
			for xreturn = 1, xStart-x do
				self.move()
			end
		elseif xStart < x then
			self.faceAround()
			for xreturn = 1, x-xStart do
				self.move()
			end

		end
	--Z
		while facing ~= 0 do
			self.faceLeft()
		end
		if zStart > z then
			self.faceAround()
			for zreturn = 1, zStart-z do
				self.move()
			end
		elseif zStart < z then
			for zreturn = 1, z-zStart do
				self.move()
			end
		end

--Faces the chest
	while facing ~= facingStart do
		self.faceLeft()
	end

fuel()
--The loop for the width of the quarry
while layerwidth < widthquarry do

	--The loop for the depth of the quarry
	while layerdepth < math.floor(depthquarry/6)*6 do
		self.checkShutdown()
		
		self.faceLeft()
		--Moves back by the number of layerswidth already quarried
		for width = 1, layerwidth do
			self.move()
		end
		self.faceLeft()
	
		--Moves down a layerdepth number of layers to continue/start from
		for depth = 1, layerdepth do
			fuel()
			self.movedown()
		end
		--Moves along the length of the quarry
		for length = 1, lengthquarry do
			fuel()
			--Breaks the block up and down, then moves forward, and repeats
			self.breakdown()
			self.breakup()
			self.move()
		end
		
		--Breaks the block above the turtle at the end of the length
		self.breakup()
		
		--Moves down 1 layer (3 thick)
		for depth = 1, 3 do 
			fuel()
			self.movedown()
		end
		--Turn around
		self.faceAround()

		--Moves along the length of the quarry (in the opposite direciton)
		for length = 1, lengthquarry do
			fuel()
			--Breaks the block up and down, then moves forward, and repeats
			self.breakdown()
			self.breakup()
			self.move()
		end

		--Breaks the block below the turtle at the end of the length
		self.breakdown()
		
		--Moves up 1 layer (3 thick)
		for depth = 1, 3 do 
			fuel()
			self.moveup()
		end
		--Moves up by the layerdepth that is already quarried
		for depth = 1, layerdepth do
			fuel()
			self.moveup()
		end

		self.faceRight()
		--Moves back by the number of layerswidth already quarried
		for width = 1, layerwidth do
			self.move()
		end
		
		
		--Dump all non-needed items
		dumpitems()
		--Dump all excess-needed items
		dumpExcess("minecraft:iron_ore", 7, 20)
		dumpExcess("minecraft:redstone", 1, 21)
		dumpExcess("minecraft:sand", 6, 22)
		dumpExcess("minecraft:cobblestone", 15, 23)
		dumpExcess("minecraft:dirt", 80, 25)
		dumpExcess("minecraft:diamond", 3, 30)
		
		
		self.faceLeft()
		--Puts the Items in the chest
		itemdelivery()

		--Update the layerdepth
		layerdepth = layerdepth + 6
		self.store(13, layerdepth)
	end

	--Update the layerwidth
	layerwidth = layerwidth + 1
	self.store(12, layerwidth)
	--Update the layerdepth
	layerdepth = 0
	self.store(13, 0)
	
end

--Back to Master
--Restart Resistance
self.store(14, "QuarryMore")

end

return quarry
--Quarry
local quarry = {}

os.loadAPI("/rom/apis/item.lua")
os.loadAPI("/rom/apis/gps.lua")
os.loadAPI("/rom/apis/file.lua")

function quarry.Function()
--Initializes "self" functions

print("Quarry")
--Loads the parameters from "data.txt":

	--Current Coordinates
	x = file.get(1)
	y = file.get(2)
	z = file.get(3)
	facing = file.get(4)

	--The starting Coordinates
	xStart = file.get(5)
	yStart = file.get(6)
	zStart = file.get(7)
	facingStart = file.get(8)

	--The Quarry Size
	local lengthquarry = file.get(9)-1
	local widthquarry = file.get(10)
	local depthquarry = file.get(11)

	--Where it left off:
	local layerwidth =  file.get(12)
	local layerdepth =  file.get(13)

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

	function dumpExcess(name, need)
		count = item.countItems(name)
		get = item.getItemDict(name)
		item.dumpItem(name, count-tonumber(need)+get)
		item.storeItemDict(name,item.countItems(name))
	end
item.storeItemDict("minecraft:iron_ore", -7)
fuel()

--Moving back to where it left off
	--Y
		for yreturn = 1, yStart-y do
			gps.moveUp()
		end
	--X
		while file.get(4) ~= 1 do
			gps.faceLeft()
		end
		if xStart > x then
			for xreturn = 1, xStart-x do
				gps.move()
			end
		elseif xStart < x then
			gps.faceAround()
			for xreturn = 1, x-xStart do
				gps.move()
			end

		end
	--Z
		while file.get(4) ~= 0 do
			gps.faceLeft()
		end
		if zStart > z then
			gps.faceAround()
			for zreturn = 1, zStart-z do
				gps.move()
			end
		elseif zStart < z then
			for zreturn = 1, z-zStart do
				gps.move()
			end
		end

--Faces the chest
print(facingStart)
	while file.get(4) ~= facingStart do
		gps.faceLeft()
	end


fuel()
--The loop for the width of the quarry
while layerwidth < widthquarry do

	--To make sure we always have coal selected
	turtle.select(1)
	--The loop for the depth of the quarry
	while layerdepth < math.floor(depthquarry/6)*6 do
		file.checkShutdown()


		gps.faceLeft()
		--Moves back by the number of layerswidth already quarried
		for width = 1, layerwidth do
			gps.move()
		end
		gps.faceLeft()

		--Moves down a layerdepth number of layers to continue/start from
		for depth = 1, layerdepth do
			fuel()
			gps.moveDown()
		end
		--Moves along the length of the quarry
		for length = 1, lengthquarry do
			fuel()
			--Breaks the block up and down, then moves forward, and repeats
			gps.breakDown()
			gps.breakUp()
			gps.move()
		end

		--Breaks the block above the turtle at the end of the length
		gps.breakUp()

		--Moves down 1 layer (3 thick)
		for depth = 1, 3 do
			fuel()
			gps.moveDown()
		end
		--Turn around
		gps.faceAround()

		--Moves along the length of the quarry (in the opposite direciton)
		for length = 1, lengthquarry do
			fuel()
			--Breaks the block up and down, then moves forward, and repeats
			gps.breakDown()
			gps.breakUp()
			gps.move()
		end

		--Breaks the block below the turtle at the end of the length
		gps.breakDown()

		--Moves up 1 layer (3 thick)
		for depth = 1, 3 do
			fuel()
			gps.moveUp()
		end
		--Moves up by the layerdepth that is already quarried
		for depth = 1, layerdepth do
			fuel()
			gps.moveUp()
		end

		gps.faceRight()
		--Moves back by the number of layerswidth already quarried
		for width = 1, layerwidth do
			gps.move()
		end


		--Dump all non-needed items
		dumpitems()
		--Dump all excess-needed items

		dumpExcess("minecraft:iron_ore", 64)
		dumpExcess("minecraft:redstone", 64)
		dumpExcess("minecraft:sand", 64)
		dumpExcess("minecraft:cobblestone", 64)
		dumpExcess("minecraft:dirt", 128)
		dumpExcess("minecraft:diamond", 64)


		gps.faceLeft()
		--Puts the Items in the chest
		itemdelivery()

		--Update the layerdepth
		layerdepth = layerdepth + 6
		file.store(13, layerdepth)
	end

	--Update the layerwidth
	layerwidth = layerwidth + 1
	file.store(12, layerwidth)
	--Update the layerdepth
	layerdepth = 0
	file.store(13, 0)

end



end

return quarry

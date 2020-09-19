--Quarry
local quarry = {}

os.loadAPI("/rom/apisFiles/item.lua")
os.loadAPI("/rom/apisFiles/gps.lua")
os.loadAPI("/rom/apisFiles/file.lua")

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
			--Make sure we have the coal slot selected
			turtle.select(1)
		else
			print("No Chest to drop off my items")
		end
	end

	function itemdeliveryUp()
		bool,data=turtle.inspectUp()
		if data.name == "minecraft:chest" or data.name == "minecraft:trapped_chest" then
			for inventoryslot = 2,16 do
				turtle.select(inventoryslot)
				os.sleep(2/20)
				turtle.dropUp()
			end
			--Make sure we have the coal slot selected
			turtle.select(1)
		else
			print("No Chest to drop off my items")
		end
	end

	--Refuel
	function fuel()
		if turtle.getFuelLevel() < 5120 and turtle.getItemCount(1) > 4 then
			turtle.select(1)
			turtle.refuel(4)
			--print("fueling")
		end
	end

	--Dump all non-needed items
	function dumpitems()
		for i = 2, 16 do
			turtle.select(i)
			if turtle.getItemCount() ~= 0 then
				if turtle.getItemDetail().name ~= "minecraft:iron_ore" and turtle.getItemDetail().name ~= "minecraft:redstone" and turtle.getItemDetail().name ~= "minecraft:dye" and turtle.getItemDetail().name ~= "minecraft:sand" and turtle.getItemDetail().name ~= "minecraft:cobblestone" and turtle.getItemDetail().name ~= "minecraft:diamond" and turtle.getItemDetail().name ~= "minecraft:dirt" and turtle.getItemDetail().name ~= "minecraft:coal" then
					turtle.drop()
				end
			end
		end
		turtle.select(1)
	end

	function dumpExcess(name, need, startSlot)
		if startSlot == nil then
			startSlot = 1
		end
		count = item.countItems(name, startSlot)
		get = item.getItemDict(name)
		item.dumpItem(name, count-tonumber(need)+get, startSlot)
		item.storeItemDict(name,item.countItems(name, startSlot))
	end

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
	numberOfDepths = math.floor(depthquarry/6)
	while layerdepth < 6*math.floor(depthquarry/6)  do
		turtle.select(1)
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
		--if layerdepth >= math.floor(depthquarry/6)*6-6*numberOfDepths then
		--	numberOfDepths = numberOfDepths - 1
		--else
		--	numberOfDepths = 5
		--end
		for i = 1, numberOfDepths do
			file.checkShutdown()

			--Moves along the length of the quarry
			gps.move()
			for length = 1, lengthquarry-1 do
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

			if numberOfDepths ~= i then
				--Moves up 1 layer (3 thick)
					gps.moveDown(3)
			end

			--Update the layerdepth
			layerdepth = layerdepth + 6
			file.store(13, layerdepth)
			gps.faceAround()
			item.dumpItem("minecraft:cobblestone", item.countItems("minecraft:cobblestone")-4)
			item.dumpItem("minecraft:dirt",item.countItems("minecraft:dirt")-4)
			item.dumpItem("minecraft:stone",item.countItems("minecraft:stone"))
			item.dumpItem("minecraft:gravel",item.countItems("minecraft:gravel"))
			turtle.select(1)
		end
		gps.faceAround()


		--Moves up by the layerdepth that is already quarried

		for depth = 1, layerdepth-3 do
			fuel()
			gps.moveUp()
		end

		gps.faceRight()
		--Moves back by the number of layerswidth already quarried
		for width = 1, layerwidth do
			gps.move()
		end

		if file.get(14) ~= "quarrySlave" then
			--Dump all non-needed items
			dumpitems()
			--Dump all excess-needed items
			dumpExcess("minecraft:iron_ore", 128)
			dumpExcess("minecraft:redstone", 64)
			dumpExcess("minecraft:sand", 64)
			dumpExcess("minecraft:cobblestone", 128)
			dumpExcess("minecraft:dirt", 128)
			dumpExcess("minecraft:diamond", 64)

			--Do a bit of trickery to properly handle the coal in the first slot ;)

			dumpExcess("minecraft:coal", 192, 2)


			dumpExcess("minecraft:dye", 64)
		end

		gps.faceLeft()
		--Puts the Items in the chest
		if file.get(14) ~= "quarrySlave" then
			itemdeliveryUp()
		else
			item.dumpItem("minecraft:cobblestone", item.countItems("minecraft:cobblestone")-4)
			item.dumpItem("minecraft:dirt",item.countItems("minecraft:dirt")-4)
			item.dumpItem("minecraft:stone",item.countItems("minecraft:stone"))
			item.dumpItem("minecraft:gravel",item.countItems("minecraft:gravel"))
			turtle.select(1)
			itemdeliveryUp()
			turtle.select(1)
			print(turtle.getFuelLevel())
		end

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

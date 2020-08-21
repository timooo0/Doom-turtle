local startBase = {}

function startBase.Function()
print("running startBase")
os.loadAPI("/rom/apisFiles/item.lua")
os.loadAPI("/rom/apisFiles/gps.lua")
os.loadAPI("/rom/apisFiles/file.lua")
os.loadAPI("/rom/apisFiles/recipe.lua")

function smelt(name,amount)
	item.getFromChest(name,amount)
	item.selectItem(name)
	gps.faceAround()
	gps.moveUp(2)
	gps.move()
	turtle.dropDown()
	gps.moveBack()
	gps.moveDown(2)
	gps.move()
	os.sleep(10*amount)
	turtle.suckUp()
	gps.faceAround()
	gps.move()
	gps.faceLeft()
	turtle.drop()
	gps.faceRight()
end


function start()
	--Added the clause testing== true for doing some tests
	if restartIndex == 0 and testing == true then
		for i=1,4 do
			file.store(i+4,file.get(i))
		end

	else
		print(file.get(5),file.get(6),file.get(7))
		gps.moveAbs(file.get(5),file.get(6),file.get(7))
		--print("move done")

		gps.face(file.get(8))
		--print("face done")
		turtle.digUp()

		gps.faceAround()
		gps.move(17)
		gps.faceRight()
		gps.move(12)
		gps.faceAround()

		file.store(5, file.get(1))
		file.store(6, file.get(2))
		file.store(7, file.get(3))

		item.selectItem("minecraft:chest")
		turtle.place()
	end

	for i=1,16 do
		turtle.select(i)
		turtle.drop()
	end
	--print("drop done")
end
print(restartIndex)
--print("start")
restartIndex = file.get(17)
if restartIndex == 0 then
	start()
end
print(restartIndex)
file.checkShutdown()
restartIndex = file.get(17)
--craft and place furnace
if restartIndex == 0 then
	--print(recipe.furnace)
	item.craftItem(recipe.furnace)

	gps.faceAround()
	gps.move()

	turtle.placeUp()

	gps.faceAround()
	gps.move()
	file.store(17,restartIndex+1)
end

file.checkShutdown()
restartIndex = file.get(17)
--put coal in the furnace
if restartIndex == 1 then
	item.getFromChest("minecraft:coal",40)

	gps.faceAround()
	gps.moveUp()

	item.selectItem("minecraft:coal")
	turtle.drop()

	gps.faceAround()
	gps.moveDown()

	file.store(17,restartIndex+1)
end

file.checkShutdown()
restartIndex = file.get(17)
--make the chest to put the crafting materials in
if restartIndex == 2 then
	item.craftItem(recipe.chest)

	gps.faceLeft()

	turtle.place()

	gps.faceRight()

	file.store(17,restartIndex+1)
end

file.checkShutdown()
restartIndex = file.get(17)
--smel the cobbel into stone
if restartIndex == 3 then
	smelt("minecraft:cobblestone",15)
	file.store(17,restartIndex+1)
end

file.checkShutdown()
restartIndex = file.get(17)
--smelt the sand into glass
if restartIndex == 4 then
	smelt("minecraft:sand",6)
	file.store(17,restartIndex+1)
end

file.checkShutdown()
restartIndex = file.get(17)
--smelt the iron ore into ingots
if restartIndex == 5 then
	smelt("minecraft:iron_ore",7)
	file.store(17,restartIndex+1)
end

file.checkShutdown()
restartIndex = file.get(17)
--put crafting materials in the crafting materials chest
if restartIndex == 6 then
	item.putInCraftingChest("minecraft:redstone",2)
	item.putInCraftingChest("minecraft:planks",18)
	item.putInCraftingChest("minecraft:diamond",3)
	file.store(17,restartIndex+1)
end

file.checkShutdown()
restartIndex = file.get(17)
--craft furnace and put in the crafting chest
if restartIndex == 7 then
	item.craftItem(recipe.furnace)

	gps.faceLeft()
	turtle.drop()

	file.store(17,restartIndex+1)
end

file.checkShutdown()
restartIndex = file.get(17)
--craft the computer
if restartIndex == 8 then
	item.craftItem(recipe.glassPane)
	turtle.drop()

	item.craftItem(recipe.computer)
	turtle.drop()
	file.store(17,restartIndex+1)
end

file.checkShutdown()
restartIndex = file.get(17)
--craft turtle + extra chest
if restartIndex == 9 then
	item.craftItem(recipe.chest,2)
	turtle.drop()

	item.craftItem(recipe.turtle)
	turtle.drop()

	file.store(17,restartIndex+1)
end

file.checkShutdown()
restartIndex = file.get(17)
--craft the mining turtle
if restartIndex == 10 then
	item.craftItem(recipe.stick)
	turtle.drop()

	item.craftItem(recipe.diamondPickaxe)
	turtle.drop()

	item.craftItem(recipe.miningTurtle)
	turtle.drop()

	file.store(17,restartIndex+1)
end

file.checkShutdown()
restartIndex = file.get(17)
--craft the modem
if restartIndex == 11 then
	print(11)
	item.craftItem(recipe.modem)
	turtle.drop()

	item.craftItem(recipe.modemBlock)
	turtle.drop()

	gps.faceLeft()
	gps.move()
	item.resetItemCounts()
	item.craftItemBranch("computercraft:disk_expanded", 1)

	item.getFromChest("minecraft:reeds")
	item.selectItem("minecraft:reeds")
	turtle.dropUp()
	item.getFromChest("minecraft:paper")
	item.selectItem("minecraft:paper")
	turtle.dropUp()

	item.craftItemBranch("computercraft:peripheral", 1)

	gps.faceLeft()

	file.store(17,restartIndex+1)
end

file.checkShutdown()
restartIndex = file.get(17)
--get all of the crafted items from the crafting chest
if restartIndex == 12 then
	item.getFromChest("computercraft:wired_modem_full",1)
	item.selectItem("computercraft:wired_modem_full")
	turtle.transferTo(16)

	item.getFromChest("computercraft:turtle_expanded",1)
	item.selectItem("computercraft:turtle_expanded")
	turtle.transferTo(15)

	item.getFromChest("minecraft:chest",1)
	item.selectItem("minecraft:chest")
	turtle.transferTo(14)

	item.getFromChest("minecraft:furnace",1)
	item.selectItem("minecraft:furnace")
	turtle.transferTo(13)

	item.getFromChest("computercraft:disk_expanded",1)
	item.selectItem("computercraft:disk_expanded")
	turtle.transferTo(12)

	item.getFromChest("computercraft:peripheral",1)
	item.selectItem("computercraft:peripheral")
	turtle.transferTo(11)

	--Place a part of the new turtle
	gps.faceLeft()
	gps.move(3)
	gps.faceLeft()

	--Do the disk drive stuff
	item.selectItem("computercraft:peripheral")
	gps.breakFront()
	turtle.place()
	item.selectItem("computercraft:disk_expanded")
	turtle.drop()
	fs.copy("/rom/programs/startup.lua", disk.getMountPath("front").."/startup.lua")

	gps.faceRight()
	gps.moveBack()

	item.selectItem("computercraft:turtle_expanded")
	turtle.place()

	item.selectItem("minecraft:chest")
	turtle.drop()

	item.selectItem("minecraft:furnace")
	turtle.drop()

	gps.faceAround()
	gps.move(2)

	file.store(17,restartIndex+1)
end

file.checkShutdown()
restartIndex = file.get(17)
--get all of the items from the materials chest
if restartIndex == 13 then

	item.getFromChest("minecraft:dirt,0",88)
	item.selectItem("minecraft:dirt")
	turtle.transferTo(15)
	item.selectItem("minecraft:dirt")
	turtle.transferTo(14)

	item.getFromChest("minecraft:sapling",20)
	item.selectItem("minecraft:sapling")
	turtle.transferTo(13)

	item.getFromChest("minecraft:coal", 64)
	item.selectItem("minecraft:coal")
	turtle.transferTo(12)

	file.store(17,restartIndex+1)
end

file.checkShutdown()
restartIndex = file.get(17)
--get coal form furnace, and setup new turtle
if restartIndex == 14 then
	gps.faceAround()
	gps.move(2)

	item.selectItem("minecraft:coal")
	turtle.drop()

	item.selectItem("minecraft:sapling")
	turtle.drop()

	item.selectItem("minecraft:dirt")
	turtle.drop()

	item.selectItem("minecraft:dirt")
	turtle.drop()

	--Turn on the new turtle
	local treeTurtle = peripheral.wrap("front")
	treeTurtle.turnOn()

	gps.moveBack()
	item.selectItem("computercraft:wired_modem_full")
	turtle.place()
	file.store(17,restartIndex+1)
end

file.checkShutdown()
restartIndex = file.get(17)
--give the new turtle the current coordiantes via rednet
if restartIndex == 15 then
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
	rednet.broadcast("buildTreeFarm")

	file.store(17,restartIndex+1)
end

restartIndex = file.get(17)
if restartIndex == 16 then

	--Get Wood
	--False for Testing
	if false then
		gps.moveBack()
		gps.moveHighWay(file.get(1), gps.highWayLevelMax+3, file.get(3)+16)
		gps.moveChunk(12, 3)
		while item.countItems("minecraft:log,1") < 3*64 do
			turtle.suckUp()
		end
		gps.moveHighWay(file.get(5), file.get(6), file.get(7))
		gps.face(3)
		item.itemdelivery()
		gps.faceAround()
		gps.move()
	end

	item.resetItemCounts()

	--Craft the items for the chestArray turtle
	components = true

	item.craftItemBranch("computercraft:turtle_expanded", 1)
	gps.faceLeft()
	item.getFromChest("computercraft:turtle_expanded", 1)
	if turtle.getItemCount(16) < 1 then
		components = false
		print(1)
	end
	turtle.drop()
	gps.faceRight()

	--print("turtle done")
	item.craftItemBranch("computercraft:wired_modem_full", 2)
	gps.faceLeft()
	item.getFromChest("computercraft:wired_modem_full", 2)

	if turtle.getItemCount(16) < 2 then
		components = false
		print(2)
	end
	turtle.drop()
	gps.faceRight()

	item.craftItemBranch("computercraft:computer", 2)
	gps.faceLeft()
	item.getFromChest("computercraft:computer", 2)

	if turtle.getItemCount(16) < 2 then
		components = false
		print(3)
	end
	turtle.select(16)
	turtle.drop()
	gps.faceRight()


	item.craftItemBranch("minecraft:chest", 64)
	item.getFromChest("minecraft:chest", 64)
	gps.faceLeft()
	item.getFromChest("minecraft:chest", 64)

	if item.countItems("minecraft:chest") < 64 then
		components = false
		print(4)
	end
	turtle.select(16)
	turtle.drop()
	turtle.select(15)
	turtle.drop()
	gps.faceRight()

	item.craftItemBranch("computercraft:peripheral", 2)



	print(components)
	--Turtle is now facing the oppositeChest
	if components == true  then
		--oppositeChest
		item.getFromChest("minecraft:coal", 64)

		--leftChest
		gps.faceLeft()
		item.getFromChest("minecraft:chest", 64)
		item.getFromChest("computercraft:turtle_expanded", 1)
		item.getFromChest("computercraft:wired_modem_full", 2)
		item.getFromChest("computercraft:computer", 2)
		item.getFromChest("computercraft:peripheral", 2)

		gps.faceLeft()

		gps.move(2)
		item.selectItem("computercraft:turtle_expanded")
		turtle.place()

		--Transfer all the new items to the chestArray Turtle
		item.dumpItem("minecraft:coal", 64)
		item.storeItemDict("minecraft:coal", -64)
		item.dumpItem("minecraft:chest", 64)
		item.storeItemDict("minecraft:chest", -64)
		item.dumpItem("computercraft:computer", 2)
		item.storeItemDict("computercraft:computer", -2)
		item.dumpItem("computercraft:wired_modem_full", 2)
		item.storeItemDict("computercraft:wired_modem_full", -2)
		item.dumpItem("computercraft:peripheral", 2)
		item.storeItemDict("computercraft:peripheral", -2)

		--Turn on the new turtle
		local chestTurtle = peripheral.wrap("front")
		chestTurtle.turnOn()

		gps.moveBack(1)
		item.selectItem("computercraft:wired_modem_full")
		turtle.place()

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
		rednet.broadcast("chestArray")
	end
	file.store(17,restartIndex+1)
end

end


return startBase

local startBase = {}

function startBase.Function()
print("running startBase")

os.loadAPI("/rom/apisFiles/item.lua")
os.loadAPI("/rom/apisFiles/gps.lua")
os.loadAPI("/rom/apisFiles/file.lua")
os.loadAPI("/rom/apisFiles/recipe.lua")
print(os.loadAPI("/rom/apisFiles/recipe.lua"))
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
	if restartIndex == 0 then
		for i=1,4 do
			file.store(i+4,file.get(i))
		end

	else
		print(file.get(5),file.get(6),file.get(7))
		gps.moveAbs(file.get(5),file.get(6),file.get(7))
		print("move done")

		gps.face(file.get(8))
		print("face done")
		turtle.digUp()

		gps.faceAround()
		gps.move(18)
		gps.faceRight()
		gps.move(8)
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
	print("drop done")
end

print("start")
restartIndex = file.get(17)
start()

file.checkShutdown()
restartIndex = file.get(17)
--craft and place furnace
if restartIndex == 0 then
	print(recipe.furnace)
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
	item.craftItem(recipe.modem)
	turtle.drop()

	item.craftItem(recipe.modemBlock)
	turtle.drop()

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

	file.store(17,restartIndex+1)
end

file.checkShutdown()
restartIndex = file.get(17)
--get all of the items from the materials chest
if restartIndex == 13 then
	gps.faceRight()

	item.getFromChest("minecraft:dirt,0",88)
	item.selectItem("minecraft:dirt")
	turtle.transferTo(12)

	item.getFromChest("minecraft:sapling",20)
	item.selectItem("minecraft:sapling")
	turtle.transferTo(11)

	file.store(17,restartIndex+1)
end

file.checkShutdown()
restartIndex = file.get(17)
--get coal form furnace, and setup new turtle
if restartIndex == 14 then
gps.faceAround()
gps.moveUp(1)
turtle.suck()
gps.moveDown(1)
gps.move(2)

item.selectItem("computercraft:turtle_expanded")
turtle.place()

item.selectItem("minecraft:coal")
turtle.drop(10)

item.selectItem("minecraft:sapling")
turtle.drop()

item.selectItem("minecraft:dirt")
turtle.drop()

item.selectItem("minecraft:dirt")
turtle.drop()

item.selectItem("minecraft:chest")
turtle.drop()

item.selectItem("minecraft:furnace")
turtle.drop()

gps.moveBack()
item.selectItem("computercraft:wired_modem_full")
turtle.place()
file.store(17,restartIndex+1)
end

file.checkShutdown()
restartIndex = file.get(17)
--give the new turtle the current coordiantes via rednet
if restartIndex == 15 then
	os.sleep(20)
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

	end
	file.store(17,restartIndex+1)



	--Get Wood
	gps.moveHighWay(file.get(1), 130, file.get(3))
	gps.moveChunk(12, 3)
	while item.countItems("minecraft:log,1") < 3*64 do
		turtle.suckUp()
	end
	gps.moveHighWay(file.get(5), file.get(6), file.get(7))
	gps.face(3)
	gps.move()

	--Make the chestArray Turtle
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

	--Craft the items for the chestArray turtle
	components = true

	item.craftItemBranch("computercraft:turtle_expanded", 1)
	item.getFromChest("computercraft:turtle_expanded", 1)
	if turtle.getItemCount(16) < 1 then
		components = false
	end
	item.craftItemBranch("computercraft:wired_modem_full", 2)
	item.getFromChest("computercraft:wired_modem_full", 2)
	if turtle.getItemCount(16) < 1 then
		components = false
	end
	item.craftItemBranch("computercraft:computer", 1)
	item.getFromChest("computercraft:computer", 1)
	if turtle.getItemCount(16) < 1 then
		components = false
	end
	item.craftItemBranch("minecraft:chest", 64)
	item.getFromChest("minecraft:chest", 1)
	if turtle.getItemCount(16) < 64 then
		components = false
	end

	if components == true  then
		gps.faceRight()
		item.getFromChest("minecraft:coal", 64)
		gps.faceAround()

		gps.move(2)
		item.selectItem("computercraft:turtle_expanded")
		turtle.place()

		--Transfer all the new items to the chestArray Turtle
		item.dumpItem("minecraft:coal", 64)
		item.storeItemDict("minecraft:coal", -64)
		item.dumpItem("minecraft:chest", 64)
		item.storeItemDict("minecraft:chest", -64)
		item.dumpItem("computercraft:computer", 1)
		item.storeItemDict("computercraft:computer", -1)
		item.dumpItem("computercraft:wired_modem_full", 1)
		item.storeItemDict("computercraft:wired_modem_full", -1)

		gps.moveBack(1)
		item.selectItem("computercraft:wired_modem_full")
		turtle.place()
		item.storeItemDict("computercraft:wired_modem_full", -1)


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
		rednet.broadcast("chestArray")
	end

end


return startBase

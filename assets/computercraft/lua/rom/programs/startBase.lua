local startBase = {}

function startBase.Function()
print("running startBase")

os.loadAPI("/rom/apis/item.lua")
os.loadAPI("/rom/apis/gps.lua")
os.loadAPI("/rom/apis/file.lua")
os.loadAPI("/rom/apis/recipe.lua")
print(os.loadAPI("/rom/apis/recipe.lua"))
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
	print(recipe.Furnace)
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

	file.store(17,restartIndex+1)
end

file.checkShutdown()
restartIndex = file.get(17)
--get all of the items from the materials chest
if restartIndex == 13 then
	gps.faceRight()

	item.getFromChest("minecraft:dirt,0",88)
	item.selectItem("minecraft:dirt")
	turtle.transferTo(13)

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
end


return startBase

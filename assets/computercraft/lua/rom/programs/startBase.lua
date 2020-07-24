local startBase = {}

function startBase.Function()
print("running startBase")

os.loadAPI("/rom/apis/item.lua")
os.loadAPI("/rom/apis/gps.lua")
os.loadAPI("/rom/apis/file.lua")


recipeComputer = {}
recipeComputer["minecraft:stone,0"] = {1,2,3,5,7,9,11}
recipeComputer["minecraft:redstone"] = {6}
recipeComputer["minecraft:glass_pane"] = {10}

recipeTurtle = {}
recipeTurtle["minecraft:iron_ingot"] = {1,2,3,5,7,9,11}
recipeTurtle["computercraft:computer"] = {6}
recipeTurtle["minecraft:chest"] = {10}

recipeModem = {}
recipeModem["minecraft:stone,0"] = {1,2,3,5,7,9,10,11}
recipeModem["minecraft:redstone"] = {6}

recipeModemBlock = {}
recipeModemBlock["computercraft:cable,1"] = {1}

recipeFurnace = {}
recipeFurnace["minecraft:cobblestone"] = {1,2,3,5,7,9,10,11}

recipeChest = {}
recipeChest["minecraft:planks"] = {1,2,3,5,7,9,10,11}

recipeGlassPane = {}
recipeGlassPane["minecraft:glass"] = {5,6,7,9,10,11}

recipeStick = {}
recipeStick["minecraft:planks"] = {1,5}

recipeDiamondPickaxe = {}
recipeDiamondPickaxe["minecraft:diamond"] = {1,2,3}
recipeDiamondPickaxe["minecraft:stick"] = {6,10}

recipeMiningTurtle = {}
recipeMiningTurtle["minecraft:diamond_pickaxe"] = {3}
recipeMiningTurtle["computercraft:turtle_expanded"] = {2}


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
	print(file.get(5),file.get(6),file.get(7))
	gps.moveAbs(file.get(5),file.get(6),file.get(7))
	print("move done")

	gps.face(file.get(8))
	print("face done")
	for i=1,16 do
		turtle.select(i)
		turtle.drop()
	end
	print("drop done")
end

print("start")
start()

file.checkShutdown()
if file.get(17) == 0 then
	item.craftItem(recipeFurnace)

	gps.faceAround()
	gps.move()
	turtle.placeUp()
	file.store(17,1)
end

file.checkShutdown()
if file.get(17) == 1 then
gps.faceAround()
gps.move()

item.getFromChest("minecraft:coal",40)
gps.faceAround()
gps.moveUp()
item.selectItem("minecraft:coal")
turtle.drop()

gps.faceAround()
gps.moveDown()
file.store(17,2)
end

file.checkShutdown()
if file.get(17) == 2 then
item.craftItem(recipeChest)
gps.faceLeft()
turtle.place()
gps.faceRight()
file.store(17,3)
end

file.checkShutdown()
if file.get(17) == 3 then
smelt("minecraft:cobblestone",15)
file.store(17,4)
end

file.checkShutdown()
if file.get(17) == 4 then
smelt("minecraft:sand",6)
file.store(17,5)
end

file.checkShutdown()
if file.get(17) == 5 then
smelt("minecraft:iron_ore",7)
file.store(17,6)
end

file.checkShutdown()
if file.get(17) == 6 then
item.putInCraftingChest("minecraft:redstone",2)
file.store(17,7)
end

file.checkShutdown()
if file.get(17) == 7 then
item.putInCraftingChest("minecraft:planks",10)
item.putInCraftingChest("minecraft:diamond",3)
file.store(17,8)
end

file.checkShutdown()
if file.get(17) == 8 then
gps.faceLeft()
item.craftItem(recipeGlassPane)
turtle.drop()
file.store(17,9)
end

file.checkShutdown()
if file.get(17) == 9 then
item.craftItem(recipeComputer)
turtle.drop()
file.store(17,10)
end

file.checkShutdown()
if file.get(17) == 10 then
item.craftItem(recipeChest)
turtle.drop()
file.store(17,11)
end

file.checkShutdown()
if file.get(17) == 11 then
item.craftItem(recipeTurtle)
turtle.drop()
file.store(17, 12)
end

file.checkShutdown()
if file.get(17) == 12 then
item.craftItem(recipeStick)
turtle.drop()
file.store(17, 13)
end

file.checkShutdown()
if file.get(17) == 13 then
item.craftItem(recipeDiamondPickaxe)
turtle.drop()
file.store(17, 14)
end

file.checkShutdown()
if file.get(17) == 14 then
item.craftItem(recipeMiningTurtle)
turtle.drop()
file.store(17, 15)
end

file.checkShutdown()
if file.get(17) == 15 then
item.craftItem(recipeModem)
turtle.drop()
item.craftItem(recipeModemBlock)
turtle.drop()
file.store(17, 16)
end

item.getFromChest("computercraft:wired_modem_full",1)
item.selectItem("computercraft:wired_modem_full")
turtle.transferTo(16)

item.getFromChest("computercraft:turtle_expanded",1)
item.selectItem("computercraft:turtle_expanded")
turtle.transferTo(15)

gps.faceRight()
item.getFromChest("minecraft:dirt,0",88)
item.selectItem("minecraft:dirt")
turtle.transferTo(14)


item.getFromChest("minecraft:sapling",10)
item.selectItem("minecraft:sapling")
turtle.transferTo(12)


gps.faceAround()
--Get the Coal from the Furnace 
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

gps.moveBack()
item.selectItem("computercraft:wired_modem_full")
turtle.place()


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

rednet.broadcast("buildTreeFarm")


end



return startBase


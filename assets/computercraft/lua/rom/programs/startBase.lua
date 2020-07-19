local startBase = {}

function startBase.Function()

self = require("self")

recipeComputer = {}
recipeComputer["minecraft:stone,0"] = {1,2,3,5,7,9,11}
recipeComputer["minecraft:redstone"] = {6}
recipeComputer["minecraft:glass_pane"] = {10}

recipeTurtle = {}
recipeTurtle["minecraft:iron_ingot"] = {1,2,3,5,7,9,11}
recipeTurtle["computercraft:computer"] = {6}
recipeTurtle["minecraft:chest"] = {10}

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

function selectItem(name)
	counter = 1
	for i=1,16 do
	turtle.select(i)
		if turtle.getItemCount() ~= 0 then
			if turtle.getItemDetail().name == name then
				break
			end
		else
			counter = counter +1
		end
	end
end

function putInCraftingChest(name,amount)
	getFromChest(name,amount)
	self.faceLeft()
	turtle.drop()
	self.faceRight()
end

function craftItem(recipe)
	local counter = 0
	for key,value in pairs(recipe) do
		getFromChest(key,table.getn(value))
		print(counter)
		turtle.transferTo(16-counter)
		counter = counter +1
	end
	
	for key,value in pairs(recipe) do
		print(key)
		if key:match("([^,]+),([^,]+)") ~= nil then
			key, dam = key:match("([^,]+),([^,]+)")
 
		end
		
		selectItem(key)
		selection = turtle.getSelectedSlot()
		for i=1,table.getn(value) do
			turtle.select(selection)
			turtle.transferTo(value[i],1)
		end
	end
	turtle.craft()
end
	


function getFromChest(name,amount)
	turtle.select(1)
	local counter = 1
	anyDam = false
	if name:match("([^,]+),([^,]+)") ~= nil then
		name, dam = name:match("([^,]+),([^,]+)")
		dam = tonumber(dam)
	else
		anyDam = true 
	end
	while turtle.suck() == true and counter <=16 do
		turtle.select(counter)
		counter = counter + 1
		print(name,turtle.getItemDetail().damage==dam)
		if turtle.getItemCount() ~= 0 then
			if turtle.getItemDetail().name == name and (turtle.getItemDetail().damage == dam or anyDam) then
				break
			end
		end
	end
	for i=1,counter-2 do
		turtle.select(i)
		turtle.drop()
	end
	turtle.select(counter-1)
	turtle.transferTo(1)
	turtle.select(1)
	if amount ~= 0 then
		turtle.drop(turtle.getItemCount()-amount)
	end
end

function smelt(name,amount)
	getFromChest(name,amount)
	self.faceAround()
	self.moveup(2)
	self.move()
	turtle.dropDown()
	self.moveback()
	self.movedown(2)
	self.move()
	os.sleep(10*amount)
	turtle.suckUp()
	self.faceAround()
	self.move()
	self.faceLeft()
	turtle.drop()
	self.faceRight()
end


function start()
	self.moveabs(tonumber(self.get(5)),tonumber(self.get(6)),tonumber(self.get(7)))
	print("move done")

	self.face(tonumber(self.get(8)))
	print("face done")
	for i=1,16 do
		turtle.select(i)
		turtle.drop()
	end
	print("drop done")
end

start()

self.checkShutdown()
if tonumber(self.get(17)) == 0 then
	craftItem(recipeFurnace)

	self.faceAround()
	self.move()
	turtle.placeUp()
	self.store(17,1)
end

self.checkShutdown()
if tonumber(self.get(17)) == 1 then
self.faceAround()
self.move()

getFromChest("minecraft:coal",0)
self.faceAround()
self.moveup()
turtle.drop()

self.faceAround()
self.movedown()
self.store(17,2)
end

self.checkShutdown()
if tonumber(self.get(17)) == 2 then
craftItem(recipeChest)
self.faceLeft()
turtle.place()
self.faceRight()
self.store(17,3)
end

self.checkShutdown()
if tonumber(self.get(17)) == 3 then
smelt("minecraft:cobblestone",7)
self.store(17,4)
end

self.checkShutdown()
if tonumber(self.get(17)) == 4 then
smelt("minecraft:sand",6)
self.store(17,5)
end

self.checkShutdown()
if tonumber(self.get(17)) == 5 then
smelt("minecraft:iron_ore",7)
self.store(17,6)
end

self.checkShutdown()
if tonumber(self.get(17)) == 6 then
putInCraftingChest("minecraft:redstone",1)
self.store(17,7)
end

self.checkShutdown()
if tonumber(self.get(17)) == 7 then
putInCraftingChest("minecraft:planks",8)
self.store(17,8)
end

self.checkShutdown()
if tonumber(self.get(17)) == 8 then
self.faceLeft()
craftItem(recipeGlassPane)
turtle.drop()
self.store(17,9)
end

self.checkShutdown()
if tonumber(self.get(17)) == 9 then
craftItem(recipeComputer)
turtle.drop()
self.store(17,10)
end

self.checkShutdown()
if tonumber(self.get(17)) == 10 then
craftItem(recipeChest)
turtle.drop()
self.store(17,11)
end

self.checkShutdown()
if tonumber(self.get(17)) == 11 then
craftItem(recipeTurtle)
turtle.drop()
self.store(17, 12)
end

self.checkShutdown()
if tonumber(self.get(17)) == 12 then
self.faceRight()
craftItem(recipeStick)
turtle.drop()
self.store(17, 13)
end

self.checkShutdown()
if tonumber(self.get(17)) == 13 then
craftItem(recipeDiamondPickaxe)
self.faceLeft()
turtle.drop()
self.store(17, 14)
end

self.checkShutdown()
if tonumber(self.get(17)) == 14 then
craftItem(recipeMiningTurtle)
turtle.drop()
self.store(17, 15)

self.store(14, "Finish")

end

end

return startBase
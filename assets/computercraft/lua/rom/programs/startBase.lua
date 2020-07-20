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


function putInCraftingChest(name,amount)
	getFromChest(name,amount)
	self.selectItem(name)
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
		
		self.selectItem(key)
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
	
	local nStacks = math.floor(amount/64+1)
	amount = amount%64
	
	anyDam = false
	if name:match("([^,]+),([^,]+)") ~= nil then
		name, dam = name:match("([^,]+),([^,]+)")
		dam = tonumber(dam)
	else
		anyDam = true 
	end
	print(name)
	for i=1,nStacks do
		local counter = 1
		while turtle.suck() == true and counter <=16 do
			turtle.select(counter)
			counter = counter + 1
	
			if turtle.getItemCount() ~= 0 then
			
				if turtle.getItemDetail().name == name and (turtle.getItemDetail().damage == dam or anyDam) then
					break
				end
				
			end
			
		end
		--Move stack to last available slot
		print(i,nStacks)
		for j=16,1,-1 do
			turtle.select(j)
			if turtle.getItemCount() == 0 then
				if i==nStacks then
					turtle.select(counter-1)
					turtle.transferTo(j,amount)
					break
				else
					turtle.select(counter-1)
					turtle.transferTo(j,64)
					break
				end
			end
		end
	for i=turtle.getSelectedSlot(),1,-1 do
		turtle.select(i)
		turtle.drop()
	end
	end
	

end


function smelt(name,amount)
	getFromChest(name,amount)
	self.selectItem(name)
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

getFromChest("minecraft:coal",40)
self.faceAround()
self.moveup()
self.selectItem("minecraft:coal")
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
smelt("minecraft:cobblestone",15)
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
putInCraftingChest("minecraft:redstone",2)
self.store(17,7)
end

self.checkShutdown()
if tonumber(self.get(17)) == 7 then
putInCraftingChest("minecraft:planks",10)
putInCraftingChest("minecraft:diamond",3)
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
craftItem(recipeStick)
turtle.drop()
self.store(17, 13)
end

self.checkShutdown()
if tonumber(self.get(17)) == 13 then
craftItem(recipeDiamondPickaxe)
turtle.drop()
self.store(17, 14)
end

self.checkShutdown()
if tonumber(self.get(17)) == 14 then
craftItem(recipeMiningTurtle)
turtle.drop()
self.store(17, 15)
end

self.checkShutdown()
if tonumber(self.get(17)) == 15 then
craftItem(recipeModem)
turtle.drop()
craftItem(recipeModemBlock)
turtle.drop()
self.store(17, 16)
end

getFromChest("computercraft:wired_modem_full",1)
self.selectItem("computercraft:wired_modem_full")
turtle.transferTo(16)

getFromChest("computercraft:turtle_expanded",1)
self.selectItem("computercraft:turtle_expanded")
turtle.transferTo(15)

self.faceRight()
getFromChest("minecraft:dirt,0",88)
self.selectItem("minecraft:dirt")
turtle.transferTo(14)

<<<<<<< HEAD
=======
getFromChest("minecraft:dirt,0",24)
self.selectItem("minecraft:dirt")
turtle.transferTo(13)
>>>>>>> 715a9fc71f1fa361fd3678a99fe0b409d3f14453

getFromChest("minecraft:sapling",10)
self.selectItem("minecraft:sapling")
turtle.transferTo(12)


self.faceAround()
--Get the Coal from the Furnace 
self.moveup(1)
turtle.suck()
self.movedown(1)

self.move(2)
self.selectItem("computercraft:turtle_expanded")
turtle.place()

self.selectItem("minecraft:coal")
turtle.drop(10)

self.selectItem("minecraft:sapling")
turtle.drop()

self.selectItem("minecraft:dirt")
turtle.drop()

self.selectItem("minecraft:dirt")
turtle.drop()

self.moveback()
self.selectItem("computercraft:wired_modem_full")
turtle.place()

os.sleep(20)
rednet.open("front")

if tonumber(self.get(4)) == 0 or tonumber(self.get(4)) == 2 then
	rednet.broadcast(self.get(1))
	os.sleep(1)
	rednet.broadcast(self.get(2))
	os.sleep(1)
	if tonumber(self.get(4) == 0) then
		rednet.broadcast(self.get(3)-2)
		rednet.broadcast(self.get(4))
	else
		rednet.broadcast(self.get(3)+2)
		rednet.broadcast(self.get(4))
	end
end

if tonumber(self.get(4)) == 1 or tonumber(self.get(4)) == 3 then

	if tonumber(self.get(4)) == 1 then
		rednet.broadcast(self.get(1)+2)
		rednet.broadcast(self.get(2))
		rednet.broadcast(self.get(3))
		rednet.broadcast(self.get(4))
	else
		rednet.broadcast(self.get(1)-2)
		rednet.broadcast(self.get(2))
		rednet.broadcast(self.get(3))
		rednet.broadcast(self.get(4))
	end
end

rednet.broadcast("buildTreeFarm")


end

return startBase


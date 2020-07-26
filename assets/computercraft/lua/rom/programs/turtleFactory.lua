local turtleFactory = {}

function turtleFactory.Function()
turtle.refuel()
os.loadAPI("/rom/apisFiles/item.lua")
os.loadAPI("/rom/apisFiles/gps.lua")
os.loadAPI("/rom/apisFiles/file.lua")
os.loadAPI("/rom/apisFiles/recipe.lua")


fs.delete("/items.txt")
if fs.exists("/items.txt") == false then
--Create the Data.txt file and fill items
	fs.copy("/rom/global files/itemsTemplate.txt","/items.txt")
end

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
--for k,v in pairs(itemstable) do
--	print(k,v)
--end
--itemstable[2] = 3
--for i = 1,4 do
--	itemsstore(i, itemstable[i])
--end
local resources = {}
resources["minecraft:iron_ore"] = 7
resources["minecraft:redstone"] = 2
resources["minecraft:cobblestone"] = 23
resources["minecraft:dirt,0"] = 88
resources["minecraft:diamond"] = 3
resources["computercraft:turtle_expanded"] = 1
resources["minecraft:diamond_pickaxe"] = 1

quarryTurtleRecipes = {}
quarryTurtleRecipes[1] = recipe.miningTurtle

quarryTurtleRecipes[2] = recipe.diamondPickaxe
quarryTurtleRecipes[3] = recipe.stick

quarryTurtleRecipes[4] = recipe.turtle
quarryTurtleRecipes[5] = recipe.computer
quarryTurtleRecipes[6] = recipe.glassPane
quarryTurtleRecipes[7] = recipe.chest



function smelt(name,amount)
	item.getFromChest("minecraft:coal",1)
	item.storeItemDict("minecraft:coal", -1)

	gps.faceAround()
	gps.moveUp()

	item.selectItem("minecraft:coal")
	turtle.drop()

	gps.faceAround()
	gps.moveDown()

	item.getFromChest(name,amount)
	item.storeItemDict(name, -amount)

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
	item.slotToItemDict(turtle.getSelectedSlot())
	turtle.drop()
	gps.faceRight()
end

function checkAndCraftBranch(name, amount, craftingChest)
	--Initialization
	smelting = false
	if craftingChest == nil then
		craftingChest = 0
	end

	key1 = name
	recipeTable = recipe.referenceTable[name]
	for key2 , value2 in pairs(recipeTable) do
		if value2[1] == "result" then

			print(key2 , item.getItemDict(key2))
			currentAmount = item.getItemDict(key2)
			craftedAmount = currentAmount+value2[2]

			if item.getItemDict(key2) >= amount then
				print("true2")
				return true
			end
		else
			if item.getItemDict(key2, true) < table.getn(value2) then
				nextRecipe = key2
				nextAmount = table.getn(value2)
				print("nextRecipe", nextRecipe)
				return false
			end
		end
	end
	--Getting everything needed for the crafting into the crafting chest
	for key2 , value2 in pairs(recipeTable) do
		if value2[1] ~= "result" and value2[1] ~= "smelt" then
			item.putInCraftingChest(key2, table.getn(value2))
		elseif value2[1] == "smelt" then
			--Smelt it instead of crafting if it needs to be smelted
			smelting = true
			print("We are smelting bois")
			smelt(key2, 8)
		end
	end
	--The Crafting
	gps.faceLeft()
	if smelting == false then
		item.craftItem(recipeTable)
	end
	if turtle.getItemCount() == 0 then
		turtle.drop(craftingChest)
		gps.faceRight()
		turtle.drop()
		print("false1")
		return false
	else
		turtle.drop(craftingChest)
		gps.faceRight()
		turtle.drop()
		if craftedAmount >= amount then
			print("true1")
			return true
		else
			return false
		end
	end
end
print("jippies")
function craftItemBranch(name, amount)
	breaking = false
	while checkAndCraftBranch(name, amount, 1) == false do
		while checkAndCraftBranch(nextRecipe, nextAmount, 1) == false do
			if recipe.referenceTable[nextRecipe] == nil then
				breaking = true
				break
			end
		end
		if recipe.referenceTable[nextRecipe] == nil then
			breaking = true
			break
		end
	end
end

--Craft a Mining Turtle
craftItemBranch("computercraft:turtle_expanded", 1)
if breaking == false then
	craftItemBranch("minecraft:diamond_pickaxe", 1)
end
gps.faceLeft()
if breaking == false then
	item.craftItem(recipe.miningTurtle)
	turtle.drop()
	print("I made a mining turtle")
end
print("Lemma Quarry")

os.sleep(50000)




for key , value in pairs(resources) do
	if item.getItemDict(key) < value then
		enoughItems = "false"
	else
		enoughItems =  "true"
	end
end
for key , value in pairs(recipe) do
	if value[1] ~= "result" then
		item.storeItemDict(key,-table.getn(value))
	else
		item.storeItemDict(key,1)
	end
end

function recipeToItemDict(recipe)
	for k, v in pairs(recipe) do
		item.storeItemDict(k,-table.getn(v))
	end
end
item.craftItem(recipeComputer)

end
return turtleFactory

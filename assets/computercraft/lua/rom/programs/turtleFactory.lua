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
	if craftingChest == nil then
		craftingChest = 0
	end

	recipeTable = recipe.referenceTable[name]
	for key2 , value2 in pairs(recipeTable) do
		print("Tih", key2 , item.getItemDict(key2, true), table.getn(value2), name)
		if item.getItemDict(key2, true) < table.getn(value2) and value2[1] ~= "result" then
			nextRecipe = key2
			nextAmount = table.getn(value2)
			print("nextRecipe", nextRecipe)
			print("false2")
			return false
		end
	end

	for key2 , value2 in pairs(recipeTable) do
		if value2[1] == "result" then

			print(key2 , item.getItemDict(key2, true))
			currentAmount = item.getItemDict(key2, true)
			craftedAmount = currentAmount+value2[2]

			if item.getItemDict(key2) >= amount then
				print("true2")
				return true
			end
		end
	end
	--Getting everything needed for the crafting into the crafting chest
	for key2 , value2 in pairs(recipeTable) do
		if value2[1] ~= "result" and value2[1] ~= "smelt" then
			item.putInCraftingChest(key2, table.getn(value2))
		elseif value2[1] == "smelt" then
			--Smelt it instead of crafting if it needs to be smelted
			print("We are smelting bois")
			smelt(key2, 8)
			print("false3")
			return false
		end
	end
	--The Crafting
	gps.faceLeft()
	item.craftItem(recipeTable)
	if turtle.getItemCount() == 0 then
		gps.faceRight()
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
			print("false4")
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



function lsistItemBranch(name, amount)
	recipeTable = recipe.referenceTable[name]
	for key2 , value2 in pairs(recipeTable) do
		print("Tih", key2 , item.getItemDict(key2, true), table.getn(value2), name)
		if boodschappen[key2] == nil then
			boodschappen[key2] = 0
		end
		print("boodschappen", boodschappen[key2])


		if item.getItemDict(key2, true)+boodschappen[key2] < table.getn(value2) and value2[1] ~= "result" and value2[1] ~= "smelt" then

			if recipe.referenceTable[key2] ~= nil then
				nextRecipe = key2
				nextAmount = table.getn(value2)*amount
				print("nextRecipe", nextRecipe)
				print("false1")
				return false
			else
				boodschappen[key2] = boodschappen[key2] + table.getn(value2)*amount
				print("true1")
				return true
			end
		elseif value2[1] == "smelt" then
			--Remove later
			print("Deaths")
			os.sleep(20000)

			boodschappen[name] = boodschappen[name] + amount
			print("true2")
			return true
		end
	end
	print("false2")
	return false
end

function sslistItemBranch(name, amount)
	recipeTable = recipe.referenceTable[name]
	for key, value in pairs(recipeTable) do
		if boodschappenLijstje[key] == nil then
			boodschappenLijstje[key] = -item.getItemDict(key, true)
		end
		--if done[key] == nil then
		--	done[key] = false
		--end
		--if done[key] == false then
		if item.getItemDict(key, true)+boodschappenLijstje[key] < table.getn(value) and value[1] ~= "result" then
			if recipe.referenceTable[key] ~= nil then
				nextRecipe = key
				nextAmount = table.getn(value)*amount
				--done[key] = true
				boodschappenLijstje[key] = boodschappenLijstje[key] + table.getn(value)*amount
				--print("false1")
				return false
			else
				boodschappenLijstje[key] = boodschappenLijstje[key] + table.getn(value)*amount
				--done[key] = true
				--print("true2")
				--return true
			end
		elseif value[1] ~= "result" then
			--done[key] = true
			--print("true3")
			--return true
		end
		--end
	end
	--print("true1")
	return true

end

function listItemBranch(name, amount)
	recipeTable = recipe.referenceTable[name]
	for key, value in pairs(recipeTable) do
		if boodschappenLijstje[key] == nil then
			boodschappenLijstje[key] = -item.getItemDict(key, true)
		end
		print(boodschappenLijstje[key], table.getn(value))
		if item.getItemDict(key, true)+boodschappenLijstje[key] < table.getn(value) then

			if recipe.referenceTable[key] ~= nil  and value[1] == "result" then
				nextRecipe = key
				nextAmount = table.getn(value)*amount
				boodschappenLijstje[key] = boodschappenLijstje[key] + table.getn(value)*amount
				return false
			end
		end
	end

	for key, value in pairs(recipeTable) do
		print(boodschappenLijstje[key], table.getn(value))
		if item.getItemDict(key, true)+boodschappenLijstje[key] < table.getn(value) then

			if value[1] ~= "result" then
				--done[key] = true
				boodschappenLijstje[key] = boodschappenLijstje[key] + table.getn(value)*amount
				return false
			end
		end
	end
	return true
end

function boodschappen(name, amount)
	boodschappenLijstje = {}
	while listItemBranch(name, amount) == false do
		while listItemBranch(nextRecipe, nextAmount, 1) == false do
			if recipe.referenceTable[nextRecipe] == nil then
				breaking = true
				break
			end
		end
	end
end


function sboodschappen(name, amount)
	boodschappenLijstje = {}
	done = {}
	breaking = false
	while listItemBranch(name, amount, 1) == false do
		while listItemBranch(nextRecipe, nextAmount, 1) == false do
		end
	end
	for key , value in pairs(boodschappenLijstje) do
		recipeTable = recipe.referenceTable[key]
		if recipeTable ~= nil then
			for key2  , value2 in pairs(recipeTable) do
				if value2[1] == "result" then
					for key3 , value3 in pairs(recipe.referenceTable[key2]) do
						if value3[1] == "smelt" then
							lowerLevelSmelt = true
							boodschappenLijstje[key3] = 0
						end
					end
					if lowerLevelSmelt ~= true then
						boodschappenLijstje[key2] = 0
					end
				end
			end
		end
	end
end
boodschappen("computercraft:turtle_expanded", 1)
for k, v in pairs(boodschappenLijstje) do
	print("boodschap", k , v)
end
os.sleep(200000)


--Craft a Mining Turtle
breaking = false
craftItemBranch("computercraft:turtle_expanded", 2)
craftItemBranch("computercraft:turtle_expanded", 2)
if breaking == false then
	craftItemBranch("minecraft:diamond_pickaxe", 2)
end
read()
gps.faceLeft()
if breaking == false then
	item.craftItem(recipe.miningTurtle)
	turtle.drop()
	print("I made a mining turtle")
end
--craftItemBranch("computercraft:computer", 3)
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
--item.craftItem(recipeComputer)

end
return turtleFactory

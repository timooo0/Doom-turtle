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
		if item.getItemDict(key2, true) < table.getn(value2) and value2[1] ~= "result" then
			nextRecipe = key2
			nextAmount = table.getn(value2)
			return false
		end
	end

	for key2 , value2 in pairs(recipeTable) do
		if value2[1] == "result" then

			currentAmount = item.getItemDict(key2, true)
			craftedAmount = currentAmount+value2[2]

			if item.getItemDict(key2) >= amount then
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
			smelt(key2, 8)
			return false
		end
	end
	--The Crafting
	gps.faceLeft()
	item.craftItem(recipeTable)
	if turtle.getItemCount() == 0 then
		gps.faceRight()
		return false
	else
		turtle.drop(craftingChest)
		gps.faceRight()
		turtle.drop()
		if craftedAmount >= amount then
			return true
		else
			return false
		end
	end
end


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



function listItemBranch(name, amount)
	recipeTable = recipe.referenceTable[name]
	for key , value in pairs(recipeTable) do
		if value[1] == "result" then
			output[recipeTable] = value[2]
		end
	end
	for key , value in pairs(recipeTable) do
		if value[1] ~= "result" then
			if boodschappenLijstje[key] == nil then
				boodschappenLijstje[key] = -item.getItemDict(key, true)
			end
			if counted[key] ~= true then
				if value[1] ~= "smelt" then
				 	--Some weird math to make sure things work out well
					boodschappenLijstje[key] = boodschappenLijstje[key]+table.getn(value)*(math.floor(((amount-1) / output[recipeTable]))+1)
				else
					boodschappenLijstje[key] = 0
				end
				counted[key] = true
			end
		end
	end
end

function boodschappen(name, amount)
	boodschappenLijstje = {}
	counted = {}
	output = {}
	listItemBranch(name, amount)
	for branchDepth = 1, 10 do
		for key, value in pairs(boodschappenLijstje) do
			if recipe.referenceTable[key] ~= nil then
				makeItZero = true
				for key2, value2 in pairs(recipe.referenceTable[key]) do
					if value2[1] == "smelt" then
						makeItZero = false
					end
				end
				if makeItZero ~= false then
					boodschappenLijstje[key] = 0
				end
				--boodschappenLijstje[key] = 0
				listItemBranch(key, value)
			end
		end
	end
	--For printing the list, just remove if you dont want to print it
	for k, v in pairs(boodschappenLijstje) do
		if v ~= 0 then
			print("boodschap", k , v)
		end
	end

	return boodschappenLijstje
end


--anything = false
if anything == false then
	--Craft a Mining Turtle
	breaking = false
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
end

end
return turtleFactory

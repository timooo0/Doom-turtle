local turtleFactory = {}

function turtleFactory.Function()
turtle.refuel()
os.loadAPI("/rom/apis/item.lua")
os.loadAPI("/rom/apis/gps.lua")
os.loadAPI("/rom/apis/file.lua")
os.loadAPI("/rom/apis/recipe.lua")


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



function checkToCraft(i, amount)
	key1 , value1  = i, quarryTurtleRecipes[i]
	print(key1, value1)
	for key2 , value2 in pairs(value1) do
		if value2[1] == result then
			if item.getItemDict(key2) >= amount then
				return true
			end
		elseif item.getItemDict(key2) < table.getn(value2) then
			return key2
		end

	end
end
function putAllInCraftingChest(i)
	key1 , value1  = i, quarryTurtleRecipes[i]
	for key2, value2 in pairs(value1) do
		if value2[1] ~= result then
			item.putInCraftingChest(key2, table.getn(value2))
		end
	end
end
function checkAndCraft(i, amount, craftingChest)
	if craftingChest == nil then
		craftingChest = 0
	end
	key1 = i
	value1 = quarryTurtleRecipes[i]
	--print(key1)
	for key2 , value2 in pairs(value1) do
		if value2[1] == result then


			print(key2 , item.getItemDict(key2))


			if item.getItemDict(key2) >= amount then
				print("true2")
				return true
			end
		else
			if item.getItemDict(key2) < table.getn(value2) then
				return false
			end
		end
	end

	for key2 , value2 in pairs(value1) do
		if value2[1] ~= result then
			item.putInCraftingChest(key2, table.getn(value2))
		end
	end

	gps.faceLeft()
	item.craftItem(value1)
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
		print("true1")
		return true
	end


end


print("jippies")

while checkAndCraft(2, 1, 1) == false do
	print("nopickaxe")
	while checkAndCraft(3, 2) == false do
		print("noSticks")
	end
end

while checkAndCraft(4, 1, 1) == false do
	print("noTrutle")
	while checkAndCraft(5, 1, 1) == false do
		print("noComputer")
		while checkAndCraft(6, 1) == false do
			print("no panes")
		end
	end
	while checkAndCraft(7, 1) == false do
		print("no Chest")
	end
end

checkAndCraft(1,1, 1)

print("I am done")
os.sleep(50000)




for key , value in pairs(resources) do
	if item.getItemDict(key) < value then
		enoughItems = "false"
	else
		enoughItems =  "true"
	end
end
for key , value in pairs(recipe) do
	if value[1] ~= result then
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

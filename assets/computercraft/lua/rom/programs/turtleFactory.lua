os.loadAPI("/rom/apis/item.lua")
os.loadAPI("/rom/apis/gps.lua")
os.loadAPI("/rom/apis/file.lua")
os.loadAPI("/rom/apis/recipe.lua")


fs.delete("/items.txt")
if fs.exists("/items.txt") == false then
--Create the Data.txt file and fill items
	fs.copy("/rom/global files/itemsTemplate.txt","/items.txt")
end

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
quarryTurtleRecipes[2] = recipe.turtle
quarryTurtleRecipes[3] = recipe.computer
quarryTurtleRecipes[4] = recipe.glassPane
quarryTurtleRecipes[5] = recipe.chest

quarryTurtleRecipes[6] = recipe.diamondPickaxe
quarryTurtleRecipes[7] = recipe.stick


for key1 , value1 in ipairs(quarryTurtleRecipes) do
	for key2 , value2 in pairs(value1) do
		if value2[1] ~= result and item.getItemDict(key2) < table.getn(value2) then
			enoughItems = "false"
		else
			enoughItems = "true"
			--getFromChest
			item.craftItem(value1)
		end
	end
end


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

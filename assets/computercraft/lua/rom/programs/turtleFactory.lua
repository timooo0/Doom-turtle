os.loadAPI("/rom/apis/item.lua")
os.loadAPI("/rom/apis/gps.lua")
os.loadAPI("/rom/apis/file.lua")
quarry = require("quarry")


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


if item.getItemDict("minecraft:iron_ore") < 7 or item.getItemDict("minecraft:redstone") < 2 or item.getItemDict("minecraft:cobblestone") < 23 or item.getItemDict("minecraft:dirt,0") < 88 or item.getItemDict("minecraft:diamond") < 3 then
	enoughItems = "false"
end

recipeComputer = {}
recipeComputer["minecraft:stone,0"] = {1,2,3,5,7,9,11}
recipeComputer["minecraft:redstone"] = {6}
recipeComputer["minecraft:glass_pane"] = {10}
--recipeComputer["computercraft:computer"] = {result}
function recipeToItemDict(recipe)
	for k, v in pairs(recipe) do
		item.storeItemDict(k,-table.getn(v))
	end
end
item.craftItem(recipeComputer)

os.loadAPI("/rom/apisFiles/file.lua")



function selectItem(name)

	anyDam = false
	if name:match("([^,]+),([^,]+)") ~= nil then
		name, dam = name:match("([^,]+),([^,]+)")
		dam = tonumber(dam)
	else
		anyDam = true
	end

	counter = 1
	for i=1,16 do
	turtle.select(i)
		if turtle.getItemCount() ~= 0 then
			if turtle.getItemDetail().name == name and (turtle.getItemDetail().damage == dam or anyDam) then
				return true
			end
		else
			counter = counter +1
		end
	end
	return false
end


--Dump one particular item, when amount = nil it defaults to all items of that type, same for no damage supplied (name = name,damage)
function dumpItem(name, amount)

	anyDam = false
	if name:match("([^,]+),([^,]+)") ~= nil then
		name, dam = name:match("([^,]+),([^,]+)")
		dam = tonumber(dam)
	else
		anyDam = true
	end

	if amount ~= nil then
		amount = tonumber(amount)
	else
		amount = 1024
	end
	toDrop = amount
	i = 1
	while toDrop > 0 and i <= 16 do
		turtle.select(i)
		i = i + 1

		if turtle.getItemCount() ~= 0 then
			if turtle.getItemDetail().name == name  and (turtle.getItemDetail().damage == dam or anyDam) then


				count = turtle.getItemCount()
				turtle.drop(math.min(toDrop,count))
				toDrop = toDrop - math.min(toDrop,count)
			end
		end
	end
end

function countItems(name)
	local count = 0

	anyDam = false
	if name:match("([^,]+),([^,]+)") ~= nil then
		name, dam = name:match("([^,]+),([^,]+)")
		dam = tonumber(dam)
	else
		anyDam = true
	end

	for i = 1, 16 do
		turtle.select(i)
		if turtle.getItemCount() ~= 0 then
			if turtle.getItemDetail().name == name and (turtle.getItemDetail().damage == dam or anyDam) then
				count = count + turtle.getItemCount()
			end
		end
	end
	return count;
end

function findChest()
	if select(2,turtle.inspect()).name == "minecraft:chest" then
		return turtle.suck, turtle.drop
	elseif select(2,turtle.inspectUp()).name == "minecraft:chest" then
		return turtle.suckUp, turtle.dropUp
	elseif select(2,turtle.inspectDown()).name == "minecraft:chest" then
		return turtle.suckDown, turtle.dropDown
	else
		print("no chest up, down or front")
	end
end

function getFromChest(name,amount)
	turtle.select(1)

	local nFound = 0
	local nStacks = math.floor(amount/64+1)
	local itemFound = false
 	amount = amount%64
	suck, drop = findChest()
	anyDam = false
	if name:match("([^,]+),([^,]+)") ~= nil then
		name, dam = name:match("([^,]+),([^,]+)")
		dam = tonumber(dam)
	else
		anyDam = true
	end
	--print(name)
	for i=1,nStacks do
		local counter = 1
		while suck() == true and counter <=16 do
			turtle.select(counter)
			counter = counter + 1

			if turtle.getItemCount() ~= 0 then

				if turtle.getItemDetail().name == name and (turtle.getItemDetail().damage == dam or anyDam) then
					itemFound = true
					break
				else
					--print("Item not found")
					itemFound = false
				end

			end

		end

		--Move stack to last available slot
		--print(i,nStacks)
		if itemFound ~= false then
			for j=16,1,-1 do
				turtle.select(j)
				if turtle.getItemCount() == 0 and counter ~= 1 then
					if i==nStacks then
						turtle.select(counter-1)
						nFound = nFound + turtle.getItemCount()
						turtle.transferTo(j,amount)
						break
					else
						turtle.select(counter-1)
						nFound = nFound + turtle.getItemCount()
						turtle.transferTo(j,64)
						break
					end
				end
			end
		end
	for i=turtle.getSelectedSlot(),1,-1 do
		turtle.select(i)
		drop()
	end
	end
return nFound
end


function itemdelivery()
	bool,data=turtle.inspect()
	if data.name == "minecraft:chest" or data.name == "minecraft:trapped_chest" then
		for inventoryslot = 2,16 do
			turtle.select(inventoryslot)
			os.sleep(2/20)
			turtle.drop()
		end
	else
		print("No Chest to drop off my items")
	end
end

function craftItem(recipe, amount)
	if amount == nil then
		amount = 1
	end

	local counter = 0
	for key,value in pairs(recipe) do
		if value[1] ~= "result" then
			getFromChest(key,table.getn(value)*amount)
			item.storeItemDict(key,-table.getn(value)*amount)
			--print(counter)
			turtle.transferTo(16-counter)
			counter = counter +1
		else
			if value[2] ~= nil then
				item.storeItemDict(key,value[2]*amount)
			else
				item.storeItemDict(key,amount)
			end
		end
	end

	for key,value in pairs(recipe) do
		--print(key)
		if key:match("([^,]+),([^,]+)") ~= nil then
			key, dam = key:match("([^,]+),([^,]+)")

		end
		if value[1] ~= "result" then
			selectItem(key)
			selection = turtle.getSelectedSlot()
			for i=1,table.getn(value) do
				turtle.select(selection)
				turtle.transferTo(value[i],amount)
			end
		end
	end
	turtle.craft()
end

function putInCraftingChest(name,amount)
	getFromChest(name,amount)
	selectItem(name)
	gps.faceLeft()
	turtle.drop()
	gps.faceRight()
end


function InvenToItemDict()
	local counter = 1
	while counter <=16 do
		turtle.select(counter)
		counter = counter + 1
		--print(turtle.getItemCount())
		if turtle.getItemCount() ~= 0 then
			itemID = turtle.getItemDetail().name .. "," .. turtle.getItemDetail().damage
			--print(itemID)
			local dataRead = fs.open("/rom/global files/itemsStructure.md", "r")
			local itemLine = 1
			while dataRead.readLine() ~= itemID do
				itemLine = itemLine + 1
			end
			file.addStore(itemLine, turtle.getItemCount(), "items.txt")
			dataRead.close()
			--print("I have found ", turtlegetItemCount(), itemID)
		end
	end
end

function slotToItemDict(slot)
	turtle.select(slot)
	print(turtle.getItemCount())
	if turtle.getItemCount() ~= 0 then
		itemID = turtle.getItemDetail().name .. "," .. turtle.getItemDetail().damage
		print(itemID)
		local dataRead = fs.open("/rom/global files/itemsStructure.md", "r")
		local itemLine = 1
		while dataRead.readLine() ~= itemID do
			itemLine = itemLine + 1
		end
		file.addStore(itemLine, turtle.getItemCount(), "items.txt")
		dataRead.close()
		--print("I have found ", turtlegetItemCount(), itemID)
	end
end
--Use name = name,damage, when no damage supplied it will default damage = 0
function storeItemDict(name, amount)

	if name:match("([^,]+),([^,]+)") ~= nil then
		nameStrip, dam = name:match("([^,]+),([^,]+)")
		dam = tonumber(dam)
	else
		nameStrip = name
		name = name .. ",0"
		dam = 0
	end

	local dataRead = fs.open("/rom/global files/itemsStructure.md", "r")
	local itemLine = 1
	while dataRead.readLine() ~= name do
		itemLine = itemLine + 1
	end
	dataRead.close()

	if amount ~= nil then
		file.addStore(itemLine, amount, "items.txt")
	else
		for i = 1,16 do
			turtle.select(i)
			if turtle.getItemCount() ~= 0 then
				if turtle.getItemDetail().name == nameStrip and (turtle.getItemDetail().damage == dam or anyDam) then
					file.addStore(itemLine, turtle.getItemCount(), "items.txt")
				end
			end
		end
	end
end

function getItemDict(name, iDontCareAboutDamage)
	local dataRead = fs.open("/rom/global files/itemsStructure.md", "r")
	local itemLine = 1
	local nameStrip = name
	local noDamName = name

	if iDontCareAboutDamage == nil then
		iDontCareAboutDamage = false
	end

	anyDam = false
	if name:match("([^,]+),([^,]+)") == nil then
		name = name .. ",0"
	end

	while dataRead.readLine() ~= name do
		--print(itemLine)
		itemLine = itemLine + 1
	end
	count = file.get(itemLine,"items.txt")
	--print(count)
	--Extra for if you do not care about damage
	if iDontCareAboutDamage == true then
		while nameStrip == noDamName do
			--print(itemLine)
			itemLine = itemLine + 1
			nameStrip, dam = dataRead.readLine():match("([^,]+),([^,]+)")
			count = file.get(itemLine,"items.txt")+count

		end
		--Backwards, but ay it works
		count = count-file.get(itemLine,"items.txt")
	end
	return count
end

--Support Function for checkAndCraftBranch
function smeltForCraft(name,amount)
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

--Support Function for craftItemBranch
--Name is what you want to Craft, Amount is how many, and CraftingChest whether you want to place it into the craftingchest after it is done
function checkAndCraftBranch(name, amount, craftingChest)
	--Initialization
	if craftingChest == nil then
		craftingChest = 0
	end

	recipeTable = recipe.referenceTable[name]
	if recipeTable == nil then
		print("true666")
		return true
	end
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
			smeltForCraft(key2, 8)
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

--This is the main function to use when crafting something
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


--Support Function for boodschappen
--Checks the boodschappen for a single recipe
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

--Check the boodschappen necassary to craft an entire branch of an item
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

--WARNING this function completely wipes the turtle's item.txt file
--Then it fills the item.txt with the items in the chest infront/left of him
function resetItemCounts()
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
end

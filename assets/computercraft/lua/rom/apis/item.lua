os.loadAPI("/rom/apis/file.lua")



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

	local nStacks = math.floor(amount/64+1)
	amount = amount%64
	suck, drop = findChest()
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
		while suck() == true and counter <=16 do
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
			if turtle.getItemCount() == 0 and counter ~= 1 then
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
		drop()
	end
	end


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
		if value[1] ~= result then
			getFromChest(key,table.getn(value)*amount)
			item.storeItemDict(key,-table.getn(value)*amount)
			print(counter)
			turtle.transferTo(16-counter)
			counter = counter +1
		else
			item.storeItemDict(key,1*amount)
		end
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
			turtle.transferTo(value[i],amount)
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
end

function SlotToItemDict(slot)
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

function getItemDict(name)
	local dataRead = fs.open("/rom/global files/itemsStructure.md", "r")
	local itemLine = 1

	anyDam = false
	if name:match("([^,]+),([^,]+)") == nil then
		name = name .. ",0"
	end

	while dataRead.readLine() ~= name do
		--print(itemLine)


		itemLine = itemLine + 1
	end
	return file.get(itemLine,"items.txt")
end

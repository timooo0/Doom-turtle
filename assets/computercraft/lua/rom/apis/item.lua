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

function getFromChest(name,amount)
	turtle.select(2)
	local counter = 2
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
		--print(name,turtle.getItemDetail().damage==dam)
		if turtle.getItemCount() ~= 0 then
			if turtle.getItemDetail().name == name and (turtle.getItemDetail().damage == dam or anyDam) then
				local findanything = true
				break
			end
		end
	end
	if findanythings ~= true then
		counter = 17
	end
	for i=2,counter-2 do
		turtle.select(i)
		turtle.drop()
	end
	turtle.select(counter-1)
	turtle.transferTo(2)
	turtle.select(2)
	if amount ~= 0 and turtle.getItemCount() >= amount then
		turtle.drop(turtle.getItemCount()-amount)
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

function putInCraftingChest(name,amount)
	getFromChest(name,amount)
	self.selectItem(name)
	self.faceLeft()
	turtle.drop()
	self.faceRight()
end
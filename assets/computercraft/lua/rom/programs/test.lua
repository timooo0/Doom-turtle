self = require("self")
buildTreeFarm = require("buildTreeFarm")
startBase = require("startBase")
print("test")
buildTreeFarm.Function()

-- function itemdelivery()								
	-- bool,data=turtle.inspect()
	-- if data.name == "minecraft:chest" or data.name == "minecraft:trapped_chest" then
		-- for inventoryslot = 1,16 do
			-- turtle.select(inventoryslot)
			-- os.sleep(2/20)
			-- turtle.drop()
		-- end
	-- else
		-- print("No Chest to drop off my items")
	-- end
-- end

-- fs.delete("/items.txt")

-- if fs.exists("/items.txt") == false then
	-- fs.copy("/rom/global files/itemsTemplate.txt","/items.txt")
-- end
-- turtle.refuel(32)
-- --self.changeStore(2,114,"items.txt")

-- function InvenToItemDict()
	-- local counter = 1
	-- while counter <=16 do
		-- turtle.select(counter)
		-- counter = counter + 1
		-- print(turtle.getItemCount())
		-- if turtle.getItemCount() ~= 0 then
			-- itemID = turtle.getItemDetail().name .. "," .. turtle.getItemDetail().damage
			-- print(itemID)
			-- local dataRead = fs.open("/rom/global files/itemsStructure.md", "r")
			-- local itemLine = 1
			-- while dataRead.readLine() ~= itemID do
				-- itemLine = itemLine + 1
			-- end
			-- self.addStore(itemLine, turtle.getItemCount(), "items.txt")
			-- dataRead.close()
			-- --print("I have found ", turtlegetItemCount(), itemID)
		-- end
	-- end
-- end

-- function SlotToItemDict(slot)
	-- turtle.select(slot)
	-- print(turtle.getItemCount())
	-- if turtle.getItemCount() ~= 0 then
		-- itemID = turtle.getItemDetail().name .. "," .. turtle.getItemDetail().damage
		-- print(itemID)
		-- local dataRead = fs.open("/rom/global files/itemsStructure.md", "r")
		-- local itemLine = 1
		-- while dataRead.readLine() ~= itemID do
			-- itemLine = itemLine + 1
		-- end
		-- self.addStore(itemLine, turtle.getItemCount(), "items.txt")
		-- dataRead.close()
		-- --print("I have found ", turtlegetItemCount(), itemID)
	-- end
-- end
-- --Use name = name,damage
-- function ItemtoItemDict(name, amount)

	-- if name:match("([^,]+),([^,]+)") ~= nil then
		-- nameStrip, dam = name:match("([^,]+),([^,]+)")
		-- dam = tonumber(dam)
	-- else
		-- nameStrip = name
		-- name = name .. ",0"
		-- dam = 0
	-- end
	
	-- local dataRead = fs.open("/rom/global files/itemsStructure.md", "r")
	-- local itemLine = 1
	-- while dataRead.readLine() ~= name do
		-- itemLine = itemLine + 1
	-- end
	-- dataRead.close()
	
	-- if amount ~= nil then
		-- self.addStore(itemLine, amount, "items.txt")
	-- else
		-- for i = 1,16 do
			-- turtle.select(i)
			-- if turtle.getItemCount() ~= 0 then
				-- if turtle.getItemDetail().name == nameStrip and (turtle.getItemDetail().damage == dam or anyDam) then
					-- self.addStore(itemLine, turtle.getItemCount(), "items.txt")
				-- end
			-- end
		-- end
	-- end
-- end




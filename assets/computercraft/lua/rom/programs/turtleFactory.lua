self = require("self")
quarry = require("quarry")

if self.get(20) < 7 or self.get(21) < 2 or self.get(23) < 23 or self.get(25) < 88 or self.get(30) < 3 then
	enoughItems = "false"
end

self.store(16, enoughItems)

--if enoughItems == "true" then
	--make more turtles
--end
function itemsget(linenumber)
	dataRead = fs.open("items.txt", "r")
	for line = 1, linenumber-1 do
		dataRead.readLine()
	end
	dataget = dataRead.readLine()
	dataRead.close() 
	if tonumber(dataget) == nil then
		return dataget
	else
		return tonumber(dataget)
	end
end


function itemsstore(linenumber, msg)
	
	dataRead = fs.open("items.txt", "r")
	dataget = {}
	line = 1 
	repeat
		dataget[line] = dataRead.readLine()
		line = line + 1
		
	until dataget[line-1] == nil
	dataRead.close()
	dataWrite = fs.open("items.txt", "w")
	line = 1
	while dataget[line] ~= nil do
		if line == linenumber then
			dataWrite.writeLine(msg)
		else
			dataWrite.writeLine(dataget[line])
		end
		
		line = line + 1
	end
	dataWrite.close()
	
	return datastore
end


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












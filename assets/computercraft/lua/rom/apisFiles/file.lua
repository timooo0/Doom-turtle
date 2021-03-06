--Use tonumber(self.get(linenumber)) to make sure it is a number
function get(linenumber, filepath)

	if filepath == nil then
		filepath = "data.txt"
	end

	local dataRead = fs.open(filepath, "r")

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

function store(linenumber, msg, filepath)

	if filepath == nil then
		filepath = "data.txt"
	end

	local dataRead = fs.open(filepath, "r")

	dataget = {}
	line = 1

	repeat
		dataget[line] = dataRead.readLine()
		line = line + 1

	until dataget[line-1] == nil

	dataRead.close()
	dataWrite = fs.open(filepath, "w")
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
end

function addStore(linenumber, diff, filepath)
	store(linenumber, get(linenumber, filepath)+tonumber(diff), filepath)
end

function checkShutdown()
	if fs.open("/rom/global files/shutdown.txt","r") == "true" then
		os.sleep(10000)
	end
end


--ChunkMap Functions

function mapRead(xPos, zPos)

	xChunk = math.floor(xPos/16)
	zChunk = math.floor(zPos/16)

	local mapLine = get(math.abs(xChunk)+1, "map.txt")

	--Corner:
	local corner = {}

	--Determine the quadrant:
	if xChunk >= 0 then
		if zChunk >= 0 then
			quadrant = 1 -- x+ z+
		else
			quadrant = 3 -- x+ z-
		end
	else
		if zChunk >= 0 then
			quadrant = 2 -- x- z+
		else
			quadrant = 4 -- x- z-
		end
	end

	--Map table
	local map = {}

	for match in mapLine:gmatch "{(.-)}" do
		table.insert(corner, "{"..match.."}")
	end

	mapLength = 0
	for match in corner[quadrant]:gmatch "{?(.-)," do
		table.insert(map, match)
		mapLength = mapLength + 1
		--print(match)
	end


	--Add new entries to the map
	local repl = corner[quadrant]

	for i = 1, math.abs(zChunk)-mapLength do
		mapLine = string.gsub(mapLine, repl, string.sub(repl,0,-2).."0,".."}")
		repl = string.sub(repl,0,-2).."0,".."}"
		print(repl)
	end
	store(math.abs(xChunk)+1, mapLine, "map.txt")

	--The result of the requisted coordinates:
	if math.abs(zChunk) > mapLength then
		return 0
	else
		return map[math.abs(zChunk)+1]
	end

end

function mapWrite(xPos, zPos, msg)

	xChunk = math.floor(xPos/16)
	zChunk = math.floor(zPos/16)

	local mapLine = get(math.abs(xChunk)+1, "map.txt")

	--Corner:
	local corner = {}

	--Determine the quadrant:
	if xChunk >= 0 then
		if zChunk >= 0 then
			quadrant = 1 -- x+ z+
		else
			quadrant = 3 -- x+ z-
		end
	else
		if zChunk >= 0 then
			quadrant = 2 -- x- z+
		else
			quadrant = 4 -- x- z-
		end
	end

	--Map table
	local map = {}

	for match in mapLine:gmatch "{(.-)}" do
		table.insert(corner, "{"..match.."}")
	end

	mapLength = 0
	for match in corner[quadrant]:gmatch "{?(.-)," do
		table.insert(map, match)
		mapLength = mapLength + 1
		--print(match)
	end
	--Add new entries to the map
	local repl = corner[quadrant]
	if math.abs(zChunk) > mapLength-1 then
		for i = 1, math.abs(zChunk)-mapLength-1 do
			corner[quadrant] = string.gsub(corner[quadrant], repl, string.sub(repl,0,-2).."0,".."}")
			repl = string.sub(repl,0,-2).."0,".."}"
			--print(repl)
		end
		--The msg gets inserted
		--print(mapLine)
		corner[quadrant] = string.gsub(corner[quadrant], repl, string.sub(repl,0,-2)..msg..",}")
		repl = string.sub(repl,0,-2)..msg..",}"
		--print(repl)
	else
		print(repl)
		print(corner[quadrant])
		--Actually replacing the the with the msg
		corner[quadrant] = string.gsub(corner[quadrant], repl, string.sub(repl,0,math.abs(zChunk)+1)..","..msg..string.sub(repl,math.abs(zChunk)+4,-1))
		print(corner[quadrant])
		print("mapLining")
	end
	--map[math.abs(zChunk)+1]
	store(math.abs(xChunk)+1, corner[1]..corner[2]..corner[3]..corner[4], "map.txt")
end

function getTable(file)

	local fileTable = {}
	local tableInfo = {}
	local dataRead = fs.open(file,"r")
	local dim = tonumber(dataRead.readLine())

	if dim >= 1 then
		tableInfo["nRow"] = dataRead.readLine()
	end
	if dim >= 2 then
		tableInfo["nColumn"] = dataRead.readLine()
	end
	if dim >= 3 then
		tableInfo["nHeight"] = dataRead.readLine()
	end

	for k,v in pairs(tableInfo) do
		tableInfo[k] = tonumber(v)
	end

	if dim == 1 then
		for i=1,tableInfo["nRow"] do
			fileTable[i] = dataRead.readLine()
			if tonumber(fileTable[i]) ~= nil then
				fileTable[i] = tonumber(fileTable[i])
			end
		end
	end

	if dim == 2 then
		for i=1,tableInfo["nRow"] do
			local row = {}
			for j=1, tableInfo["nColumn"] do
				row[j] = dataRead.readLine()
				if tonumber(row[j]) ~= nil then
					row[j] = tonumber(row[j])
				end
			end
			fileTable[i] = row
		end
	end

	if dim == 3 then
		for i=1,tableInfo["nRow"] do
			local row = {}
			for j=1, tableInfo["nColumn"] do
				local column = {}
				for k=1, tableInfo["nHeight"] do
					column[k] = dataRead.readLine()
					if tonumber(column[k]) ~= nil then
						column[k] = tonumber(column[k])
					end
				end
				row[j] = column
			end
			fileTable[i] = row
		end
	end
	dataRead.close()
	return fileTable
end

function storeTable(fileTable, dim, file)

	local dataWrite = fs.open(file,"w")

	dataWrite.writeLine(dim)
	if dim >= 1 then
		nRow = table.getn(fileTable)
		dataWrite.writeLine(nRow)
	end
	if dim >= 2 then
		nColumn = table.getn(fileTable[1])
		dataWrite.writeLine(nColumn)
	end
	if dim >= 3 then
		nHeight = table.getn(fileTable[1][1])
		dataWrite.writeLine(nHeight)
	end

	if dim == 1 then
		for i=1,nRow do
			dataWrite.writeLine(fileTable[i])
		end
	end

	if dim == 2 then
		for i=1,nRow do
			for j=1, nColumn do
				dataWrite.writeLine(fileTable[i][j])
			end
		end
	end

	if dim == 3 then
		for i=1,nRow do
			for j=1, nColumn do
				for k=1, nHeight do
					dataWrite.writeLine(fileTable[i][j][k])
				end
			end
		end
	end
	dataWrite.close()
end

function connect(protocol, position)
	rednet.open(position)
	rednet.broadcast(protocol)
	while rednet.receive(protocol,5) == nil do
	  rednet.broadcast(protocol)
	end

	print("We got contact")
end

function sendFile(file, protocol)

	dataRead = fs.open(file,"r")
	message = dataRead.readLine()
	while message ~= nil do
		sleep(0.01)
	  print("sending: " .. message)
	  rednet.broadcast(message,protocol)
	  message = dataRead.readLine()
	end

	rednet.broadcast("close",protocol)
	dataRead.close()
end

function receiveFile(file, protocol)

	local dataWrite = fs.open(file,"w")
  message = select(2,rednet.receive(protocol))

  while message ~= "close" do
		print("receiving: " .. message)
    dataWrite.writeLine(message)
    message = select(2,rednet.receive(protocol))
  end

  dataWrite.close()
end

function clientUpdate(protocol)
	rednet.broadcast("update",protocol)
	message = select(2,rednet.receive(protocol))

	if message == "true" then
		receiveFile("mapChanges.txt",protocol)
		applyMapChanges("chestMap.txt","mapChanges.txt",-1)
	else
		return false
	end
end

function serverUpdate(changes,protocol)
	while select(2,rednet.receive(protocol)) ~= "update" do os.sleep(0.1) end
	os.sleep(0.5)
	if fs.exists(changes) then
		rednet.broadcast("true",protocol)
		sendFile(changes,protocol)
		fs.delete(changes)
	else
		rednet.broadcast("false", protocol)
	end
end

function applyMapChanges(map,changes,modify)
	if type(map) == "string" then
		map = getTable(map)
	end

	if type(changes) == "string" then
		changes = getTable(changes)
	end
print(type(map),type(changes))
	for i=1,table.getn(changes) do
		map[changes[i][1]][changes[i][2]] = {changes[i][3],map[changes[i][1]][changes[i][2]][2]+modify*changes[i][4]}
	end
	storeTable(map,3,"chestMap.txt")
end

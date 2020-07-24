self = require("self")


fs.delete("/map.txt")


if fs.exists("/map.txt") == false then
	fs.copy("/rom/global files/mapTemplate.txt","/map.txt")
end

function mapRead(xPos, zPos)

	xChunk = math.floor(xPos/16)
	zChunk = math.floor(zPos/16)

	local mapLine = self.get(math.abs(xChunk)+1, "map.txt")

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
	self.store(math.abs(xChunk)+1, mapLine, "map.txt")

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

	local mapLine = self.get(math.abs(xChunk)+1, "map.txt")

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
	if math.abs(zChunk) > mapLength then
		for i = 1, math.abs(zChunk)-mapLength-1 do
			mapLine = string.gsub(mapLine, repl, string.sub(repl,0,-2).."0,".."}")
			repl = string.sub(repl,0,-2).."0,".."}"
			print(repl)
		end
		--The msg gets inserted
		mapLine = string.gsub(mapLine, repl, string.sub(repl,0,-2)..msg..",}")
		repl = string.sub(repl,0,-2)..msg..",}"
		print(repl)
	else
		mapLine = string.gsub(mapLine, repl, string.sub(repl,0,math.abs(zChunk)+1)..","..msg..string.sub(repl,math.abs(zChunk)+2,-1))
	end

	self.store(math.abs(xChunk)+1, mapLine, "map.txt")

end

print(mapRead(700,10))

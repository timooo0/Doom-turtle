self = require("self")

route = {
2, 2, 2, 2, 2, 2, 2, 2, 2,
3, 3, 3,
0, 0, 0, 0, 0, 0,
3, 3, 3,
2, 2, 2, 2, 2, 2,
3, 3, 3,
0, 0, 0, 0, 0, 0, 0, 0, 0,
1, 1, 1, 1, 1, 1, 1, 1, 1, 1
}

function startup()
	if turtle.inspectUp() then
		while turtle.inspectUp() do
			self.moveup()
		end

		local inTree = tonumber(self.get(27))
		local direction = tonumber(self.get(28))
		if inTree == 1 then
			self.face(direction)
			self.faceAround()
			self.move()
		end

	end
	for i=1,self.get(2)-self.get(6) do
		self.movedown()
	end
end



function selectItem(name)
	for i=1,16 do
		turtle.select(i)
		if turtle.getItemCount() ~= 0 then
			if turtle.getItemDetail().name == name then
				return true
			end
		end
	end
	return false
end

function rotateCut()
	for i=1,4 do
		if select(2,turtle.inspect()).name ~= "minecraft:sapling" then
			self.breakfront()
		end
	self.faceLeft()
	end
end

function plant()
	if selectItem("minecraft:sapling") then
		turtle.place()
	end
end

function cutTree()

	local totalUp = 0
	self.move()
	self.store(27,1)
	self.store(28,self.get(4))

	while turtle.inspectUp() do
		self.moveup()
		totalUp = totalUp + 1
		rotateCut()
	end

	self.faceLeft()
	self.faceLeft()
	self.move()
	self.store(27,0)
	
	for i=0,totalUp-1 do
		rotateCut()
		self.movedown()
	end
	
	self.faceLeft()
	self.faceLeft()

	
	plant()
end


function checkTree()
self.faceLeft()
	if select(2,turtle.inspect()).name == "minecraft:log" then
		cutTree()
	else
		if math.random() < 0.05 then
			plant()
		end
	end
	self.faceLeft()
	self.faceLeft()
	if select(2,turtle.inspect()).name == "minecraft:log" then
		cutTree()
	else
		if math.random() < 0.05 then
			plant()
		end
	end
	self.faceLeft()

end

function checkShutdown()
	if self.get(24) == "1" then
		os.shutdown()
	end
end

startup()
index = tonumber(self.get(26))
while true do
	checkShutdown()
	checkTree()
	self.face(route[index])
	self.move()
	index = index + 1
	self.store(26, index)
	if index == table.getn(route) then
		index = 1
	end
end

local newTreeFarm = {}
function newTreeFarm.Function()

os.loadAPI("/rom/apis/item.lua")
os.loadAPI("/rom/apis/gps.lua")
os.loadAPI("/rom/apis/file.lua")

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
	if select(2,turtle.inspectDown()).name == "minecraft:chest" then
		for i=1,4 do
			file.store(i+4,file.get(i))
		end
	end
	if turtle.inspectUp() then
		while turtle.inspectUp() do
			gps.moveUp()
		end

		local inTree = file.get(27)
		local direction = file.get(28)
		if inTree == 1 then
			gps.face(direction)
			gps.faceAround()
			gps.move()
		end

	end
	for i=1,file.get(2)-file.get(6) do
		gps.moveDown()
	end
end


function rotateCut()
	for i=1,4 do
		if select(2,turtle.inspect()).name ~= "minecraft:sapling" then
			gps.breakFront()
		end
	gps.faceLeft()
	end
end

function plant()
	if item.selectItem("minecraft:sapling") then
		turtle.place()
	end
end

function cutTree()

	local totalUp = 0
	gps.move()
	file.store(27,1)
	file.store(28,file.get(4))

	while turtle.inspectUp() do
		gps.moveUp()
		totalUp = totalUp + 1
		rotateCut()
	end

	gps.faceLeft()
	gps.faceLeft()
	gps.move()
	file.store(27,0)
	
	for i=0,totalUp-1 do
		rotateCut()
		gps.moveDown()
	end
	
	gps.faceLeft()
	gps.faceLeft()

	
	plant()
end


function checkTree()
gps.faceLeft()
	if select(2,turtle.inspect()).name == "minecraft:log" then
		cutTree()
	else
		if math.random() < 0.05 then
			plant()
		end
	end
	gps.faceLeft()
	gps.faceLeft()
	if select(2,turtle.inspect()).name == "minecraft:log" then
		cutTree()
	else
		if math.random() < 0.05 then
			plant()
		end
	end
	gps.faceLeft()

end


startup()
index = file.get(26)
while true do
	file.checkShutdown()
	checkTree()
	gps.face(route[index])
	gps.move()
	index = index + 1
	file.store(26, index)
	if index == table.getn(route) then
		index = 1
	end
end
end

return newTreeFarm
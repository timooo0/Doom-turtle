os.loadAPI("/rom/apisFiles/file.lua")

highWayLevelMin = 60
highWayLevelMax = highWayLevelMin + 3

--gives the y level in which each travel direction goes
levelDirection = {}
for i=0,3 do
	levelDirection[i+1] = highWayLevelMin+i
end


function moveBase()
	--Gravel Shield for forward digging and the digging + lava destroyer
		if turtle.detect() then
				local name = select(2,turtle.inspect()).name

				while name ~= "minecraft:flowing_water" and name ~= "minecraft:lava" and name ~= "minecraft:water" and name ~= "minecraft:flowing_lava" and turtle.inspect()~= false do					--Gravel destroyer/Liquid Ignorer
						turtle.dig()
						name = select(2,turtle.inspect()).name
				end

		end

		if turtle.forward()==false then																	--Mob Shield
				while turtle.forward()==false do															--Attack until Mob is gone
						turtle.attack()
				end
		end
		--Imports the previous Coordinates
		x = file.get(1)
		z = file.get(3)
		facing = file.get(4)

		--Checks which direction coordinates to update based on where the turtle is facing
		if facing == 0 then
			z = z-1
		elseif facing == 1 then
			x = x+1
		elseif facing == 2 then
			z = z+1
		elseif facing == 3 then
			x = x-1
		end

		--Updates to the new Coordinates
		file.store(1, x)
		file.store(3, z)
end

function move(distance)
	if distance == nil then
		moveBase()
	else
		for i = 1, distance do
			moveBase()
		end
	end
end

function moveBack(distance)
	faceAround()
	move(distance)
	faceAround()
end

--Function for moving 1 block up
function moveUpBase()
	if turtle.detectUp() then
		--Falling blocks break on the turtle, so no need to worry about gravel/sand
		turtle.digUp()
	end
	if turtle.up()==false then
		while turtle.up()==false do
			turtle.attackUp()
		end
	end

	--Imports the previous Coordinates
	y = file.get(2)

	--Updates the y coordinates
	y = y + 1

	--Updates to the new Coordiantes
	file.store(2, y)

end

function moveUp(distance)
	if distance == nil then
		moveUpBase()
	else
		for i = 1, distance do
			moveUpBase()
		end
	end
end

--Function for moving 1 block down
function moveDownBase()
	if turtle.detectDown() then
		turtle.digDown()
	end
	if turtle.down()==false then
		while turtle.down()==false do
			turtle.attackDown()
		end
	end

	--Imports the previous Coordinates
	y = file.get(2)

	--Updates the y coordinates
	y = y - 1

	--Updates to the new Coordiantes
	file.store(2, y)

end

function moveDown(distance)
	if distance == nil then
		moveDownBase()
	else
		for i = 1, distance do
			moveDownBase()
		end
	end
end

--This table is to print facing as a north/south/west/east direction:
facingString = {}
facingString[0] = "north"
facingString[1] = "east"
facingString[2] = "south"
facingString[3] = "west"

--Turn Functions:
--TurnLeft
function faceLeft()
	facing = (file.get(4) - 1) % 4
	file.store(4, facing)
	turtle.turnLeft()
	--print(facingString[facing])
end

--TurnRight
function faceRight()

	facing = (file.get(4) + 1) % 4
	file.store(4, facing)
	turtle.turnRight()
	--print(facingString[facing])
end
--TurnAround
function faceAround()
	faceLeft()
	faceLeft()
end
--Face towards a specific direction:
function face(direction)
	direction = tonumber(direction)
	while file.get(4) ~= direction do
		faceLeft()
	end
end

--Functions for Breaking in different directions

--Digging down
function breakDown()
	if turtle.detectDown() == true then
		turtle.digDown()
	end
end

--Digging up
function breakUp()
	if turtle.detectUp() == true then
		turtle.digUp()
	end
end

--Digging in front
function breakFront()
	if turtle.detect() then
			local name = select(2,turtle.inspect()).name
			--For breaking gravel/sand
			while name ~= "minecraft:flowing_water" and name ~= "minecraft:lava" and name ~= "minecraft:water" and name ~= "minecraft:flowing_lava" and turtle.inspect()~= false do	--Gravel destroyer/Liquid Ignorer
					turtle.dig()
					name = select(2,turtle.inspect()).name
			end

	end
end

--Move to Absolute coordinates in the chunk
function moveChunk(xpos, zpos)

	x = file.get(1)
	xDistancetoCorner = x % 16
	if xDistancetoCorner > xpos then
		face(3.0)
		move(xDistancetoCorner-xpos)
	else
		face(1.0)
		move(xpos-xDistancetoCorner)
	end

	z = file.get(3)
	zDistancetoCorner = z % 16
	if zDistancetoCorner > zpos then
		face(0.0)
		move(zDistancetoCorner-zpos)
	else
		face(2.0)
		move(zpos-zDistancetoCorner)
	end


end

--Move to Aboslute coordinates
function moveAbs(xpos, ypos, zpos)

	x = file.get(1)
	if x > xpos then
		face(3.0)
		move(x-xpos)
	else
		face(1.0)
		move(xpos-x)
	end

	y = file.get(2)
	if y > ypos then
		moveDown(y-ypos)
	else
		moveUp(ypos-y)
	end


	z = file.get(3)
	if z > zpos then
		face(0.0)
		move(z-zpos)
	else
		face(2.0)
		move(zpos-z)
	end

end

function nextChunk(direction)
	xChunkPos = file.get(1)%16
	zChunkPos = file.get(3)%16
	if direction == 0 then
		moveChunk(xChunkPos,0)
	elseif direction == 1 then
		moveChunk(15,zChunkPos)
	elseif direction == 2 then
		moveChunk(xChunkPos,15)
	elseif direction == 3 then
		moveChunk(0,zChunkPos)
	end
	print(file.get(1)%16,file.get(3)%16)
	face(direction)
	move()
end

function highWayUp(chunkX,chunkZ)
	if (chunkX%4) == 3 then
		moveChunk(chunkX+1,chunkZ+chunkZ%2)
	elseif (chunkX%4) == 1 then
		moveChunk(chunkX-1,chunkZ+chunkZ%2)
	else
		moveChunk(chunkX+chunkX%4,chunkZ+chunkZ%2)
	end
end

function highWayDown(chunkX,chunkZ)
	if ((chunkX+2)%4) == 3 then
		moveChunk(chunkX+1,chunkZ+chunkZ%2)
	elseif ((chunkX+2)%4) == 1 then
		moveChunk(chunkX-1,chunkZ+chunkZ%2)
	else
		moveChunk(chunkX+(chunkX+2)%4,chunkZ+chunkZ%2)
	end
end

function columnUp(direction)
	--gets from the column to the lane
	moveUp(levelDirection[direction+1]-file.get(2))

	face((direction+1)%4)
	move()
	faceLeft()
end

function columnDown(direction)
	--gets from the column to the lane
	moveDown(file.get(2)-levelDirection[direction+1])

	face((direction+1)%4)
	move()
	faceLeft()
end

function getOnHighwWay(direction)
	local currentX = file.get(1)
	local currentY = file.get(2)
	local currentZ = file.get(3)

	--chunk coordiantes
	local chunkX = currentX%16
	local chunkY = currentY%16
	local chunkZ = currentZ%16

	--Check if the turtle is on the highway, if not move there
	if highWayLevelMin-currentY > 1 then
		--go to the correct y level
		print("moving [up] towards the correct y level")
		moveUp(highWayLevelMin-currentY-1)

		--Move towards an up column
		print("moving to [up] column")
		highWayUp(chunkX,chunkZ)

		--move towards the correct lane level
		print("go to the direction level")
		columnUp(direction)


	elseif highWayLevelMax - currentY < 0 then
		--go to the correct y level
		print("moving [down] towards the correct y level")
		moveDown(currentY-highWayLevelMax-1)

		--Move towards an down column
		print("go to [down] column")
		highWayDown(chunkX,chunkZ)

		--move towards the correct lane level
		print("go to the direction level")
		columnDown(direction)


	else
		print("Already on the highway")
		--break
	end

end

function switchLane(direction)

	if levelDirection[direction+1] < file.get(2) then
		--go into the down column
		highWayDown(file.get(1)%16,file.get(3)%16)

		--go to the new lane
		columnDown(direction)

	elseif levelDirection[direction+1] > file.get(2) then
		--go into the up column
		highWayUp(file.get(1)%16,file.get(3)%16)

		--go to the new lane
		columnUp(direction)

	else
		print("you are an idiot why are you calling this function")
	end
end

function exitHighWay()
	--go to the down column
	highWayDown(file.get(1)%16,file.get(3)%16)

	--exit the down highway layer
	moveDown(highWayLevelMin-file.get(2)+1)
end








--Move in a square
function square(a)

	for j=0,4 do
		if j==0 then

			move()
			turtle.suck()
			faceLeft()
			turtle.suck()
		else

		for i=1,a do
			move()
			turtle.suck()
		end

		faceLeft()
		turtle.suck()

		for i=1,a do
			move()
			turtle.suck()
		end
		end
	end
	faceRight()
	turtle.suck()
end

function buildTemplate(template, material)
	gps.moveChunk(0,0)
	gps.face(1)

	for i=1,16 do
		for j=1,16 do
			print(i,j)
			if template[i][j] == 1 then
				item.selectItem(material)
				turtle.placeDown()
			end
			if j ~= 16 then
			gps.move()
			end
		end
		if i~=16 and j~= 16 then
			if i%2 == 1 then
			gps.faceRight()
			gps.move()
			gps.faceRight()
			else
			gps.faceLeft()
			gps.move()
			gps.faceLeft()

			end
		end
	end
end

--module("moveModule", package.seeall)
local self = {}

--Use tonumber(self.get(linenumber)) to make sure it is a number
function self.get(linenumber, filepath)
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


function self.store(linenumber, msg, filepath)
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
	
	return datastore
end

function self.addStore(linenumber, diff, filepath)
	self.store(linenumber, self.get(linenumber, filepath)+tonumber(diff), filepath)
end

--Function for moving one block forward
function move()
	--Gravel Shield for forward digging and the digging + lava destroyer
		if turtle.detect() then
				bool1,data1=turtle.inspect()
				
				while data1.name ~= "minecraft:flowing_water" and data1.name ~= "minecraft:lava" and data1.name ~= "minecraft:water" and data1.name ~= "minecraft:flowing_lava" and turtle.inspect()~= false do					--Gravel destroyer/Liquid Ignorer
						turtle.dig()
						bool1,data1=turtle.inspect()
				end
				
		end
		if turtle.forward()==false then																	--Mob Shield
				while turtle.forward()==false do															--Attack until Mob is gone
						turtle.attack()																			
				end
		end
		--Imports the previous Coordinates
		x = tonumber(self.get(1))
		z = tonumber(self.get(3))
		facing = tonumber(self.get(4))

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
		self.store(1, x)
		self.store(3, z)

		--Prints the current Coords
		--print(tonumber(self.get(1)))
		--print(tonumber(self.get(2)))
		--print(tonumber(self.get(3)))
end

function self.move(distance)
	if distance == nil then
		move()
	else
		for i = 1, distance do
			move()
		end
	end
end

--Function for moving one block forward
function moveback()
	self.faceAround()
	self.move()
	self.faceAround()
end

function self.moveback(distance)
	if distance == nil then
		moveback()
	else
		for i = 1, distance do
			moveback()
		end
	end
end


--Function for moving 1 block up
function moveup()
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
	y = tonumber(self.get(2))

	--Updates the y coordinates
	y = y + 1

	--Updates to the new Coordiantes
	self.store(2, y)

	--Prints the current Coords
	--print(tonumber(self.get(1)))
	--print(tonumber(self.get(2)))
	--print(tonumber(self.get(3)))
end

function self.moveup(distance)
	if distance == nil then
		moveup()
	else
		for i = 1, distance do
			moveup()
		end
	end
end

--Function for moving 1 block down
function movedown()
	if turtle.detectDown() then
		turtle.digDown()
	end
	if turtle.down()==false then
		while turtle.down()==false do
			turtle.attackDown()
		end
	end
		
	--Imports the previous Coordinates
	
	y = tonumber(self.get(2))

	--Updates the y coordinates
	y = y - 1

	--Updates to the new Coordiantes
	self.store(2, y)

	--Prints the current Coords
	--print(tonumber(self.get(1)))
	--print(tonumber(self.get(2)))
	--print(tonumber(self.get(3)))
end

function self.movedown(distance)
	if distance == nil then
		movedown()
	else
		for i = 1, distance do
			movedown()
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
function self.faceLeft()
	facing = (self.get(4) - 1) % 4
	self.store(4, facing)
	turtle.turnLeft()
	--print(facingString[facing])
end
--TurnRight
function self.faceRight()
	
	facing = (self.get(4) + 1) % 4
	self.store(4, facing)
	turtle.turnRight()
	--print(facingString[facing])
end
--TurnAround
function self.faceAround()
	self.faceLeft()
	self.faceLeft()
end
--Face towards a specific direction:
function self.face(direction)
	direction = tonumber(direction)
	while facing ~= direction do
		self.faceLeft()
	end
end


--Functions for Breaking in different directions

--Digging down
function self.breakdown()
	if turtle.detectDown() == true then
		turtle.digDown()
	end
end

--Digging up
function self.breakup()
	if turtle.detectUp() == true then
		turtle.digUp()
	end
end

--Digging in front
function self.breakfront()	
	if turtle.detect() then
			bool1,data1=turtle.inspect()
			--For breaking gravel/sand
			while data1.name ~= "minecraft:flowing_water" and data1.name ~= "minecraft:lava" and data1.name ~= "minecraft:water" and data1.name ~= "minecraft:flowing_lava" and turtle.inspect()~= false do					--Gravel destroyer/Liquid Ignorer
					turtle.dig()
					bool1,data1=turtle.inspect()
			end
			
	end
end
--Move to Absolute coordinates in the chunk
function self.moveChunk(xpos, zpos)

	x = tonumber(self.get(1))
	xDistancetoCorner = x % 16
	if xDistancetoCorner > xpos then
		self.face(3.0)
		self.move(xDistancetoCorner-xpos)
	else
		self.face(1.0)
		self.move(xpos-xDistancetoCorner)
	end
	
	z = tonumber(self.get(3))
	zDistancetoCorner = z % 16
	if zDistancetoCorner > zpos then
		self.face(0.0)
		self.move(zDistancetoCorner-zpos)
	else
		self.face(2.0)
		self.move(zpos-zDistancetoCorner)
	end

	
end	
--Move to Aboslute coordinates
function self.moveabs(xpos, ypos, zpos)

	x = tonumber(self.get(1))
	if x > xpos then
		self.face(3.0)
		self.move(x-xpos)
	else
		self.face(1.0)
		self.move(xpos-x)
	end
	
	y = tonumber(self.get(2))
	if y > ypos then
		self.movedown(y-ypos)
	else
		self.moveup(ypos-y)
	end
	
	
	z = tonumber(self.get(3))
	if z > zpos then
		self.face(0.0)
		self.move(z-zpos)
	else
		self.face(2.0)
		self.move(zpos-z)
	end
	
end	

function self.getFromChest(name,amount)
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

--Check all the items, name = name,damage when no damage supplied it will count every name regardless of damage
function self.countItems(name)
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

--Dump one particular item, when amount = nil it defaults to all items of that type, same for no damage supplied (name = name,damage)
function self.dumpItem(name, amount)

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
--Select a particular item, no damage specified means any damage.
function self.selectItem(name)

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
				break
			end
		else
			counter = counter +1
		end
	end
end

function self.checkShutdown()
	if fs.open("/rom/global files/shutdown.txt","r") == "true" then
		os.sleep(10000)
	end
end


return self

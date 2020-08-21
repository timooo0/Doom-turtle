
--This table is to print facing as a north/south/west/east direction:
facingString = {}
facingString[0] = "north"
facingString[1] = "east"
facingString[2] = "south"
facingString[3] = "west"

--Turn Functions:
--TurnLeft
function faceLeft()
	face = fs.open("face.txt", "r")
	facing = (tonumber(face.readLine()) - 1) % 4
	face = fs.open("face.txt", "w")
	face.writeLine(facing)
	face.close()
	turtle.turnLeft()
	print(facingString[facing])
end
--TurnRight
function faceRight()
	face = fs.open("face.txt", "r")
	facing = (tonumber(face.readLine()) + 1) % 4
	face = fs.open("face.txt", "w")
	face.writeLine(facing)
	face.close()
	turtle.turnRight()
	print(facingString[facing])
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
	Coordinates = fs.open("Coordinates.txt" , "r")
	x = tonumber(Coordinates.readLine())
	y = tonumber(Coordinates.readLine())
	z = tonumber(Coordinates.readLine())
	Coordinates.close()
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
	Coordinates = fs.open("Coordinates.txt" , "w")
	Coordinates.writeLine(x)
	Coordinates.writeLine(y)
	Coordinates.writeLine(z)
	Coordinates.close()
	--Prints the current Coords
	Coordinates = fs.open("Coordinates.txt" , "r")
	print(Coordinates.readAll())
	Coordinates.close()
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
	Coordinates = fs.open("Coordinates.txt" , "r")
	x = tonumber(Coordinates.readLine())
	y = tonumber(Coordinates.readLine())
	z = tonumber(Coordinates.readLine())
	Coordinates.close()
	--Updates the y coordinates
	y = y + 1

	--Updates to the new Coordiantes
	Coordinates = fs.open("Coordinates.txt" , "w")
	Coordinates.writeLine(x)
	Coordinates.writeLine(y)
	Coordinates.writeLine(z)
	Coordinates.close()
	--Prints the current Coords
	Coordinates = fs.open("Coordinates.txt" , "r")
	print(Coordinates.readAll())
	Coordinates.close()
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
	Coordinates = fs.open("Coordinates.txt" , "r")
	x = tonumber(Coordinates.readLine())
	y = tonumber(Coordinates.readLine())
	z = tonumber(Coordinates.readLine())
	Coordinates.close()
	--Updates the y coordinates
	y = y - 1

	--Updates to the new Coordiantes
	Coordinates = fs.open("Coordinates.txt" , "w")
	Coordinates.writeLine(x)
	Coordinates.writeLine(y)
	Coordinates.writeLine(z)
	Coordinates.close()
	--Prints the current Coords
	Coordinates = fs.open("Coordinates.txt" , "r")
	print(Coordinates.readAll())
	Coordinates.close()
end

--Digging down
function breakdown()
	if turtle.detectDown() == true then
		turtle.digDown()
	end
end

--Digging up
function breakup()
	if turtle.detectUp() == true then
		bool1,data1=turtle.inspect()
		--For breaking gravel/sand
		if data1.name == "minecraft:flowing_water" or data1.name == "minecraft:lava" or data1.name == "minecraft:water" or data1.name == "minecraft:flowing_lava" or turtle.inspect()== false then					--Gravel destroyer/Liquid Ignorer
			turtle.digUp()
			bool1,data1=turtle.inspect()
		end
		turtle.digUp()
	end
end

--Digging in front
function breakfront()	
	if turtle.detect() then
			bool1,data1=turtle.inspect()
			--For breaking gravel/sand
			while data1.name ~= "minecraft:flowing_water" and data1.name ~= "minecraft:lava" and data1.name ~= "minecraft:water" and data1.name ~= "minecraft:flowing_lava" and turtle.inspect()~= false do					--Gravel destroyer/Liquid Ignorer
					turtle.dig()
					bool1,data1=turtle.inspect()
			end
			
	end
end
--Drop items in the chest in front of it (needs to be trapped or regular)
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

--Refuel
function fuel()								
	if turtle.getFuelLevel() < 160 and turtle.getItemCount(1) > 2 then
		turtle.select(1)
		turtle.refuel(2)
		print("fueling")
	end
end

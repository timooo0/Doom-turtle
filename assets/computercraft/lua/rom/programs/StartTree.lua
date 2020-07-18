self = require("self")


turtle.refuel()

function selectItem(name)
	counter = 1
	for i=1,16 do
		turtle.select(i)
		if turtle.getItemCount() ~= 0 then
			if turtle.getItemDetail().name == name then
				print('got it')
			break
			end
		else
			counter = counter +1
		end
	end
end

--Move in a square
function square(a)

	for j=0,4 do
		if j==0 then

			self.move()
			turtle.suck()
			self.faceLeft()
			turtle.suck()
		else

		for i=1,a do
			self.move()
			turtle.suck()
		end

		self.faceLeft()
		turtle.suck()

		for i=1,a do
			self.move()
			turtle.suck()
		end
		end
	end
	self.faceRight()
	turtle.suck()
end


self.move()

--Chop the tree
bool, data = turtle.inspectUp()
yStart = tonumber(self.get(2))
while data.name == "minecraft:log" do
	self.moveup()
	bool, data = turtle.inspectUp()
end

y = tonumber(self.get(2))
self.movedown(y-yStart)

--Wait for a while
os.sleep(10)
--Scoop up the Saplings
square(1)

for i=1,1 do

	square(2)
	self.moveback()
end
self.moveback()
square(1)
self.moveback(2)

selectItem("minecraft:sapling")
turtle.drop()
turtle.craft()
selectItem("minecraft:planks")
turtle.transferTo(16)
chestCraft = {1,2,3,5,7,9,10,11}
for i=1,8 do
	turtle.select(16)
	turtle.transferTo(chestCraft[i],1)
end
turtle.drop()
turtle.craft()
selectItem("minecraft:chest")
self.move()
turtle.suck()
self.move()
turtle.suck()

self.moveChunk(16, 0)
self.moveChunk(1, 0)
self.face(3)
turtle.place()

for i = 1,16 do
	turtle.select(i)
	turtle.drop()
end


--Back to Master
--Restart Resistance
	self.store(14, "QuarryInitialization")
shell.run("Master")

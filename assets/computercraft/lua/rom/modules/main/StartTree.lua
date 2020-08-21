local StartTree = {}


os.loadAPI("/rom/apisFiles/item.lua")
os.loadAPI("/rom/apisFiles/gps.lua")
os.loadAPI("/rom/apisFiles/file.lua")

turtle.select(1)
turtle.refuel(63)


--Dump all non-name items
function dumpitems(name)
	for i = 1, 16 do
		turtle.select(i)
		if turtle.getItemCount() ~= 0 then
			if turtle.getItemDetail().name ~= name then
				turtle.drop()
			end
		end
	end
end

gps.move()

--Chop the tree
name = select(2,turtle.inspectUp()).name
yStart = file.get(2)
while name == "minecraft:log" do
	gps.moveUp()
	name = select(2,turtle.inspectUp()).name
end

y = file.get(2)
gps.moveDown(y-yStart)

--Wait for a while
os.sleep(180)
--Scoop up the Saplings
gps.square(1)

for i=1,1 do

	gps.square(2)
	gps.moveBack()
end
gps.moveBack()
gps.square(1)
gps.moveBack(2)

dumpitems("minecraft:log")
turtle.craft()
item.selectItem("minecraft:planks")
turtle.transferTo(16)
chestCraft = {1,2,3,5,7,9,10,11}
for i=1,8 do
	turtle.select(16)
	turtle.transferTo(chestCraft[i],1)
end
turtle.drop()
turtle.craft()
for i = 1, 4 do
	gps.move()
	for i = 1, 4 do
		turtle.suck()
	end
end


gps.moveChunk(0, 15)
gps.face(2)
item.selectItem("minecraft:chest")
turtle.placeUp()


--Count and store the starting items
item.InvenToItemDict()

--Places Coal in Slot 1
item.selectItem("minecraft:coal")
turtle.transferTo(1)
for i = 2,16 do
	turtle.select(i)
	turtle.dropUp()
end





--Back to Master
--Restart Resistance
	file.store(14, "Quarry")


return StartTree

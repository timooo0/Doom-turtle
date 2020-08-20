local quarrySlave = {}

function quarrySlave.Function()


quarry = require("quarry")
os.loadAPI("/rom/apisFiles/item.lua")
os.loadAPI("/rom/apisFiles/gps.lua")
os.loadAPI("/rom/apisFiles/file.lua")
os.loadAPI("/rom/apisFiles/recipe.lua")

--Create the "items.txt" file:
if fs.exists("/items.txt") == false then
  fs.copy("/rom/global files/itemsTemplate.txt","/items.txt")
end

function dropNonSmeltables()
  for i = 1, 16 do
    name, dam, count = turtle.getItemDetail(i)
    turtle.select(i)
    if name ~= "minecraft:iron_ore" and name ~= "minecraft:gold_ore" then
      if name == "minecraft:cobblestone" or name == "minecraft:log" then
        turtle.drop(math.floor(count/2))
      else
        turtle.drop()
      end
    end
  end
end

file.store(33, file.get(1))
file.store(34, file.get(3))
--Initilialize the y-height
file.store(6, file.get(2))

while true do
--Move to the correct chunk to mine
gps.moveHighWay(file.get(31), file.get(6), file.get(32))
--Move to the correct corner of the chunk
gps.moveChunk(15,0)


--file.store(10, 16)
-- Initialization
--file.store(12, 0)
file.store(13, 0)

--Initialization
file.store(15, 1)
file.store(16, "false")
file.store(18, "false")


item.selectItem("minecraft:chest")
file.store(8, file.get(4))
gps.moveAbs(file.get(1), math.floor((file.get(2)+2)/6)*6+3, file.get(3))
gps.face(file.get(8))
turtle.digUp()
turtle.placeUp()


--The starting Coordinates
file.store(5, file.get(1))
file.store(6, file.get(2))
file.store(7, file.get(3))


--The Quarry Size
file.store(9, 16)
file.store(10, 16)
file.store(11, file.get(6)-3)
--Run le quarry.lua
quarry.Function()
for i = 2,16 do
  turtle.select(i)
  if turtle.suckUp() == false then
    chestIsEmpty = true
  end
end
gps.moveBack()
--This should be the chest array drop off point
gps.moveHighWay(file.get(33), gps.highWayLevelMax+5, file.get(34))
gps.moveChunk(15,15)
--Drop off the stuff in the chestArray
--Get the new chunk to quarry from the slaveCommander.lua
rednet.open("left")
rednet.broadcast(true)
local message = select(2, rednet.receive())
file.store(31, message)
local message = select(2, rednet.receive())
file.store(32, message)

--Drop off the stuff in the chestArray
gps.face(1)
dropNonSmeltables()
gps.face(0)
for i = 1, 16 do
  turtle.select(1)
  turtle.drop()
end
gps.moveUp(3)
gps.face(1)
gps.move(2)
gps.moveDown(3)

--Refuel a lot
turtle.suck()
turtle.select(1)
turtle.refuel()
turtle.suck()
turtle.select(1)
turtle.refuel()

end


end
return quarrySlave

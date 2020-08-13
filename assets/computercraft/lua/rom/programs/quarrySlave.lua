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

file.store(33, file.get(1))
file.store(34, file.get(3))

gps.moveUp(3)

print("Init")


gps.moveAbs(file.get(31), file.get(2) , file.get(32))





--file.store(10, 16)


-- Initialization
--file.store(12, 0)
file.store(13, 0)

--Initialization
file.store(15, 1)
file.store(16, "false")
file.store(18, "false")

gps.moveDown(3)

gps.moveChunk(15,0)


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
quarry.Function()
for i = 2,16 do
  turtle.select(i)
  if turtle.suckUp() == false then
    chestIsEmpty = true
  end
end
moveHighWay(file.get(33), 80, file.get(34))




end
return quarrySlave

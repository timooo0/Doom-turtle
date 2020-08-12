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
turtle.digUp()
turtle.placeUp()

--The starting Coordinates
file.store(5, file.get(1))
file.store(6, file.get(2))
file.store(7, file.get(3))
file.store(8, file.get(4))

--The Quarry Size
file.store(9, 16)
file.store(10, 16)
file.store(11, file.get(6)-3)
print("hi1")
quarry.Function()
print("hi2")




end
return quarrySlave

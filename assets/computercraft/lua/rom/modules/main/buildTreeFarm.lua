local buildTreeFarm = {}
function buildTreeFarm.Function()
print("start")

os.loadAPI("/rom/apisFiles/item.lua")
os.loadAPI("/rom/apisFiles/gps.lua")


template =
{{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0},
{0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0},
{0,0,1,0,0,1,1,1,1,1,1,0,0,1,0,0},
{0,0,1,0,1,1,1,1,1,1,1,1,0,1,0,0},
{0,0,1,0,1,1,0,0,0,0,1,1,0,1,0,0},
{0,0,1,0,1,1,0,1,1,0,1,1,0,1,0,0},
{0,0,1,0,1,1,0,1,1,0,1,1,0,1,0,0},
{0,0,1,0,1,1,0,1,1,0,1,1,0,1,0,0},
{0,0,1,0,1,1,0,1,1,0,1,1,0,1,0,0},
{0,0,1,0,1,1,0,1,1,0,1,1,0,1,0,0},
{0,0,1,0,0,0,0,1,1,0,0,0,0,1,0,0},
{0,0,0,1,1,1,1,0,0,1,1,1,1,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}



gps.faceRight()
gps.move(16)
gps.moveChunk(15,0)
gps.moveAbs(file.get(1), gps.highWayLevelMax+5, file.get(3))

gps.buildTemplate(template,"minecraft:dirt")

gps.moveChunk(12,3)
gps.face(2)
item.selectItem("minecraft:chest")
turtle.placeDown()

gps.moveChunk(11,4)
gps.face(2)
item.selectItem("minecraft:furnace")
turtle.placeDown()

gps.moveChunk(12,3)

end

return buildTreeFarm

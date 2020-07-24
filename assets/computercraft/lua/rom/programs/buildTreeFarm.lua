local buildTreeFarm = {}
function buildTreeFarm.Function()
print("start")

os.loadAPI("/rom/apis/item.lua")
os.loadAPI("/rom/apis/gps.lua")


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


gps.faceLeft()
gps.move(16)
gps.moveUp(4)

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

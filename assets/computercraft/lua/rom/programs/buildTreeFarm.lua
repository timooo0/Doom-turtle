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
gps.moveChunk(0,0)
gps.face(1)

for i=1,16 do
	for j=1,16 do
		print(i,j)
		if template[i][j] == 1 then
			item.selectItem("minecraft:dirt")
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

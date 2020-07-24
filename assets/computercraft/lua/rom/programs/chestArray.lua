os.loadAPI("/rom/apis/gps.lua")
os.loadAPI("/rom/apis/file.lua")
os.loadAPI("/rom/apis/item.lua")
os.loadAPI("/rom/apis/recipe.lua")

template =
{{1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}

gps.moveUp(79-file.get(2))
gps.nextChunk(0)
gps.moveChunk(12,3)

item.getFromChest("minecraft:log",64,"up")
turtle.craft()
for key, value in pairs(recipe.chest) do
  for i=1,table.getn(value) do
    item.selectItem(key)
    turtle.transferTo(value[i]+5,32)
  end
end
turtle.craft()

gps.nextChunk(2)
gps.nextChunk(3)

gps.buildTemplate(template,"minecraft:chest")

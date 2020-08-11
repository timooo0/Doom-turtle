self = require("self")
buildTreeFarm = require("buildTreeFarm")
startBase = require("startBase")
newTreeFarm = require("newTreeFarm")
-- chunkMap = require("chunkMap")
-- chestArray = require("chestArray")
os.loadAPI("/rom/apisFiles/file.lua")

chestMap = {}
for i=1,16 do
  chestMap[i] = {}     -- create a new row
  for j=1,16 do
    chestMap[i][j] = {}
    for k=1,2 do
      chestMap[i][j][k] = 0
    end
  end
end

for i=1,16 do
  for j=1,16 do
    for k=1,2 do
    str = tostring(i)..","..tostring(j)..","..tostring(k)
    chestMap[i][j][k] = str
    end
  end
end

for i=1,2 do
  for j=1,2 do
    for k=1,2 do
    print(chestMap[i][j][k])
    end
  end
end
-- file.storeTable(mt,"test.txt")
-- print(table.getn(chestMap))
-- print(table.getn(chestMap[1]))

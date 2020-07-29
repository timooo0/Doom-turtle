self = require("self")
buildTreeFarm = require("buildTreeFarm")
startBase = require("startBase")
newTreeFarm = require("newTreeFarm")
chunkMap = require("chunkMap")
-- chestArray = require("chestArray")
os.loadAPI("/rom/apis/gps.lua")

for i=1,4 do
  for j=1,3 do
    print(i,j)
    if j == 2 then
      break
    end
  end
end

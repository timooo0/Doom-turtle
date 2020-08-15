os.loadAPI("/rom/apisFiles/gps.lua")
os.loadAPI("/rom/apisFiles/file.lua")
os.loadAPI("/rom/apisFiles/item.lua")
os.loadAPI("/rom/apisFiles/recipe.lua")

local route = {
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
  1,
  2,2,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  2,2
}

--todo: write in the data.txt the  position of the chestArray
-- startX = -784
-- startY = 58
-- startZ = 65
-- gps.moveHighWay(startX,startY+1,startZ)
-- gps.face(3)
protocol = "shopping"
boodschapjes = {}
table.insert(boodschapjes,{"minecraft:hay_block", 4})
table.insert(boodschapjes,{"minecraft:sea_lantern", 12})
boodschapjesState = true
file.storeTable(boodschapjes,2,"shoppingList.txt")

file.connect(protocol,"right")
file.sendFile("shoppingList.txt",protocol)
file.receiveFile("itemMap.txt",protocol)

itemMap = file.getTable("itemMap.txt")
gps.moveDown()
gps.move()

baseY = file.get(2)

function getFromChestColumn(name,amount)
  print("looking for " .. name)
  moveBack = false
  if select(2,turtle.inspectUp()).name == "minecraft:chest" then
    moveBack = true
    print(name,amount)
    amount = amount - item.getFromChest(name,amount)

    if amount ~= 0 then
      gps.move()
      gps.faceAround()
      gps.moveUp(3)
    end
  end


  while select(2,turtle.inspect()).name == "minecraft:chest" and amount ~= 0 do
    amount = amount - item.getFromChest(name,amount)
    if amount ~= 0 then
      gps.moveUp(2)
    end
  end

  while file.get(2) ~= baseY do
    gps.moveDown()
  end
  if moveBack then
    gps.move()
  end
end


for i=1,4 do
  for j=1,table.getn(route) do
    if boodschapjesState then

      if (file.get(1)%16)%2 == 0 and (file.get(3)%16)%2 == 1 then
        local chestPosPlus = {file.get(1)%16+1,file.get(3)%16+2}
        local chestPosMin = {file.get(1)%16+1,file.get(3)%16}
        for i=1,table.getn(itemMap) do
          if itemMap[i][1] == chestPosPlus[1] and itemMap[i][2] == chestPosPlus[2] then
            gps.face(2)
            getFromChestColumn(itemMap[i][3],itemMap[i][4])
            print("got " .. itemMap[i][3])
            break
          elseif itemMap[i][1] == chestPosMin[1] and itemMap[i][2] == chestPosMin[2] then
            gps.face(0)
            getFromChestColumn(itemMap[i][3],itemMap[i][4])
            print("got " .. itemMap[i][3])
            break
          end
        end

      else
        local chestPos = {file.get(1)%16+1,file.get(3)%16+1}
          for i=1,table.getn(itemMap) do
          if itemMap[i][1] == chestPos[1] and itemMap[i][2] == chestPos[2] then
            getFromChestColumn(itemMap[i][3],itemMap[i][4])
            print("got " .. itemMap[i][3])
            break
          end
        end
      end
    end
    gps.face(route[j])
    gps.move()

    if next(itemMap) == nil and boodschapjesState==false then
      print("got em all")
      boodschapjesState = false
    end

  end
end


gps.moveUp(file.highWayLevelMin-1)

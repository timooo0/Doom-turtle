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
startX = -784
startY = 58
startZ = 65
gps.moveHighWay(startX,startY+1,startZ)
gps.face(3)

file.connect("shopping","right")
file.receive("chestMap.txt","shopping")

chestMap = file.getTable("chestMap.txt")
boodschapjes = {}
boodschapjes["minecraft:chest"] = 2
boodschapjes["minecraft:concrete_powder"] = 12
boodschapjesState = true

print("shopping list:")
for k,v in pairs(boodschapjes) do
  print(k .. " " .. v)
end

function getFromChestColumn(name,amount)
  print("looking for " .. name)
  moveBack = false
  if select(2,turtle.inspectUp()).name == "minecraft:chest" then
    moveBack = true
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

      if (file.get(1)%16)%2 == 0 and (file.get(3)%16)%2==1 then
        if file.get(3)%16+2 <= 16 then
          local chestItemPlus = chestMap[file.get(1)%16+1][file.get(3)%16+2][1]
        end
        local chestItemMin = chestMap[file.get(1)%16+1][file.get(3)%16][1]
        for key, value in pairs(boodschapjes) do
          if key == chestItemPlus then
            gps.face(2)
            getFromChestColumn(key,value)
            print("got " .. key)
            boodschapjes[key] = nil
          elseif key == chestItemMin then
            gps.face(0)
            getFromChestColumn(key,value)
            print("got " .. key)
            boodschapjes[key] = nil
          end
        end
      else
        local chestItem = chestMap[file.get(1)%16+1][file.get(3)%16+1][1]
        for key, value in pairs(boodschapjes) do
          if chestItem == key then
            getFromChestColumn(key,value)
            print("got " .. key)
            boodschapjes[key] = nil
          end
        end
      end
    end
    gps.face(route[j])
    gps.move()

    if next(boodschapjes) == nil and boodschapjesState==false then
      print("got em all")
      boodschapjesState = false
    end

  end
end


gps.moveUp(file.highWayLevelMin-1)

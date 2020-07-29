os.loadAPI("/rom/apisFiles/gps.lua")
os.loadAPI("/rom/apisFiles/file.lua")
os.loadAPI("/rom/apisFiles/item.lua")
os.loadAPI("/rom/apisFiles/recipe.lua")

local route = {
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  2,2,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
  1,
  2,2
}
chestMap = file.getTable("chestMap.txt")
boodschapjes = {}
boodschapjes["minecraft:chest"] = 2
boodschapjes["minecraft:stained_glass"] = 12
boodschapjesState = true
for i=1,8 do
  for j=1,table.getn(route) do
    if boodschapjesState then

      if (file.get(1)%16)%2 == 0 and (file.get(3)%16)%2==1 then
        local chestItemPlus = chestMap[file.get(1)%16+1][file.get(3)%16+2]
        local chestItemMin = chestMap[file.get(1)%16+1][file.get(3)%16]
        for key, value in pairs(boodschapjes) do
          if key == chestItemPlus then
            gps.face(2)
            item.getFromChest(key,value)
            boodschapjes[key] = nil
          elseif key == chestItemMin then
            gps.face(0)
            item.getFromChest(key,value)
            boodschapjes[key] = nil
          end
        end
      else
        local chestItem = chestMap[file.get(1)%16+1][file.get(3)%16+1]
        for key, value in pairs(boodschapjes) do
          if chestItem == key then
            item.getFromChest(key,value)
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

for k,v in pairs(boodschapjes) do
print(k,v)
end

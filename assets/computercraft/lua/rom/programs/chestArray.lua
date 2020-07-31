os.loadAPI("/rom/apisFiles/gps.lua")
os.loadAPI("/rom/apisFiles/file.lua")
os.loadAPI("/rom/apisFiles/item.lua")
os.loadAPI("/rom/apisFiles/recipe.lua")

local template1 =
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
{1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}

local template2 =
{{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1}}

local route = {
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  3,
  2,2,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,
  2,2
}

--fill chestMap with zeros
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


-- gps.moveUp(79-file.get(2))
-- gps.nextChunk(0)
-- gps.moveChunk(12,3)
--
-- item.getFromChest("minecraft:log",64,"up")
-- turtle.craft()
-- for key, value in pairs(recipe.chest) do
--   for i=1,table.getn(value) do
--     item.selectItem(key)
--     turtle.transferTo(value[i]+5,32)
--   end
-- end
-- turtle.craft()
--
-- gps.nextChunk(2)
-- gps.nextChunk(3)


-- gps.buildTemplate(template1,"minecraft:chest")
-- gps.moveUp()
-- gps.buildTemplate(template2,"minecraft:chest")


-- gps.moveChunk(0,0)
-- gps.face(0)



baseY = file.get(2)



function fillChest(chestPos,direction)
  mapPosX = file.get(1)%16+1
  mapPosZ = file.get(3)%16+1

  print(mapPosX,mapPosZ)
  if chestPos == "down" then
    view = turtle.inspectDown
    drop = turtle.dropDown
  else
    view = turtle.inspect
    drop = turtle.drop
  end

  if direction == 0 then
    mapPosZ = mapPosZ - 1
    chestItem = chestMap[mapPosX][mapPosZ][1]
  elseif direction == 1 then
    chestItem = chestMap[mapPosX][mapPosZ][1]
  elseif direction == 2 then
    mapPosZ = mapPosZ + 1
    chestItem = chestMap[mapPosX][mapPosZ][1]
  elseif direction == 3 then
    chestItem = chestMap[mapPosX][mapPosZ][1]
  end


--check if the chest is below
  if select(2,view()).name == "minecraft:chest" then
    --check if the chest already has an item assigned to it, if not assign one
    if chestItem == 0 then
      chestMap[mapPosX][mapPosZ][1] = select(1,next(inventoryItems))
      chestItem = chestMap[mapPosX][mapPosZ][1]
      print(chestMap[mapPosX][mapPosZ][1])
    end

    --Check if the chest stores items that are currently in the inventory
    for key, value in pairs(inventoryItems) do
      -- print(key,chestItem)
      if key == chestItem then

        while inventoryItems[key] ~= nil do
          --drop the items and update inventoryItems
          item.selectItem(key)
          local before = turtle.getItemCount()

          if drop() then
            inventoryItems[key] = inventoryItems[key] - (before - turtle.getItemCount())
            chestMap[mapPosX][mapPosZ][2] =  chestMap[mapPosX][mapPosZ][2] + (before - turtle.getItemCount())
          elseif chestPos == "down" then
            if select(2,turtle.inspectUp()).name == "minecraft:chest" then
              if turtle.dropUp() then
                inventoryItems[key] = inventoryItems[key] - (before - turtle.getItemCount())
                chestMap[mapPosX][mapPosZ][2] = chestMap[mapPosX][mapPosZ][2] + (before - turtle.getItemCount())
              else
                print("we need to go up a level")
                gps.moveBack()
                gps.moveUp()
                chestPos = "front"
                view = turtle.inspect
                drop = turtle.drop
                if file.get(4) == 1 then
                  mapPosX = mapPosX + 1
                elseif file.get(4) == 4 then
                  mapPosX = mapPosX + 1
                end

              end
            else
              print("Need to build a chest here")
              break
            end

          else
            gps.moveUp(2)
            if select(2,turtle.inspect()).name == "minecraft:chest" then
              if drop() then
                inventoryItems[key] = inventoryItems[key] - (before - turtle.getItemCount())
                chestMap[mapPosX][mapPosZ][2] = chestMap[mapPosX][mapPosZ][2] + (before - turtle.getItemCount())
              end
            else
              print("Need to build a chest here")
              break
            end
          end



          --If there are no more of key item type remove it from the list
          if inventoryItems[key] == 0 then
            inventoryItems[key] = nil
          end
        end
        --Move to the correct y level if not already there
        while file.get(2) ~= baseY do
          gps.moveDown()
        end
        if chestPos == "front" then
          gps.move()
        end
      end
    end
  end
end
-- for i=-1,1 do
--   chestMap[currentY+i] = chestlayer
inventoryState = false
while true do
  file.storeTable(chestMap,3,"chestMap.txt")
  -- print(chestMap[1][1])
  sucked = false
  gps.move(0,0)
  gps.face(0)
  while sucked == false do
    while turtle.suck() do
      sucked = true
      inventoryState = true
    end
    if sucked==false then
      os.sleep(10)
    end
  end

  inventoryItems = {}
  for i=1,16 do
    turtle.select(i)
    if turtle.getItemCount() ~= 0 then
      if inventoryItems[turtle.getItemDetail().name] == nil then
        inventoryItems[turtle.getItemDetail().name] = turtle.getItemCount()
      else
        inventoryItems[turtle.getItemDetail().name] = inventoryItems[turtle.getItemDetail().name] + turtle.getItemCount()
      end
    end
  end


  for i=1,8 do
    for j=1,table.getn(route) do

      gps.face(route[j])
      if inventoryState then
        fillChest("down",file.get(4)) -- check down
        if (file.get(1)%16)%2 == 1 or (file.get(3)%16)%2==1 then
          if file.get(4) == 1 then
            gps.faceRight()
            fillChest("right",file.get(4))
            gps.faceLeft()
          elseif file.get(4) == 3 then
            gps.faceLeft()
            fillChest("left",file.get(4))
            gps.faceRight()
          end
        end

        if next(inventoryItems) == nil then
          inventoryState = false
        end
      end

    	gps.move()
    end

    if inventoryState == false then
      gps.moveChunk(0,0)
      break
    end

  end
end

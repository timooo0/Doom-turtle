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
    place = turtle.placeDown
  else
    view = turtle.inspect
    drop = turtle.drop
    place = turtle.place
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


--check if there is a chest if not place it
  if select(2,view()).name ~= "minecraft:chest" then
    turtle.select(1)
    print(chestPos)
    if not(place()) then
      print("I have run out of chests")
      return false
    end
  end

  --check if the chest already has an item assigned to it, if not assign one
  if chestItem == 0 then
    chestMap[mapPosX][mapPosZ][1] = select(1,next(inventoryItems))
    chestItem = chestMap[mapPosX][mapPosZ][1]
  end

  --Check if the chest stores items that are currently in the inventory
  for key, value in pairs(inventoryItems) do

    --Check if the inventoryItem correspond to the item in the chest
    if key == chestItem then

      --Drop the items until there is nothing left
      while inventoryItems[key] ~= nil do
        --drop the items and update inventoryItems
        item.selectItem(key)
        local before = turtle.getItemCount()

        --Check if it can drop
        if drop() then

          --Update the inventoryItem list to the new amount
          inventoryItems[key] = inventoryItems[key] - (before - turtle.getItemCount())
          chestMap[mapPosX][mapPosZ][2] =  chestMap[mapPosX][mapPosZ][2] + (before - turtle.getItemCount())

        --Check if the chest is below
        elseif chestPos == "down" then

          --Check if there is ñot a chest above it
          if select(2,turtle.inspectUp()).name ~= "minecraft:chest" then
            --Place a chest
            turtle.select(1)
            if not(turtle.placeUp()) then
              --Break if it cannot place a chest
              print("I have run out of chests")
              return false
            end
            item.selectItem(key)
          end

          --Check if it can drop
          if turtle.dropUp() then
            --Update the inventoryItem list to the new amount
            inventoryItems[key] = inventoryItems[key] - (before - turtle.getItemCount())
            chestMap[mapPosX][mapPosZ][2] = chestMap[mapPosX][mapPosZ][2] + (before - turtle.getItemCount())

          --It will need to go to the next level
          else
            print("we need to go up a level")
            gps.moveBack()
            gps.moveUp()
            chestPos = "front"
            view = turtle.inspect
            drop = turtle.drop
            place = turtle.place
            if file.get(4) == 1 then
              mapPosX = mapPosX + 1
            elseif file.get(4) == 4 then
              mapPosX = mapPosX + 1
            end

          end

        --Move to the next level
        else
          gps.moveUp(2)

          --Check if there is ñot a chest above it
          if select(2,turtle.inspect()).name ~= "minecraft:chest" then

            turtle.select(1)
            if not(place()) then
              print("I have run out of chests")
              return false
            end
            item.selectItem(key)
          end

          --Check if it can drop
          if drop() then
            --Update the inventoryItem list to the new amount
            inventoryItems[key] = inventoryItems[key] - (before - turtle.getItemCount())
            chestMap[mapPosX][mapPosZ][2] = chestMap[mapPosX][mapPosZ][2] + (before - turtle.getItemCount())
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

  return true
end


inventoryState = false



while true do
  file.storeTable(chestMap,"chestMap.txt")
  sucked = false
  gps.move(0,0)
  gps.face(0)

  turtle.select(1)
  if turtle.getItemCount() ~= 0 then
    hasChest = true
  else
    hasChest = false
  end

  if hasChest == false then
    gps.faceLeft()
    turtle.select(1)
    while hasChest == false do
      if turtle.suck() then
        hasChest = true
      end
      os.sleep(5)
    end
    gps.faceRight()
  end

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
  for i=2,16 do
    turtle.select(i)
    if turtle.getItemCount() ~= 0 then
      if inventoryItems[turtle.getItemDetail().name] == nil then
        inventoryItems[turtle.getItemDetail().name] = turtle.getItemCount()
      else
        inventoryItems[turtle.getItemDetail().name] = inventoryItems[turtle.getItemDetail().name] + turtle.getItemCount()
      end
    end
  end


  for i=1,4 do
    for j=1,table.getn(route) do

      gps.face(route[j])
      if inventoryState and hasChest then
        if (file.get(1)%16)%2 == 1 or (file.get(3)%16)%2==1 then
          if file.get(4) == 1 then
            gps.faceRight()
            hasChest = fillChest("right",file.get(4))
            gps.faceLeft()
          elseif file.get(4) == 3 then
            gps.faceLeft()
            hasChest = fillChest("left",file.get(4))
            gps.faceRight()
          end
        else
          hasChest = fillChest("down",file.get(4)) -- check down
        end

        if next(inventoryItems) == nil then
          inventoryState = false
        end
      end

    	gps.move()
    end

    if inventoryState == false or hasChest == false then
      gps.moveChunk(0,0)
      break
    end

  end
end

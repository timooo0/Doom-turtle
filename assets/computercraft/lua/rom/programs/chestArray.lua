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
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  2,2,
  3,3,3,3,3,3,3,3,3,3,3,3,3,3,
  2,2
}

--fill chestMap with zeros
-- local chestLayer = {}
-- for i=1, 8 do
--   local row = {}
--   for j=1,8 do
--     row[j] = 0
--   end
--   chestLayer[i] = row[j]
-- end



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




index = 1
currentY = file.get(2)

chestMap = {}
row = {}
for i=1,16 do
  for j=1,16 do
    row[j] = {}
  end
  chestMap[i] = {}
end

function fillChest(chestPos,direction)
  if chestPos == "down" then
    view = turtle.inspectDown
    drop = turtle.dropDown
  else
    view = turtle.inspect
    drop = turtle.drop
  end

  if direction == 0 then
    mapAdjustment = -1
  elseif direction == 1 then
    mapAdjustment = 0
  elseif direction == 2 then
    mapAdjustment = 1
  elseif direction == 3 then
    mapAdjustment = 0
  end


--check if the chest is below
  if select(2,view()).name == "minecraft:chest" then
    --check if the chest already has an item assigned to it, if not assign one
    if chestMap[file.get(1)%16+1+mapAdjustment][file.get(3)%16+1+mapAdjustment] == nil then
      chestMap[file.get(1)%16+1+mapAdjustment][file.get(3)%16+1+mapAdjustment] = select(1,next(inventoryItems))
    end

    --Check if the chest stores items that are currently in the inventory
    for key, value in pairs(inventoryItems) do
      if key == chestMap[file.get(1)%16+1+mapAdjustment][file.get(3)%16+1+mapAdjustment] then

        while inventoryItems[key] ~= nil do
          print(inventoryItems[key])
          --drop the items and update inventoryItems
          item.selectItem(key)
          local before = turtle.getItemCount()

          if before == 0 then
            --Do not need to check the rest of the items
            print("break")
            break
          end

          if drop() then
            inventoryItems[key] = inventoryItems[key] - (before - turtle.getItemCount())
          elseif chestPos == "down" then
            if select(2,turtle.inspectUp()).name == "minecraft:chest" then
              if turtle.dropUp() then
                inventoryItems[key] = inventoryItems[key] - (before - turtle.getItemCount())
              else
                print("we need to go up a level")
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
              end
            else
              print("Need to build a chest here")
              gps.moveDown(2)
              break
            end
            gps.moveDown(2)
          end

          --If there are no more of key item type remove it from the list
          if inventoryItems[key] == 0 then
            inventoryItems[key] = nil
          end
        end
      end
    end
  end
end
-- for i=-1,1 do
--   chestMap[currentY+i] = chestlayer
inventoryState = false
while true do
  sucked = false
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
    index = 1
    for j=1,table.getn(route) do

      gps.face(route[index])
      if inventoryState then
        fillChest("down",file.get(4)) -- check down
        if (file.get(1)%16)%2 == 1 or (file.get(3)%16)%2==1 then
          gps.faceLeft()
          fillChest("left",file.get(4))
          gps.faceAround()
          fillChest("right",file.get(4))
          gps.faceLeft()
        end

        if next(inventoryItems) == nil then
          inventoryState = false
        end
      end

    	gps.move()
      index = index + 1
    end

    if inventoryState == false then
      gps.moveChunk(0,0)
      index = 1
      break
    end

  end
end

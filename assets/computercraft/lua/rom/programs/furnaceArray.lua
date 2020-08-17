os.loadAPI("/rom/apisFiles/file.lua")
os.loadAPI("/rom/apisFiles/gps.lua")
os.loadAPI("/rom/apisFiles/item.lua")

nFurnaces = 0
nLayers = 0

local route = {
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  3,
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,
  1,
  2
}

local chestRoute = {
  0,
  3,
  2,
  0,
  1,
  2,
}

function expandArray()
  while item.selectItem("minecraft:furnace") do
    gps.moveUp(2*nLayers)
    for i=1,table.getn(route) do
      if file.get(3)%16 < 14 then
        if turtle.placeUp() then
          nFurnaces = nFurnaces + 1
        end
      end
      gps.face(route[i])
      gps.move()
    end
    gps.moveDown(2*nLayers)

    print(nFurnaces,nLayers)
    if math.floor(nFurnaces/28) > nLayers then
      nLayers = math.floor(nFurnaces/28)
    end
  end
end
--fueling run
run = {"fuel","smelt","collect"}



function suckAll(pos)
  gps.face(pos)
  nothing = true
  while turtle.suck() do nothing = false end
  return nothing
end

function calculateFurnaceCoal()
  local inventoryItems = item.inventoryToTable(1)

  if inventoryItems["minecraft:coal"] ~= 0 then
    furnaceCoal = math.floor(inventoryItems["minecraft:coal"]/nFurnaces)
  else
    return false
  end
  return furnaceCoal
end

while true do
  for i=1,table.getn(run) do
    go = true
    if run[i] == "fuel" then
      view = turtle.inspectUp

      if suckAll(3) or turtle.getItemCount() < nFurnaces then
        go = false
        turtle.drop()
      else
        furnaceCoal = calculateFurnaceCoal()
      end
    elseif run[i] == "smelt" then
      view = turtle.inspectDown

      if suckAll(1) then
         go = false
      else
        gps.moveUp(2)
      end
    elseif run[i] == "collect" then
      view = turtle.inspectUp

    end

    if item.selectItem("minecraft:furnace") then
      expandArray()
      calculateFurnaceCoal()
    end

    print(go)
    if go then
      layer = 0
      while layer <= nLayers do
        for j=1,table.getn(route) do
          if select(2,view()).name == "minecraft:furnace" or select(2,view()).name == "minecraft:lit_furnace"then
            if run[i] == "fuel" then
              item.dumpItem("minecraft:coal",furnaceCoal,"up")
            elseif run[i] == "smelt" then
              if turtle.getItemCount() == 0 then
                nextSlot = turtle.getSelectedSlot()+1
                if nextSlot ~= 17 then
                  turtle.select(nextSlot)
                else
                  turtle.select(1)
                end
              end
              turtle.dropDown()
            elseif run[i] == "collect" then
              turtle.suckUp()
            end
          end

          gps.face(route[j])
          gps.move()
        end

        if item.isEmpty() then
          break
        else
          layer = layer + 1
          gps.moveUp(2)
        end
      end
      gps.moveDown(2*layer)

      if run[i] == "fuel" then
        gps.face(3)
        item.itemdelivery(1)

      elseif run[i] == "smelt" then
        gps.moveDown(2)
        gps.face(1)
        item.itemdelivery(1)

      elseif run[i] == "collect" then
        gps.moveUp()
        for j=1,table.getn(chestRoute) do
          gps.face(chestRoute[j])
          if chestRoute[j] == 1 or chestRoute[j] == 3 then
            gps.move(14)
          else
            gps.move()
          end

          if j==3 then
            item.itemdelivery(1)
          end
        end
        gps.moveDown()


      end
    end
  end
end

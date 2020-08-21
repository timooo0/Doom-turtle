os.loadAPI("/rom/apisFiles/file.lua")
os.loadAPI("/rom/apisFiles/gps.lua")
os.loadAPI("/rom/apisFiles/item.lua")
os.loadAPI("/rom/apisFiles/recipe.lua")

nFurnaces = 0
nLayers = 0
cobbleChest = 0


local route = {
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  1,
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,
  3,
  2
}

function makeFurnace()
  turtle.suck()
  cobbleChest = cobbleChest - turtle.getItemCount()
  if item.selectItem("minecraft:cobblestone") == false then
    return
  end
  turtle.transferTo(1)
  for key, value in pairs(recipe.furnace) do
    if value[1] ~= "result" then
      for i=1,table.getn(value) do
        item.selectItem(key)
        turtle.transferTo(value[i]+5,8)
      end
    end
  end
  turtle.craft()
  item.selectItem("minecraft:furnace")
end

function dropOff(itemName)
  baseY = file.get(2)
  while select(2,turtle.inspect()).name == "minecraft:chest" do
    if item.isEmpty() then
      break
    else
      if itemName == nil then
        item.itemdelivery()
      else
        item.dumpItem(itemName)
      end
      gps.moveUp()
    end
  end
  while file.get(2) ~= baseY do
    gps.moveDown()
  end
end

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
  baseY = file.get(2)
    while select(2,turtle.inspect()).name == "minecraft:chest" do
      if not(turtle.suck()) then
        gps.moveUp()
      else
        while turtle.suck() do nothing = false end
      end
    end

    while file.get(2) ~= baseY do
      gps.moveDown()
    end
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

expandArray()

while true do
  for i=1,table.getn(run) do
    print(run[i])
    go = true
    if run[i] == "fuel" then
      view = turtle.inspectUp
      gps.moveUp()
      if suckAll(1) or turtle.getItemCount() < nFurnaces then
        go = false
        turtle.drop()
      else
        if turtle.getFuelLevel() < 500 then
          print("refueling")
          item.selectItem("minecraft:coal")
          turtle.refuel()
        end
        furnaceCoal = calculateFurnaceCoal()
      end
      gps.moveDown()

    elseif run[i] == "smelt" then
      view = turtle.inspectDown
      if suckAll(3) then
         go = false
      else

        if cobbleChest < 128 then
          if item.selectItem("minecraft:cobblestone") then
            gps.faceAround()
            local nCobble = turtle.getItemCount()
            turtle.drop()
            cobbleChest = cobbleChest + nCobble
          end
        end

        for i=1,16 do
          turtle.select(i)
          if turtle.getItemCount() ~= 0 then
            break
          end
        end
        gps.moveUp(2)
      end

    elseif run[i] == "collect" then
      view = turtle.inspectUp

    end


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
        gps.face(1)
        gps.moveUp()
        dropOff()
        gps.moveDown()

      elseif run[i] == "smelt" then
        gps.moveDown(2)
        if not(item.isEmpty()) then
          gps.face(3)
          dropOff()
          gps.faceAround()
          makeFurnace()
          expandArray()
        end

      elseif run[i] == "collect" then
        gps.face(1)
        gps.moveUp()
        dropOff("minecraft:coal")
        gps.moveDown()
        gps.face(2)
        dropOff()
      end
    end
  end
end

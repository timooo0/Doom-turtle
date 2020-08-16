os.loadAPI("/rom/apisFiles/file.lua")
os.loadAPI("/rom/apisFiles/gps.lua")
os.loadAPI("/rom/apisFiles/item.lua")

nFurnaces = 24
local route = {
  0,0,0,0,0,0,0,0,0,0,0,0,0,
  3,
  2,2,2,2,2,2,2,2,2,2,2,2,
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
    print("There is no coal, help!")
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

    print(go)
    if go then
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

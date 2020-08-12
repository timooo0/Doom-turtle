local quarrySlave = {}

function quarrySlave.Function()
  quarry = require("quarry")
  os.loadAPI("/rom/apisFiles/item.lua")
  os.loadAPI("/rom/apisFiles/gps.lua")
  os.loadAPI("/rom/apisFiles/file.lua")
  os.loadAPI("/rom/apisFiles/recipe.lua")

  item.selectItem("minecraft:coal")
  turtle.transferTo(1)

  gps.moveUp()

  print("Init")
  x = file.get(1)
  y = file.get(2)
  z = file.get(3)
  facing = file.get(4)

  gps.moveAbs(file.get(31), y , file.get(32))

  --The starting Coordinates
	file.store(5, x)
	file.store(6, y)
	file.store(7, z)
	file.store(8, facing)

  --The Quarry Size
  file.store(9, 15)
  --file.store(10, 16)
  file.store(11, file.get(6)-3)

  -- Initialization
  --file.store(12, 0)
  file.store(13, 0)

  --Restart Resistance
  file.store(14, "Quarry")
  --Initialization
  file.store(15, 1)
  file.store(16, "false")
  file.store(18, "false")



  gps.moveDown()






end
return quarrySlave

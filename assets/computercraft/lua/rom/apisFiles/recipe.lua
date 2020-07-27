computer = {}
computer["minecraft:stone,0"] = {1,2,3,5,7,9,11}
computer["minecraft:redstone"] = {6}
computer["minecraft:glass_pane"] = {10}
computer["computercraft:computer"] = {"result",1}

turtle = {}
turtle["minecraft:iron_ingot"] = {1,2,3,5,7,9,11}
turtle["computercraft:computer"] = {6}
turtle["minecraft:chest"] = {10}
turtle["computercraft:turtle_expanded"] = {"result",1}

modem = {}
modem["minecraft:stone,0"] = {1,2,3,5,7,9,10,11}
modem["minecraft:redstone"] = {6}
modem["computercraft:cable,1"] = {"result"}

modemBlock = {}
modemBlock["computercraft:cable,1"] = {1}
modemBlock["computercraft:wired_modem_full"] = {"result",1}

furnace = {}
furnace["minecraft:cobblestone"] = {1,2,3,5,7,9,10,11}
furnace["minecraft:furnace"] = {"result",1}

chest = {}
chest["minecraft:planks"] = {1,2,3,5,7,9,10,11}
chest["minecraft:chest"] = {"result",1}

hopper = {}
hopper["minecraft:iron_ingot"] = {1,3,4,6,8}
hopper["minecraft:chest"] = {5}
hopper["minecraft:hopper"] = {"result", 1}

glassPane = {}
glassPane["minecraft:glass"] = {5,6,7,9,10,11}
glassPane["minecraft:glass_pane"] = {"result",16}

stick = {}
stick["minecraft:planks"] = {1,5}
stick["minecraft:stick"] = {"result",4}

diamondPickaxe = {}
diamondPickaxe["minecraft:diamond"] = {1,2,3}
diamondPickaxe["minecraft:stick"] = {6,10}
diamondPickaxe["minecraft:diamond_pickaxe"] = {"result",1}

ironIngot = {}
ironIngot["minecraft:iron_ore"] = {"smelt"}
ironIngot["minecraft:iron_ingot"] = {"result", 1}

stone = {}
stone["minecraft:cobblestone"] = {"smelt"}
stone["minecraft:stone,0"] = {"result", 1}

miningTurtle = {}
miningTurtle["minecraft:diamond_pickaxe"] = {3}
miningTurtle["computercraft:turtle_expanded"] = {2}
--This one does not work because same ID
--miningTurtle["computercraft:turtle_expanded"] = {"result"}

referenceTable = {}
referenceTable["minecraft:diamond_pickaxe"] = diamondPickaxe
referenceTable["computercraft:turtle_expanded"] = turtle
referenceTable["minecraft:stick"] = stick
referenceTable["minecraft:glass_pane"] = glassPane
referenceTable["minecraft:chest"] = chest
referenceTable["minecraft:furnace"] = furnace
referenceTable["computercraft:wired_modem_full"] = modemBlock
referenceTable["computercraft:cable,1"] = modem
referenceTable["computercraft:computer"] = computer
referenceTable["minecraft:iron_ingot"] = ironIngot
referenceTable["minecraft:stone,0"] = stone
referenceTable["minecraft:hopper"] = hopper
referenceTable["start"] = "start"

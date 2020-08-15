os.loadAPI("/rom/apisFiles/file.lua")

function findInShop(shoppingList)
  print("----------------")
  if fs.exists("itemMap.txt") then fs.delete("itemMap.txt") end
  itemMap = {}
  chestMap = file.getTable("chestMap.txt")
  for key, value in pairs(shoppingList) do
    print(value[1])
    for i=1,table.getn(chestMap) do
      for j=1,table.getn(chestMap) do
        if chestMap[i][j][1] == value[1] then
          table.insert(itemMap,{i,j,value[1],value[2]})
        end
      end
    end
  end
  file.storeTable(itemMap,2,"itemMap.txt")
end

rednet.open("top")
while true do
  protocol = select(2,rednet.receive())
  rednet.broadcast("connected",protocol)
  print("protocol: " .. protocol)

  if protocol == "clerk" then
    file.receiveFile("mapChanges.txt",protocol)
    file.applyMapChanges("chestMap.txt","mapChanges.txt",1)
    fs.delete("mapChanges.txt")
    file.applyMapChanges("chestMap.txt","itemMap.txt",-1)
    file.serverUpdate("checkOut.txt",protocol)
    print("succes")
  elseif protocol == "shopping" then
    file.receiveFile("shoppingList.txt",protocol)
    shoppingList = file.getTable("shoppingList.txt")
    findInShop(shoppingList)
    file.sendFile("itemMap.txt",protocol)

  end
  print("succes")
end

os.loadAPI("/rom/apisFiles/file.lua")

rednet.open("top")
while true do
  protocol = select(2,rednet.receive())
  rednet.broadcast("connected",protocol)
  print("protocol: " .. protocol)

  if protocol == "clerk" then
    file.receiveFile("chestMap.txt",protocol)
    print("succes")
  elseif protocol == "shopping" then
    file.sendFile("chestMap.txt",protocol)

  end
  print("succes")
end

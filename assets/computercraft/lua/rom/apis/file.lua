--Use tonumber(self.get(linenumber)) to make sure it is a number
function get(linenumber, filepath)

	if filepath == nil then
		filepath = "data.txt"
	end

	local dataRead = fs.open(filepath, "r")

	for line = 1, linenumber-1 do
		dataRead.readLine()
	end

	dataget = dataRead.readLine()
	dataRead.close()

	if tonumber(dataget) == nil then
		return dataget
	else
		return tonumber(dataget)
	end
end

function store(linenumber, msg, filepath)

	if filepath == nil then
		filepath = "data.txt"
	end

	local dataRead = fs.open(filepath, "r")

	dataget = {}
	line = 1

	repeat
		dataget[line] = dataRead.readLine()
		line = line + 1

	until dataget[line-1] == nil

	dataRead.close()
	dataWrite = fs.open(filepath, "w")
	line = 1

	while dataget[line] ~= nil do
		if line == linenumber then
			dataWrite.writeLine(msg)
		else
			dataWrite.writeLine(dataget[line])
		end

		line = line + 1
	end

	dataWrite.close()
end

function addStore(linenumber, diff, filepath)
	store(linenumber, get(linenumber, filepath)+tonumber(diff), filepath)
end

function checkShutdown()
	if fs.open("/rom/global files/shutdown.txt","r") == "true" then
		os.sleep(10000)
	end
end

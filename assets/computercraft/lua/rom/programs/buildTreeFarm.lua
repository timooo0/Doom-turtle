self =require("self")
template = 
{{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0},
{0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0},
{0,0,1,0,0,1,1,1,1,1,1,0,0,1,0,0},
{0,0,1,0,1,1,1,1,1,1,1,1,0,1,0,0},
{0,0,1,0,1,1,0,0,0,0,1,1,0,1,0,0},
{0,0,1,0,1,1,0,1,1,0,1,1,0,1,0,0},
{0,0,1,0,1,1,0,1,1,0,1,1,0,1,0,0},
{0,0,1,0,1,1,0,1,1,0,1,1,0,1,0,0},
{0,0,1,0,1,1,0,1,1,0,1,1,0,1,0,0},
{0,0,1,0,1,1,0,1,1,0,1,1,0,1,0,0},
{0,0,1,0,0,0,0,1,1,0,0,0,0,1,0,0},
{0,0,0,1,1,1,1,0,0,1,1,1,1,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}

function selectItem(name)
counter = 1
for i=1,16 do
turtle.select(i)
if turtle.getItemCount() ~= 0 then
	if turtle.getItemDetail().name == name then
	print('got it')
	break
end
else
counter = counter +1
end
end
end


self.moveChunk(0,0)
self.face(1)

for i=1,16 do
	for j=1,16 do
		print(i,j)
		if template[i][j] == 1 then
			turtle.placeDown()
			if turtle.getItemCount() == 0 then
				turtle.select(turtle.getSelectedSlot()+1)
			end
		end
		if j ~= 16 then
		self.move()
		end
	end
	if i~=16 and j~= 16 then
		if i%2 == 1 then
		self.faceRight()
		self.move()
		self.faceRight()
		else
		self.faceLeft()
		self.move()
		self.faceLeft()

		end
	end
end

self.moveChunk(12,3)
self.face(2)
selectItem("minecraft:chest")
turtle.placeDown()
local path = ...
local tween = require(path .. '/tween')

local splashy = {}
splashy.list = {}
splashy.alpha = 255
splashy.count = 1

function splashy.addSplash(image, index)

	if index == nil then index = #splashy.list + 1 end
	assert(type(index) == "number", "index must be a number")

	splashy.list[index] = love.graphics.newImage(image)

	print(splashy.list[index])

end

function splashy.draw()

	for i=1, #splashy.list do

		love.graphics.setColor(255, 255, 255, splashy.alpha)

		-- If the current splash is the one in the list.

		if splashy.count == i then

			-- Then grab the splash from the list and draw it to the screen.

			local splash = splashy.list[i]
			local centerwidth = love.graphics.getWidth() / 2
			local centerheight = love.graphics.getHeight() / 2

			local centerimagewidth = splash:getWidth() / 2
			local centerimageheight = splash:getHeight() / 2

			love.graphics.draw(splashy.list[i], centerwidth - centerimagewidth, centerheight - centerimageheight)

		end

	end

	love.graphics.setColor(255, 255, 255, 255)

end

return splashy
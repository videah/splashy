local path = ...
local tween = require(path .. '/tween')

local splashy = {}
splashy.list = {}
splashy.inalpha = 0
splashy.outalpha = 255
splashy.count = 1
splashy.tweenlist = {}
splashy.fadestate = "in"
splashy.finished = false
splashy.onCompleteFunction = nil

function splashy.addSplash(image, index)

	index = index or #splashy.list + 1
	assert(type(index) == "number", "index must be a number")

	splashy.list[index] = image

	splashy.tweenlist[index] = tween.new(2, splashy, {inalpha = 255, outalpha = 0})

end

function splashy.skipSplash()

	splashy.fadestate = "in"

	splashy.count = splashy.count + 1

end
	
function splashy.skipAll()

	splashy.fadestate = "in"

	splashy.count = #splashy.list + 1

end

function splashy.onComplete(func)

	assert(type(func) == "function", "func must be a function")

	splashy.onCompleteFunction = func

end

function splashy.draw()

	if splashy.finished == false then

		for i=1, #splashy.list do

			if splashy.fadestate == "in" then

				love.graphics.setColor(255, 255, 255, splashy.inalpha)

			elseif splashy.fadestate == "out" then

				love.graphics.setColor(255, 255, 255, splashy.outalpha)

			end

			-- If the current splash is the one in the list.

			if splashy.count == i then

				-- Then grab the splash from the list and draw it to the screen.

				local splash = splashy.list[i]
				local centerwidth = love.graphics.getWidth() / 2
				local centerheight = love.graphics.getHeight() / 2

				local centerimagewidth = splash:getWidth() / 2
				local centerimageheight = splash:getHeight() / 2

				love.graphics.draw(splash, centerwidth - centerimagewidth, centerheight - centerimageheight)

			end

		end

		love.graphics.setColor(255, 255, 255, 255)

	end

end

function splashy.update(dt)

	if splashy.finished == false then

		for i=1, #splashy.tweenlist do

			if splashy.count == i then

				local tweenComplete = splashy.tweenlist[i]:update(dt)

				if tweenComplete then

					if splashy.fadestate == "in" then

						splashy.tweenlist[i]:reset()

						splashy.fadestate = "out"

					elseif splashy.fadestate == "out" then

						splashy.tweenlist[i]:reset()

						splashy.count = splashy.count + 1

						splashy.fadestate = "in"

					end

				end

			end

		end

		if splashy.count >= #splashy.list + 1 then

			assert(type(splashy.onCompleteFunction) == "function", "onComplete needs a valid function.")

			splashy.finished = true

			splashy.onCompleteFunction()

		end

	end

end

return splashy
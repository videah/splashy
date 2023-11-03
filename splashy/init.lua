-- This code is licensed under the MIT Open Source License.

-- Copyright (c) 2015 Ruairidh Carmichael - ruairidhcarmichael@live.co.uk

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

local path = ...
local tween = require(path .. '/tween')

local splashy = {}
splashy.list = {}
splashy.inalpha = 0
splashy.outalpha = 1
splashy.count = 1
splashy.tweenlist = {}
splashy.colorList = {}
splashy.scaleList = {}
splashy.fadestate = "in"
splashy.finished = false
splashy.onCompleteFunction = function () end
splashy.screenWidth = love.graphics.getWidth()
splashy.screenHeight = love.graphics.getHeight()

--- Sets the expected screen resolution that Splashy will use for rendering.
-- You should set this manually if you use screen scaling libraries like Push or TLfres
function splashy.setScreenSize (width, height)
	splashy.screenWidth, splashy.screenHeight = width, height
end

--- Adds a splash screen to the queue.
-- @param image (drawable) Usually an image to be drawn in the splash screen
-- @param duration (number) Optional. Determines how long the image fade will last. Defaults to 2
-- @param index (number) Optional. Allows you to set a custom index for the splash screen, which will change the order it is rendered
-- @param color (table) Optional. Affects the background color of the splash screen. Defaults to transparent black
-- @param scale (number) Optional. Determines the scale at which the image is drawn
function splashy.addSplash(image, duration, index, color, scale)

	duration = duration or 2
	assert(type(duration) == 'number' and duration > 0, "duration must be a positive number.")

	index = index or #splashy.list + 1
	assert(type(index) == "number", "index must be a number")

	color = color or {0, 0, 0, 0}
	assert(type(color) == "table", "color must be a table")

	scale = scale or 1
	assert(type(scale) == "number", "scale must be a number")

	splashy.list[index] = image

	splashy.tweenlist[index] = tween.new(duration, splashy, {inalpha = 1, outalpha = 0})

	splashy.colorList[index] = color

	splashy.scaleList[index] = scale
end

--- Skips the current splash screen.
function splashy.skipSplash()

	splashy.fadestate = "in"

	splashy.count = splashy.count + 1

end

--- Skips all the splash screens.
function splashy.skipAll()

	splashy.fadestate = "in"

	splashy.count = #splashy.list + 1

end

--- Sets a callback function that will execute when all the splash screens have finished.
-- @param func (function) The callback function
function splashy.onComplete(func)

	assert(type(func) == "function", "func must be a function")

	splashy.onCompleteFunction = func

end

--- Renders the splash screens.
-- This should be placed in love.draw ()
function splashy.draw()

	if splashy.finished == false then

		for i=1, #splashy.list do

			-- If the current splash is the one in the list.

			if splashy.count == i then

				-- Then grab the splash from the list and draw it to the screen.

				local splash = splashy.list[i]
				local scale = splashy.scaleList[i]
				local centerwidth = splashy.screenWidth / 2
				local centerheight = splashy.screenHeight / 2

				local centerimagewidth = (splash:getWidth() * scale) / 2
				local centerimageheight = (splash:getHeight() * scale) / 2

				love.graphics.setColor (splashy.colorList[i])
				love.graphics.rectangle ("fill", 0, 0, splashy.screenWidth, splashy.screenHeight)
				
				if splashy.fadestate == "in" then

					love.graphics.setColor(1, 1, 1, splashy.inalpha)

				elseif splashy.fadestate == "out" then

					love.graphics.setColor(1, 1, 1, splashy.outalpha)

				end

				love.graphics.draw(splash, centerwidth - centerimagewidth, centerheight - centerimageheight, nil, scale, scale)

			end

		end

		love.graphics.setColor(1, 1, 1, 1)

	end

end

--- Renders Splashy.
-- This should be placed in love.update (dt)
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

# splashy

__splashy__ is a simple and basic library for Love2D, that easily allows the implementation of  splash screens to any project.


###Installation
To install, extract the splashy folder to somewhere in your project (usually a /libs folder)

Then setup your main.lua like this:

```lua
splashy = require 'splashy'

function love.draw()

	splashy.draw()

end

function love.update(dt)

	splashy.update(dt)

end
```

Then you'll have a barebones installation complete!
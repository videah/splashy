![](https://i.imgur.com/9mlZVeT.png)

__splashy__ is a simple and basic library for LÖVE, that allows the easy implementation of splash screens to any project.


# Installation
To install, extract the splashy folder to somewhere in your project (usually a /libs folder)

Then setup your main.lua like this:

```lua
splashy = require 'path/to/splashy/folder'

function love.draw()

	splashy.draw()

end

function love.update(dt)

	splashy.update(dt)

end
```

Then you'll have a barebones installation complete!

# Demo
You can see the code demo of the library [here.](https://github.com/VideahGams/splashyDemo)

# Interface

## Splash Creation

```lua
splashy.addSplash(image, duration, index)
```

* `image` is a drawable (usually an image) to be drawed in a splash.
* `duration` is an optional argument, to set how long the image fade will last. It must be a positive number. (default: 2)
* `index` is an optional argument allowing to set custom splash index number for any reason you would need to do so.

## On Complete

```lua
splashy.onComplete(func)
```

* `func` is a callable function to be ran once all the splash screens are finished.

There are 2 main ways of using this:

```lua
splashy.onComplete(function() print("This is ran one time after all splashes are finished.") end)
```
```lua
splashy.onComplete(printFinishText)

function printFinishText()

	print("This is ran one time after all splashes are finished.")

end
```
Using this function is useful for switching gamestate.

## Splash Skipping

This function skips the current splash screen onto the next one:

```lua
splashy.skipSplash()
```
Whilst this one skips all splashes, running the onComplete function:

```lua
splashy.skipAll()
```
# Credits

[tween.lua](https://github.com/kikito/tween.lua) is used for the tweening/fading.

Check LICENCE.md for more info.

# Changelog

v1.0:

* First Release.

# Notes

This library has/is a learning experience for me, if theres any problems be sure to raise them in the issues.

Pull requests are welcome :)


local bump = require 'lib.bump'
world = bump.newWorld(32)

local worldObjects = {}

local World = {
    bgColor = {0, 200, 0},
    floorColor = {0, 0, 0, 255},

    load = function(self)
        table.insert(worldObjects, {
            name = "floor",
            x = 0,
            y = love.graphics.getHeight()-64,
            w = love.graphics.getWidth(),
            h = 64
        })

        for x=1, #worldObjects do
            local wObj = worldObjects[x]
            world:add(wObj, wObj.x, wObj.y, wObj.w, wObj.h)
        end
    end,

    draw = function(self)
        love.graphics.setBackgroundColor(self.bgColor)

        love.graphics.setColor(self.floorColor)
        for x=1, #worldObjects do
            local wObj = worldObjects[x]
            love.graphics.rectangle("fill", wObj.x, wObj.y, wObj.w, wObj.h)
        end
    end,

    update = function(self, dt)
        
    end
}

return World
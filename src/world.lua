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
            world:add(worldObjects[x], worldObjects[x].x, worldObjects[x].y, worldObjects[x].w, worldObjects[x].h)
        end
        
        --print(world:getRect(floor))
    end,

    draw = function(self)
        love.graphics.setBackgroundColor(self.bgColor)
        love.graphics.setColor(self.floorColor)
        --love.graphics.rectangle("fill", 0, love.graphics.getHeight()-64, love.graphics.getWidth(), 64)

        for x=1, #worldObjects do
            love.graphics.rectangle("fill", worldObjects[x].x, worldObjects[x].y, worldObjects[x].w, worldObjects[x].h)
        end
    end,

    update = function(self, dt)
        
    end
}

return World
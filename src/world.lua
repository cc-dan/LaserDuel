local bump = require 'lib.bump'
local assets = require('assets')
world = bump.newWorld(32)

local worldObjects = {}

local World = {
    bgColor = {0, 200, 0},
    floorColor = {0, 0, 0, 255},

    load = function(self)
        table.insert(worldObjects, {
            name = "floor",
            x = 0,
            y = love.graphics.getHeight()-40,
            w = love.graphics.getWidth(),
            h = 64
        })

        for x=1, #worldObjects do
            local wObj = worldObjects[x]
            world:add(wObj, wObj.x, wObj.y, wObj.w, wObj.h)
        end
    end,

    draw = function(self)
    	love.graphics.setColor(255, 255, 255, 255)
        love.graphics.setBackgroundColor(self.bgColor)
        love.graphics.draw(assets.world.img_background, 0, 0, 0, 1, 1, 0, 0)

        love.graphics.setColor(self.floorColor)
        --for x=1, #worldObjects do
        --    local wObj = worldObjects[x]
        --    love.graphics.rectangle("fill", wObj.x, wObj.y, wObj.w, wObj.h)
        --end
    end,

    update = function(self, dt)
        
    end
}

return World
wf = require 'windfield'
physicsWorld = wf.newWorld(0, 20000, true)

World = {
    bgColor = {0, 200, 0},
    floorColor = {0, 0, 0, 255},

    load = function(self)
        local floorCollider = physicsWorld:newRectangleCollider(0, love.graphics.getHeight()-64, love.graphics.getWidth(), 64)
        floorCollider:setType('static')
    end,

    draw = function(self)
        love.graphics.setBackgroundColor(self.bgColor)

        love.graphics.setColor(self.floorColor)
        love.graphics.rectangle("fill", 0, love.graphics.getHeight()-64, love.graphics.getWidth(), 64)

        physicsWorld:draw()
    end,

    update = function(self, dt)
        physicsWorld:update(dt)
    end
}

return World
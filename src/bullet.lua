Bullet = {
    x = 20,
    y = 0,
    speed = 2500,
    gw = 32,
    gh = 16,
    direction,
    destroy = false,

    create = function(self, instanceData)
        local instance = instanceData

        setmetatable(instance, self)
        self.__index = self

        return instance
    end,

    draw = function(self)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.rectangle("fill", self.x, self.y, self.gw, self.gh)
    end,

    update = function(self, dt)
        self.x = self.x + (self.speed*self.direction) * dt

        if (self.x < 0 or self.x > love.graphics.getWidth()) then 
            self.destroy = true 
        end
    end
}

return Bullet
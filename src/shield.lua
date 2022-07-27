Shield = {
    x,
    y,
    gw = 4,
    gh = 24,
    originX = 2,
    originY = 12,
    life = 0.6,
    parryWindow = 1,
    decayRate = 1,
    destroy = false,
    owner,
    collisionId = "shield",

    create = function(self, instanceData, owner)
        local instance = instanceData

        world:add(instance, instance.x-self.originX, instance.y-self.originY, self.gw, self.gh)

        instance.owner = owner
        instance.owner.lock = true

        setmetatable(instance, self)
        self.__index = self
        
        return instance
    end,

    draw = function(self)
        love.graphics.setColor(0, 0, 255)
        love.graphics.rectangle('fill', self.x-self.originX, self.y-self.originY, self.gw, self.gh)
    end,

    update = function(self, dt)
        local actualX, actualY, cols, len = world:check(self, self.x, self.y)

        if self.life <= 0 then
            self:kill()
        end

        print(self.life)

        self.life = self.life - self.decayRate * dt
    end,

    kill = function(self)
        if (self.owner) then
            self.owner.lock = false
        end

        world:remove(self)
        self.destroy = true
    end
}

return Shield
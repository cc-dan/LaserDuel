Shield = {
    x,
    y,
    gw = 4,
    gh = 48,
    life = 60,
    parryWindow = 1,
    decayRate = 1,
    destroy = false,
    owner,
    collisionId = "shield",

    create = function(self, instanceData, owner)
        local instance = instanceData

        owner.lock = true

        world:add(instance, instance.x, instance.y, self.gw, self.gh)

        self.owner = owner

        setmetatable(instance, self)
        self.__index = self

        return instance
    end,

    draw = function(self)
        love.graphics.setColor(0, 0, 255)
        love.graphics.rectangle('fill', self.x, self.y, self.gw, self.gh)
    end,

    update = function(self)
        local actualX, actualY, cols, len = world:check(self, self.x, self.y)

        print(self.life)

        if self.life <= 0 then
            self:kill()
        end

        self.life = self.life - self.decayRate
    end,

    kill = function(self)
        if self.owner then
            self.owner.lock = false
        end

        world:remove(self)
        self.destroy = true
    end
}

return Shield
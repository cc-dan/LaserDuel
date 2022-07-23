local Bullet = {
    x = 20,
    y = 0,
    speed = 2500,
    gw = 16,
    gh = 8,
    originX = 8,
    originY = 4,
    direction,
    destroy = false,
    collisionId = 'bullet',
    owner,

    create = function(self, instanceData, owner)
        local instance = instanceData

        world:add(instance, instance.x-self.originX, instance.y-self.originY, self.gw, self.gh)

        self.owner = owner

        setmetatable(instance, self)
        self.__index = self

        return instance
    end,

    draw = function(self)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.rectangle("fill", self.x-self.originX, self.y-self.originY, self.gw, self.gh)
    end,

    update = function(self, dt)
        --self.x = self.x + (self.speed*self.direction) * dt
        local actualX, actualY, cols, len = world:move(
            self, 
            self.x + (self.speed*self.direction) * dt, 
            self.y, 
            function(item, other) 
                if (other.collisionId == "bullet") then 
                    return 'cross'
                end

                return 'touch' 
            end
        )
        self.x = actualX

        for i=1, #cols do
            if cols[i].other.collisionId == "player" then
                cols[i].other:kill()

                world:remove(self)
                self.destroy = true
            end

            if cols[i].other.collisionId == "shield" then
                if not (cols[i].other.life >= 0.50) then
                    self:kill()
                else
                    self.direction = self.direction * -1
                    self.speed = self.speed * 1.10
                end

                cols[i].other:kill()
            end
        end

        if (self.x < 0 or self.x > love.graphics.getWidth()) and not self.destroy then 
            self:kill()
        end
    end,

    kill = function(self)
        world:remove(self)
        self.destroy = true
    end
}

return Bullet
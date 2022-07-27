require 'utility'
local bullet = require('bullet')
local shield = require('shield')
local assets = require('assets')

local Player = {
    speed = 350,
    jumpSpeed = 500,
    gravity = 50,
    graphicWidth = 32,
    graphicHeight = 64,
    color = {255, 255, 255, 255},
    collisionId = "player",
    destroy = false,
    lock = false,
    crouched = false,
    originX = 16,
    originY = 32,
    gunW = 16,
    gunH = 8,
    gun_originX = 8,
    gun_originY = 4,
    bulletCount = 0,
    
    -- Dependientes de la instancia --> función create()
    -- Mantenidos acá como referencia
    x,
    y,
    facing,
    collider,
    controlScheme,
    shootId,
    playerId,

    -- Manejados por la función update()
    xVector = 0,
    yVector = 0,
    yVel = 0,
    gunPos = 0,

    sprites_gunPos = {
        assets.player.img_player_gunPos_0,
        assets.player.img_player_gunPos_1,
        assets.player.img_player_gunPos_2
    },

    create = function(self, instanceData)
        -- En esta función se controlan las variables que son únicas para cada instancia + inicialización de variables autorreferenciales
        -- e.g. posición inicial, dirección, esquema de controles, creación de hitbox
        local instance = instanceData

        -- El collider se crea dentro de la función porque requiere hacer referencias a variables de la clase, lo cual no se puede hacer dentro de la table
        -- Ninguno de los valores de la table existen hasta que no sea creada
        world:add(instance, instance.x, instance.y, self.graphicWidth, self.graphicHeight)

        if (instance.x > love.graphics.getWidth()/2) then
            instance.facing = -1
        else
            instance.facing = 1
        end

        -- Observers
        beholder.group(instance, function()
            -- Controles
            beholder.observe(
                "SHOOT_PLAYER", instance.playerId, 
                function() instance:shoot() end
            )
            beholder.observe(
                "MOVE_GUN_UP", instance.playerId, 
                function() instance:switchGunPos(instance.gunPos-1) end
            )
            beholder.observe(
                "MOVE_GUN_DOWN", instance.playerId,
                function() instance:switchGunPos(instance.gunPos+1) end
            )
            beholder.observe(
                "SPAWN_SHIELD", instance.playerId,
                function() instance:spawnShield(instance) end
            )
            beholder.observe(
                "CROUCH", instance.playerId,
                function() instance:crouch() end
            )
            beholder.observe(
                "JUMP", instance.playerId,
                function() instance:jump() end
            )
        end)

        setmetatable(instance, self)
        self.__index = self

        return instance
    end,

    playerFilter = function(item, other)
        if not other.destroy then 
            return 'cross'
        else 
            return 'slide'
        end
        -- else return nil
    end,

    draw = function(self)
        --Hitbox
        local x, y, w, h = world:getRect(self)
        love.graphics.setColor({255, 0, 0, 255})
        love.graphics.rectangle("line", x, y, w, h)

        --Player
        love.graphics.setColor(self.color)
        love.graphics.draw(
            self.sprites_gunPos[self.gunPos+1], 
            self.x + self.originX, self.y, 
            0, 
            self.facing, 1, 
            self.originX
        )
    end,

    update = function(self, dt)
        self.xVector = (boolToInt(love.keyboard.isDown(self.controlScheme[1])) - boolToInt(love.keyboard.isDown(self.controlScheme[2]))) * boolToInt(not self.lock)
        self.yVel = self.yVel + self.gravity

        local actualX, actualY, cols, len = world:move(
            self, 
            self.x + (self.xVector * self.speed) * dt, 
            self.y + (self.yVel) * dt
        )
        self.x, self.y = actualX, actualY
    end,

    switchGunPos = function(self, pos)
        if (pos < 0 or pos > 2) then return end
        
        self.gunPos = pos
    end,

    shoot = function(self)
        if self.lock then return end

        table.insert(entities, bullet:create({
            x=self.x+self.originX + 32 * self.facing, --* self.facing,
            y=(self.y + 8) + 16 * (self.gunPos), 
            direction=self.facing
        }))

        self.bulletCount = self.bulletCount + 1
        if self.bulletCount >= 3 then self:reload() end
    end,

    reload = function(self)
        self.lock = true 
        print("reloading")

        self.bulletCount = 0

        self.lock = false
    end,
    
    kill = function(self)
        beholder.stopObserving(self)
        world:remove(self)
        self.destroy = true
    end,

    spawnShield = function(self)
        if self.lock then return end

        table.insert(entities, shield:create({
            x = self.x + self.originX + 20 * self.facing,
            y = self.y
        }, self))
    end,

    crouch = function(self)
        if self.lock then return end

        self.crouched = not self.crouched

        if not (self.crouched) then 
            self.y = self.y - self.graphicHeight / 2
        end

        world:update(
            self, 
            self.x, 
            self.y + (self.graphicHeight / 2) * boolToInt(self.crouched), 
            self.graphicWidth, 
            self.graphicHeight / (1 + boolToInt(self.crouched))
        )
    
        if (self.crouched) then 
            self.y = self.y + self.graphicHeight / 2
        end
    end,

    jump = function(self)
        if self.crouched then return end

        print("jumped")
        self.yVel = -self.jumpSpeed
    end
}

return Player
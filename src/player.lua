require 'utility'
local bullet = require('bullet')
local shield = require('shield')

local Player = {
    speed = 350,
    graphicWidth = 32,
    graphicHeight = 64,
    color = {255, 0, 0, 255},
    collisionId = "player",
    destroy = false,
    lock = false,
    crouched = false,
    
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
    gunPos = 0,

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
        -- BODY
        love.graphics.setColor(self.color)
        love.graphics.rectangle(
            "fill", 
            self.x, 
            self.y, 
            self.graphicWidth, 
            self.graphicHeight
        )

        -- GUN
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.rectangle(
            'fill', 
            self.x + 8 * self.facing, 
            self.y + self.graphicHeight/2 * self.gunPos,
            16, 8
        )
    end,

    update = function(self, dt)
        self.xVector = (boolToInt(love.keyboard.isDown(self.controlScheme[1])) - boolToInt(love.keyboard.isDown(self.controlScheme[2]))) * boolToInt(not self.lock)

        local actualX, actualY, cols, len = world:move(
            self, 
            self.x + (self.xVector * self.speed) * dt, 
            self.y
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
            x=self.x + 32 * self.facing,                    -- margen de 16 para que no colisione con el que lo disparó (temporal)
            y=self.y + self.graphicHeight/2 * self.gunPos, 
            direction=self.facing
        }))
    end,
    
    kill = function(self)
        beholder.stopObserving(self)
        world:remove(self)
        self.destroy = true
    end,

    spawnShield = function(self)
        table.insert(entities, shield:create({
            x = self.x + (self.graphicWidth + 2) * self.facing,
            y = self.y
        }, self))
    end,

    crouch = function(self)
        print(self.crouched)
        self.crouched = not self.crouched

        if (self.crouched) then 
            self.graphicHeight = 32 
        else 
            self.graphicHeight = 64 
        end
    end
}

return Player
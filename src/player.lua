require 'utility'
local bullet = require('bullet')

local Player = {
    speed = 350,
    graphicWidth = 32,
    graphicHeight = 64,
    color = {255, 0, 0, 255},
    
    -- Dependientes de la instancia --> función create()
    -- Mantenidos acá como referencia
    x,
    y,
    facing,
    collider,
    controlScheme,
    shootId,
    playerId,
    --destroy = false,

    -- Manejados por la función update()
    xVector = 0,
    gunPos = 1,

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
        instance.shootId = beholder.observe(
            "SHOOT_PLAYER", instance.playerId, 
            function() instance:shoot() end
        )
        instance.moveGunUpId = beholder.observe(
            "MOVE_GUN_UP", instance.playerId, 
            function() instance:switchGunPos(instance.gunPos+1) end
        )
        instance.moveGunDownId = beholder.observe(
            "MOVE_GUN_DOWN", instance.playerId,
            function() instance:switchGunPos(instance.gunPos-1) end
        )

        setmetatable(instance, self)
        self.__index = self

        return instance
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
            self.y - ((self.graphicHeight/2) * self.gunPos) + self.graphicHeight+32, -- hack temporal hasta que aprenda matematica
            16, 8
        )
    end,

    update = function(self, dt)
        self.xVector = boolToInt(love.keyboard.isDown(self.controlScheme[1])) - boolToInt(love.keyboard.isDown(self.controlScheme[2]))

        local actualX, actualY, cols, len = world:move(
            self, 
            self.x + (self.xVector * self.speed) * dt, 
            self.y
        )
        self.x, self.y = actualX, actualY
    end,

    switchGunPos = function(self, pos)
        if (pos < 1 or pos > 3) then return end
        
        self.gunPos = pos
    end,

    shoot = function(self)
        table.insert(entities, bullet:create({
            x=self.x, 
            y=self.y, 
            direction=self.facing
        }))
    end,

    test = function(self)
        print(x)
    end
}

return Player
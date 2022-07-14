beholder = require('lib.beholder')
local world = require('world')
local player = require('player')
local inputHandler = require('inputHandler')

entities = {}
entityDestroyQueue = {}
numberOfEntities = 0

function love.load()
    world:load()
    
    table.insert(entities, player:create({
        x = 32, 
        y = love.graphics.getHeight()-64,
        controlScheme = {"right", "left"},
        playerId = 0
    }))
    table.insert(entities, player:create({
        x = love.graphics.getWidth()-64, 
        y = love.graphics.getHeight()-64, 
        controlScheme = {"d", "a"},
        playerId = 1
    }))
end

function love.draw()
    world:draw()

    for x = 1, #entities do
        entities[x]:draw()
    end
end

function love.update(dt)
    world:update(dt)

    print(#entities)
    --[[
    for i, v in ipairs(entities) do
        entities[i]:update(dt)
    end]]

    for x = #entities, 1, -1 do
        if (entities[x].destroy) then 
            table.remove(entities, x)
        else 
            entities[x]:update(dt)
        end
    end
end
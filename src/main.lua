beholder = require('lib.beholder')
cron = require('lib.cron')
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
        y = love.graphics.getHeight()-104,
        controlScheme = {"d", "a"},
        playerId = 1
    }))
    table.insert(entities, player:create({
        x = love.graphics.getWidth()-64, 
        y = love.graphics.getHeight()-104, 
        controlScheme = {"right", "left"},
        playerId = 0
    }))
end

function love.draw()
    world:draw()

    for x = 1, #entities do
        entities[x]:draw()
    end
end

function love.update(dt)
    for x = #entities, 1, -1 do
        if (entities[x].destroy) then 
            table.remove(entities, x)
        else 
            entities[x]:update(dt)
        end
    end
end
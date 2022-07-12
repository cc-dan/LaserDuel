beholder = require('lib.beholder')
local world = require('world')
local player = require('player')
local inputHandler = require('inputHandler')

local entities = {}

function love.load()
    table.insert(entities, player:create({
        x = 32, 
        y = 0, 
        controlScheme = {"right", "left"},
        playerId = 0
    }))
    table.insert(entities, player:create({
        x = love.graphics.getWidth()-64, 
        y = 0, 
        controlScheme = {"d", "a"},
        playerId = 1
    }))

    world:load()
end

function love.draw()
    world:draw()

    for x = 1, #entities do
        entities[x]:draw()
    end
end

function love.keypressed(key)

end

function love.update(dt)
    world:update(dt)

    --inputHandler.keyPress['shoot_player1']()

    for x = 1, #entities do
        entities[x]:update(dt)
    end
end
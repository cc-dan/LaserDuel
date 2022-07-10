local world = require('world')
local player = require('player')
local bullet = require('bullet')

function love.load()
    player1 = player:create({
        x = 32, 
        y = 0, 
        controlScheme = {"right", "left"}
    })
    player2 = player:create({
        x = love.graphics.getWidth()-64, 
        y = 0, 
        controlScheme = {"d", "a"}
    })

    world:load()
end

function love.draw()
    world:draw()

    player1:draw()
    player2:draw()

    bullet:draw()
end

function love.update(dt)
    world:update(dt)

    player1:update(dt)
    player2:update(dt)

    bullet:update(dt)
end
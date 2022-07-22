local InputHandler = {
    -- Keycode strings --> action strings
    keys = {
        -- PLAYER 1
        rctrl='shoot_p1',
        up='moveGun_up_p1',
        down='moveGun_down_p1',
        rshift='spawnShield_p1',
        ralt='crouch_p1',

        -- PLAYER 2
        f='shoot_p2',
        w='moveGun_up_p2',
        s='moveGun_down_p2',
        g='spawnShield_p2'
    },
    keyReleased = {
        -- PLAYER 1
        ralt='crouch_p1'
    },

    -- Action string --> closures
    keyPress = {
        -- PLAYER 1
        shoot_p1=function()
            beholder.trigger("SHOOT_PLAYER", 0)
        end,
        moveGun_up_p1=function()
            beholder.trigger("MOVE_GUN_UP", 0)
        end,
        moveGun_down_p1=function()
            beholder.trigger("MOVE_GUN_DOWN", 0)
        end,
        spawnShield_p1=function()
            beholder.trigger("SPAWN_SHIELD", 0)
        end,
        crouch_p1=function()
            beholder.trigger("CROUCH", 0)
        end,

        -- PLAYER 2
        shoot_p2=function()
            beholder.trigger("SHOOT_PLAYER", 1)
        end,
        moveGun_up_p2=function()
            beholder.trigger("MOVE_GUN_UP", 1)
        end,
        moveGun_down_p2=function()
            beholder.trigger("MOVE_GUN_DOWN", 1)
        end,
        spawnShield_p2=function()
            beholder.trigger("SPAWN_SHIELD", 1)
        end
    },

    keyRelease = {
        -- PLAYER 1
        crouch_p1=function()
            beholder.trigger("CROUCH", 0)
        end
    }
}

function love.keypressed(key)
    local actionString = InputHandler.keys[key]

    if actionString then
        InputHandler.keyPress[actionString]()
    end
end

function love.keyreleased(key)
    local actionString = InputHandler.keyReleased[key]

    if actionString then 
        InputHandler.keyRelease[actionString]()
    end
end

return InputHandler
local InputHandler = {
    -- Keycode strings --> action strings
    keys = {
        -- PLAYER 1
        rctrl='shoot_p1',
        up='moveGun_up_p1',
        down='moveGun_down_p1',

        -- PLAYER 2
        f='shoot_p2',
        w='moveGun_up_p2',
        s='moveGun_down_p2'
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

        -- PLAYER 2
        shoot_p2=function()
            beholder.trigger("SHOOT_PLAYER", 1)
        end,
        moveGun_up_p2=function()
            beholder.trigger("MOVE_GUN_UP", 1)
        end,
        moveGun_down_p2=function()
            beholder.trigger("MOVE_GUN_DOWN", 1)
        end
    }
}

function love.keyreleased(key)
    local actionString = InputHandler.keys[key]

    if actionString then
        InputHandler.keyPress[actionString]()
    end
end

return InputHandler
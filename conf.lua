function love.conf(t)
    -- The name of the save directory (string)
    t.identity = "data/saves" 
    t.version = "11.5" -- The LÖVE version this game was made for (string)

    -- Set the window title
    t.window.title = "Kuxan peli :D"

    -- Set the window size
    t.window.width = 800
    t.window.height = 600

    -- Set the window resizable
    t.window.resizable = true

    -- Set the window vsync
    t.window.vsync = true

    -- Set the background color
    t.window.backgroundColor = {0.5, 0.5, 0.5, 1}
end
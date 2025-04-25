_G.love = require("love")

-- Example: Firing objects towards mouse
--[[Description:
Uses basic physics formulas to determine each bullet position.
Auto removes off-screen Bullets.
]]

function love.load()
    SPEED = 250
    
    -- Enable vsync
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    StartPos = {
        x = (screenWidth - 50) / 2, -- Center horizontally (subtract width of rectangle)
        y = (screenHeight - 50) / 2, -- Center vertically (subtract height of rectangle)
        width = 50,
        height = 50
    }	
    Bullets={}										--The table that contains all Bullets.
    BulletCount = 0								--The number of bullets that have been fired.
    NearMissCount = 0 -- Counter for near misses.
    HighScore = 0


    -- Set background color to gray
    love.graphics.setBackgroundColor(0.5, 0.5, 0.5, 1)
    love.graphics.setFont(love.graphics.newFont(11))
end

function love.draw()
	--Sets the color to red and draws the "Bullets".
	love.graphics.setColor(1, 0, 0)

    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
	
	-- This loops the whole table to get every bullet. Consider v being the bullet.
    for i, v in pairs(Bullets) do
        love.graphics.circle("fill", v.x, v.y, 4, 4)
    end

    -- Sets the color to white and draws the "player" and writes instructions.
    love.graphics.setColor(1, 1, 1)

    love.graphics.print("Left click to fire towards the mouse.", 50, 50)
    love.graphics.print("Bullets created: " .. BulletCount, 50, 70) -- Display the bullet count.
    love.graphics.print("Near misses: " .. NearMissCount, 50, 90) -- Display the near miss count.
    love.graphics.print("High score: " .. HighScore, 50, 110) -- Display the high score.
    love.graphics.rectangle("line", StartPos.x, StartPos.y, StartPos.width, StartPos.height)

    -- Draw the circle around the mouse
    local mouseX, mouseY = love.mouse.getPosition()
    love.graphics.setColor(0, 1, 0) -- Green color for the circle
    love.graphics.circle("line", mouseX, mouseY, 20) -- Circle with radius 20
end

function love.update(dt)
	
	-- Adjust the speed dynamically based on the BulletCount
    local dynamicSpeed = SPEED + (BulletCount * 10) -- Increase speed by 10 for each bullet fired

    if love.mouse.isDown(1) then
        -- Sets the starting position of the bullet, this code makes the Bullets start in the middle of the player.
        local startX = StartPos.x + StartPos.width / 2
        local startY = StartPos.y + StartPos.height / 2

        local targetX, targetY = love.mouse.getPosition()

        -- Basic maths and physics, calculates the angle so the code can calculate deltaX and deltaY later.
        local angle = math.atan2((targetY - startY), (targetX - startX))

        -- Creates a new bullet and appends it to the table we created earlier.
        Newbullet = {x = startX, y = startY, angle = angle}
        table.insert(Bullets, Newbullet)

        -- Increment the bullet count
        BulletCount = BulletCount + 1
    end
	
	for i, v in pairs(Bullets) do
        local Dx = dynamicSpeed * math.cos(v.angle) -- Physics: deltaX is the change in the x direction.
        local Dy = dynamicSpeed * math.sin(v.angle)
        v.x = v.x + (Dx * dt)
        v.y = v.y + (Dy * dt)

        -- Check if the bullet touches the mouse
        local mouseX, mouseY = love.mouse.getPosition()
        local distance = math.sqrt((v.x - mouseX)^2 + (v.y - mouseY)^2)

        if distance < 20 then
            NearMissCount = NearMissCount + 1 
        end

        if distance < 4 then -- Assuming the bullet radius is 4
            if BulletCount > HighScore then
                HighScore = BulletCount
            end

            BulletCount = 0 -- Reset the bullet count
            Bullets = {} -- Clear all bullets
            break -- Exit the loop since we reset everything
        end
		
		--Cleanup code, removes Bullets that exceeded the boundries:
		
		if v.x > love.graphics.getWidth() or
		   v.y > love.graphics.getHeight() or
		   v.x < 0 or
		   v.y < 0 then
			table.remove(Bullets,i)
		end
	end
end
-- Player.lua

local Player = {}
Player.__index = Player
local soul = require("lua/soul")

function Player.new(x, y)
    local self = setmetatable({}, Player)

    self.x = x
    self.y = y
    self.speed = 100

    self.direction = "down"
    self.moving = false

    self.frameTimer = 0

    -- Animation speeds
    self.frameSpeed = 0.20
    self.horizontalFrameSpeed = 0.20

    self.frameIndex = 1

    -- Primary movement direction
    self.primaryDirection = nil

    local spritePath = "Assets/sprites/overworld/Player/"

    self.sprites = {
        down = {
            love.graphics.newImage(spritePath .. "Friskstanddown.png"),
            love.graphics.newImage(spritePath .. "Friskwalkdown1.png"),
            love.graphics.newImage(spritePath .. "Friskstanddown.png"),
            love.graphics.newImage(spritePath .. "Friskwalkdown2.png"),
        },

        left = {
            love.graphics.newImage(spritePath .. "Friskstandleft.png"),
            love.graphics.newImage(spritePath .. "Friskwalkleft.png"),
        },

        right = {
            love.graphics.newImage(spritePath .. "Friskstandright.png"),
            love.graphics.newImage(spritePath .. "Friskwalkright.png"),
        },

        up = {
            love.graphics.newImage(spritePath .. "Friskstandup.png"),
            love.graphics.newImage(spritePath .. "Friskwalkup1.png"),
            love.graphics.newImage(spritePath .. "Friskstandup.png"),
            love.graphics.newImage(spritePath .. "Friskwalkup2.png"),
        },
    }

    return self
end


function Player:update(dt)

if (love.keyboard.isDown("x") or love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")) and substate == "Play" then
    self.speed = math.min(self.speed + 1000 * dt, 250)
else
    self.speed = math.max(self.speed - 1000 * dt, 100)
end

    if game.state == "overworld" then

    local wasMoving = self.moving
    self.moving = false

    local left, right, up, down = false, false, false, false

    if substate == "Play" then
        left = love.keyboard.isDown("left")
        right = love.keyboard.isDown("right")
        up = love.keyboard.isDown("up")
        down = love.keyboard.isDown("down")
    end

    local dx = 0
    local dy = 0


    --------------------------------------------------
    -- MOVEMENT
    --------------------------------------------------

    if left and not right then
        dx = -1
    elseif right and not left then
        dx = 1
    end

    if up and not down then
        dy = -1
    elseif down and not up then
        dy = 1
    end


    --------------------------------------------------
    -- CHOOSE PRIMARY ANIMATION DIRECTION
    --------------------------------------------------

    if self.primaryDirection == nil then

        if left and not right then
            self.primaryDirection = "left"

        elseif right and not left then
            self.primaryDirection = "right"

        elseif up and not down then
            self.primaryDirection = "up"

        elseif down and not up then
            self.primaryDirection = "down"
        end
    end


    --------------------------------------------------
    -- KEEP FIRST DIRECTION FOR DIAGONAL MOVEMENT
    --------------------------------------------------

    if self.primaryDirection == "left" then

        if left then
            self.direction = "left"

        else
            if up and not down then
                self.primaryDirection = "up"
                self.direction = "up"

            elseif down and not up then
                self.primaryDirection = "down"
                self.direction = "down"

            else
                self.primaryDirection = nil
            end
        end


    elseif self.primaryDirection == "right" then

        if right then
            self.direction = "right"

        else
            if up and not down then
                self.primaryDirection = "up"
                self.direction = "up"

            elseif down and not up then
                self.primaryDirection = "down"
                self.direction = "down"

            else
                self.primaryDirection = nil
            end
        end


    elseif self.primaryDirection == "up" then

        if up then
            self.direction = "up"

        else
            if left and not right then
                self.primaryDirection = "left"
                self.direction = "left"

            elseif right and not left then
                self.primaryDirection = "right"
                self.direction = "right"

            else
                self.primaryDirection = nil
            end
        end


    elseif self.primaryDirection == "down" then

        if down then
            self.direction = "down"

        else
            if left and not right then
                self.primaryDirection = "left"
                self.direction = "left"

            elseif right and not left then
                self.primaryDirection = "right"
                self.direction = "right"

            else
                self.primaryDirection = nil
            end
        end
    end


    --------------------------------------------------
    -- MOVE
    --------------------------------------------------

    if dx ~= 0 or dy ~= 0 then

        self.moving = true

        self.x = self.x + dx * self.speed * dt
        self.y = self.y + dy * self.speed * dt

        -- Start animation with WALK frame
        if not wasMoving then
            self.frameIndex = 2
            self.frameTimer = 0
        end

    else
        self.moving = false
    end


    --------------------------------------------------
    -- ANIMATION
    --------------------------------------------------

    local frames = self:getFrameSet()

    if self.moving then

        local currentFrameSpeed = self.frameSpeed

        if self.direction == "left"
        or self.direction == "right" then
            currentFrameSpeed = self.horizontalFrameSpeed
        end

        self.frameTimer = self.frameTimer + dt

        if self.frameTimer >= currentFrameSpeed then

            self.frameTimer = self.frameTimer - currentFrameSpeed

            self.frameIndex = self.frameIndex + 1

            if self.frameIndex > #frames then
                self.frameIndex = 1
            end
        end

    else

        -- Standing
        self.frameIndex = 1
        self.frameTimer = 0

    end
end
end
local move = love.audio.newSource("Assets/sound/menumove.ogg", "static")
function Player:keypressed(key)
    if key == "c" or (substate == "submenu" and key == "x") then
    if substate == "Play" then
        substate = "submenu"
        move:play()
    elseif substate == "submenu" then
        substate = "Play"
    end
end
end


function Player:getFrameSet()
    return self.sprites[self.direction] or self.sprites.down
end


function Player:draw()

    local frames = self:getFrameSet()
    local sprite = frames[self.frameIndex] or frames[1]

    love.graphics.draw(
        sprite,
        self.x,
        self.y,
        0,
        2,
        2
    )

    if substate == "submenu" then
--BOX 1
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 36, 50, 135, 102)

        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(6)
        love.graphics.rectangle("line", 36, 50, 135, 102)


-- BOX 2
        love.graphics.setColor(0, 0, 0) -- 158 ori
        love.graphics.rectangle("fill", 36, 165, 135, 142)

        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(6)
        love.graphics.rectangle("line", 36, 165, 135, 142)

--BOX 1 info
        
        local font = love.graphics.newFont("Assets/font/UI.ttf", 16)
        love.graphics.setFont(font)
        love.graphics.setColor(1, 1, 1)    

        love.graphics.print("LV " .. soul.lv .. "\nHP " .. soul.hp .. "/" .. soul.maxhp .. "\nG   " .. soul.G, 48, 95)
        local font = love.graphics.newFont("Assets/font/dete.ttf", 16 *2)
        love.graphics.setFont(font)
        love.graphics.print(soul.name, 48, 60)

--BOX 2 info
        love.graphics.print("ITEM", 78, 187)
        love.graphics.print("STAT", 78, 223) --+36
        love.graphics.print("CELL", 78, 259)
    end
end


return Player
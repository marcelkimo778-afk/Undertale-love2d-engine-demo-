local Hp = {}

local stat = require("lua/stat")

--------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------

local function clamp(value, min, max)
    if value < min then return min end
    if value > max then return max end
    return value
end

local function drawOutlinedText(text, x, y, textColor)
    love.graphics.setColor(0, 0, 0, 1)

    love.graphics.print(text, x + 1, y)
    love.graphics.print(text, x - 1, y)
    love.graphics.print(text, x, y - 1)
    love.graphics.print(text, x, y + 1)

    love.graphics.setColor(
        textColor[1],
        textColor[2],
        textColor[3],
        textColor[4] or 1
    )

    love.graphics.print(text, x, y)
end

--------------------------------------------------------------------
-- Load
--------------------------------------------------------------------

function Hp.load()
    Hp.krtimer = 0
    Hp.krdelay = 0.3

    Hp.barX = 230
    Hp.barY = 402
    Hp.barH = 23
    Hp.barUnit = 1.35

    Hp.font = love.graphics.newFont("Assets/font/UI.ttf", 24)
    Hp.hpSprite = love.graphics.newImage("Assets/sprites/UI/hp.png")
    Hp.krSprite = love.graphics.newImage("Assets/sprites/UI/kr.png")
end

--------------------------------------------------------------------
-- HP values
--------------------------------------------------------------------

local function getDisplayHP()
    return clamp(
        math.floor(stat.hp + stat.kr),
        0,
        stat.maxhp
    )
end

local function getYellowHP()
    return clamp(
        math.floor(stat.hp),
        0,
        stat.maxhp
    )
end

local function getPurpleHP()
    return clamp(
        getDisplayHP() - getYellowHP(),
        0,
        stat.maxhp
    )
end

--------------------------------------------------------------------
-- HP / KR update
--------------------------------------------------------------------

local function reserveKRSpace()
    local maxYellow = stat.maxhp - stat.kr

    if maxYellow < 0 then
        maxYellow = 0
    end

    if stat.hp > maxYellow then
        stat.hp = maxYellow
    end
end

local function updateKR(dt)
    stat.hp = math.min(stat.hp, stat.maxhp)
    stat.kr = math.max(stat.kr, 0)

    if stat.kr > stat.maxhp - 1 then
        stat.kr = stat.maxhp - 1
    end

    reserveKRSpace()

    if stat.kr > 0 then
        Hp.krtimer =
            Hp.krtimer - dt * (stat.kr / 20)

        if Hp.krtimer <= 0 then
            stat.kr = stat.kr - 1
            Hp.krtimer = Hp.krdelay
        end
    else
        stat.kr = 0
        Hp.krtimer = 0
    end

    if stat.hp < 1 and stat.kr > 0 then
        stat.hp = 1
    elseif stat.hp < 0 then
        stat.hp = 0
    end

    stat.kr = clamp(
        math.floor(stat.kr),
        0,
        stat.maxhp
    )

    reserveKRSpace()
end

--------------------------------------------------------------------
-- Damage
--------------------------------------------------------------------

function Hp.damage(amount)
    stat.hp = stat.hp - amount
end

--------------------------------------------------------------------
-- Draw
--------------------------------------------------------------------

local function drawHealthUI()
    local displayHP = getDisplayHP()
    local yellowHP = getYellowHP()
    local purpleHP = getPurpleHP()

    local barWidth =
        stat.maxhp * Hp.barUnit

    local valueText

    if displayHP < 10 then
        valueText =
            "      " ..
            displayHP ..
            " / " ..
            stat.maxhp
    else
        valueText =
            "     " ..
            displayHP ..
            " / " ..
            stat.maxhp
    end

    local valueColor = {
        1, 1, 1, 1
    }

    if stat.kr > 0 then
        valueColor = {
            0.75, 0.1, 1, 1
        }
    end

    love.graphics.setFont(Hp.font)

    drawOutlinedText(
        stat.name ..
        "  lV " ..
        stat.lv,
        20,
        406,
        {1, 1, 1, 1}
    )

    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.draw(
        Hp.hpSprite,
        220,
        404
    )

    love.graphics.draw(
        Hp.krSprite,
        Hp.barX + barWidth + 37,
        409
    )

    drawOutlinedText(
        valueText,
        Hp.barX + barWidth + 42,
        406,
        valueColor
    )

    -- Empty HP bar
    love.graphics.setColor(1, 0, 0, 1)

    love.graphics.rectangle(
        "fill",
        Hp.barX + 30,
        Hp.barY,
        barWidth,
        Hp.barH
    )

    -- Purple KR portion
    if purpleHP > 0 then
        love.graphics.setColor(
            0.75,
            0.1,
            1,
            1
        )

        love.graphics.rectangle(
            "fill",
            Hp.barX + 30,
            Hp.barY,
            displayHP * Hp.barUnit,
            Hp.barH
        )
    end

    -- Normal HP
    if yellowHP > 0 then
        love.graphics.setColor(
            1,
            1,
            0,
            1
        )

        love.graphics.rectangle(
            "fill",
            Hp.barX + 30,
            Hp.barY,
            yellowHP * Hp.barUnit,
            Hp.barH
        )
    end

    -- Border
    love.graphics.setLineWidth(1)
    love.graphics.setColor(0, 0, 0, 1)

    love.graphics.rectangle(
        "line",
        Hp.barX + 30,
        Hp.barY,
        barWidth,
        Hp.barH
    )
end

--------------------------------------------------------------------
-- Public API
--------------------------------------------------------------------

function Hp.update(dt)
    updateKR(dt)
end

function Hp.draw()
    drawHealthUI()
end

return Hp
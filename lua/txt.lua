local txt = {}

function txt.load()
    txt.texts = {}
    txt.alltxtcounter = 0
end

--FOINTS

local fonts = {}

local function createfont(fontpath, size)
    local key = fontpath .. "_" .. size
    if fonts[key] then
        print("Using cached font:", key)        
        return fonts[key]
    end
      print("Creating new font:", key)
    local newFont = love.graphics.newFont("Assets/font/" .. fontpath .. ".ttf",size)
    fonts[key] = newFont
    return newFont
end

--BUBBLIES

local bubbles = {}

local function createBubble(name)
    if bubbles[name] then
        print("Using cached bubble:", name)
        return bubbles[name]
    end
        print("Creating bubble:", name)
    local img = love.graphics.newImage(
        "Assets/sprites/bub/" .. name .. ".png")
    bubbles[name] = img
    return img
end

function txt.setText(text, speed, x, y, size, fontPath, r, g, b, a, skip, bubble, sound)
    txt.texts = {}

local newText = {
    fulltxt = text,
    currenttxt = "",
    counter = 0,
    x = x,
    y = y,
    waitspeed = speed,
    state = "typing",
    skip = skip or "no",
    color = {r,g,b,a},

    font = createfont(fontPath, size),

    sound = nil,
    bubble = nil,
    bubblestore = bubble
}
    if sound then
        newText.sound = love.audio.newSource(
            "Assets/sound/voice/" .. sound .. ".wav",
            "static"
        )
    end

    if bubble and bubble ~= "nobub" then
    newText.bubble = createBubble(bubble)   
    end

    table.insert(txt.texts,newText)
end



function txt.update(dt)
    for youremom, text in ipairs(txt.texts) do
        if text.state == "typing" then
            text.counter = text.counter + text.waitspeed * dt

            local chars = math.floor(text.counter)

            if chars > #text.fulltxt then
                chars = #text.fulltxt
            end

            if chars ~= (text.lastChars or 0) then
                if text.sound and text.fulltxt:sub(chars, chars) ~= " " then
                    text.sound:stop()
                    text.sound:play()
                end
                    text.lastChars = chars
            end

            text.currenttxt = text.fulltxt:sub(1, chars)

            if text.counter >= #text.fulltxt then
                text.state = "ready"
            end
        end
    end
end



function txt.draw()
    for _,text in ipairs(txt.texts) do

        if text.bubble then
            love.graphics.setColor(1,1,1,1)

            local bx = text.x - 35
            local by = text.y

            if text.bubblestore == "bubble2" then
                bx = text.x - 5
                by = text.y + 7
            elseif text.bubblestore == "bubble3"
            or text.bubblestore == "bubble4"
            or text.bubblestore == "bubble5" then
                bx = text.x - 15
                by = text.y + 5
            end
        
            love.graphics.draw(text.bubble, bx, by)
        end

        love.graphics.setFont(text.font)
        love.graphics.setColor(text.color[1], text.color[2], text.color[3], text.color[4])
        love.graphics.print(text.currenttxt, text.x, text.y + 15)
    end
end

function txt.keypressed(key)
    for i, text in ipairs(txt.texts) do
        if text.state == "typing" then
            if text.skip ~= "noskip"
            and (key == "x" or key == "rshift") then
                text.counter = #text.fulltxt
                text.currenttxt = text.fulltxt
                text.state = "ready"
            end
        elseif text.state == "ready" then
            if key == "z" or key == "return" then
                if text.action then
                    text.action()
                end
                    table.remove(txt.texts, i)
            end
        end
    end
end


return txt
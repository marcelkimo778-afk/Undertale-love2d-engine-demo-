local UI = {}
local Submenu = require("lua.Submenu")

function UI.load()

    menu = {
        select = 1,
        move = love.audio.newSource("Assets/sound/menumove.ogg", "static"),
        selectsound = love.audio.newSource("Assets/sound/snd_select.wav", "static")
    }


    --NORMAL
    menu.fight  = love.graphics.newImage("Assets/sprites/UI/spr_fightbt_center_0.png")
    menu.fight1 = love.graphics.newImage("Assets/sprites/UI/spr_fightbt_center_1.png")

    menu.act    = love.graphics.newImage("Assets/sprites/UI/spr_actbt_center_0.png")
    menu.act1   = love.graphics.newImage("Assets/sprites/UI/spr_actbt_center_1.png")

    menu.item   = love.graphics.newImage("Assets/sprites/UI/spr_itembt_0.png")
    menu.item1  = love.graphics.newImage("Assets/sprites/UI/spr_itembt_1.png")

    menu.mercy  = love.graphics.newImage("Assets/sprites/UI/spr_mercybt_0.png")
    menu.mercy1 = love.graphics.newImage("Assets/sprites/UI/spr_mercybt_1.png")

    --BLANK
    menu.fightbl  = love.graphics.newImage("Assets/sprites/UI/spr_fightbl_center_0.png")
    menu.fightbl1 = love.graphics.newImage("Assets/sprites/UI/spr_fightbl_center_1.png")

    menu.actbl    = love.graphics.newImage("Assets/sprites/UI/spr_actbl_center_0.png")
    menu.actbl1   = love.graphics.newImage("Assets/sprites/UI/spr_actbl_center_1.png")

    menu.itembl   = love.graphics.newImage("Assets/sprites/UI/spr_itembl_0.png")
    menu.itembl1  = love.graphics.newImage("Assets/sprites/UI/spr_itembl_1.png")

    menu.mercybl  = love.graphics.newImage("Assets/sprites/UI/spr_mercybl_0.png")
    menu.mercybl1 = love.graphics.newImage("Assets/sprites/UI/spr_mercybl_1.png")
end


function UI.update(dt)
    if menu.select > 4 then menu.select = 1 end
    if menu.select < 1 then menu.select = 4 end
end


function UI.keypressed(key)

    if game.state == "menu" then

        if key == "right" then
            menu.move:play()
            menu.select = math.min(menu.select + 1, 5)

        elseif key == "left" then
            menu.move:play()
            menu.select = math.max(menu.select - 1, 0)

        elseif key == "z" or key == "return" then

            if menu.select == 1 then
                if #Fight > 0 then
                game.state = "subFight"
                end
            elseif menu.select == 2 then
                if #Act > 0 then
                game.state = "subAct"
                end
            elseif menu.select == 3 then
                if #Item > 0 then
                game.state = "Item"
                end
            elseif menu.select == 4 then
                if #Mercy > 0 then
                game.state = "Mercy"
                end
            end

            menu.selectsound:play()
            submenu.index = 1
        end

        return
    end

    if key == "z" or key == "return" then
        if game.state == "Act" then
            game.state = "Acttxt"
            menu.selectsound:play()
        end

        if game.state == "Item" then
            game.state = "Itemtxt"
            menu.selectsound:play()
        end

        if game.state == "Mercy" then
            game.state = "Mercytxt"
            menu.selectsound:play()
        end

        if game.state == "subFight" then
            game.state = "Fight"
            menu.selectsound:play()
        end

        if game.state == "subAct" then
            game.state = "Act"
            menu.selectsound:play()
        end
        
    end
            if (game.state == "Act"
            or game.state == "Item"
            or game.state == "Mercy"
            or game.state == "subFight"
            or game.state == "subAct")
            and (key == "x" or key == "rshift") then
                game.state = "menu"
                menu.move:play()
            end
end

function UI.draw()

    local X = 432

local fightSprite
local actSprite
local itemSprite
local mercySprite

if #Fight == 0 then
    if menu.select == 1 and (game.state == "menu" or game.state == "Act" or game.state == "subAct" or game.state == "Item" or game.state == "Mercy" or game.state == "subFight") then
        fightSprite = menu.fightbl1
    else
        fightSprite = menu.fightbl
    end
elseif menu.select == 1 and (game.state == "menu" or game.state == "Act" or game.state == "subAct" or game.state == "Item" or game.state == "Mercy" or game.state == "subFight") then
    fightSprite = menu.fight1
else
    fightSprite = menu.fight
end


if #Act == 0 then
    if menu.select == 2 and (game.state == "menu" or game.state == "Act" or game.state == "subAct" or game.state == "Item" or game.state == "Mercy" or game.state == "subFight") then
        actSprite = menu.actbl1
    else
        actSprite = menu.actbl
    end
elseif menu.select == 2 and (game.state == "menu" or game.state == "Act" or game.state == "subAct" or game.state == "Item" or game.state == "Mercy" or game.state == "subFight") then
    actSprite = menu.act1
else
    actSprite = menu.act
end


if #Item == 0 then
    if menu.select == 3 and (game.state == "menu" or game.state == "Act" or game.state == "subAct" or game.state == "Item" or game.state == "Mercy" or game.state == "subFight") then
        itemSprite = menu.itembl1
    else
        itemSprite = menu.itembl
    end
elseif menu.select == 3 and (game.state == "menu" or game.state == "Act" or game.state == "subAct" or game.state == "Item" or game.state == "Mercy" or game.state == "subFight") then
    itemSprite = menu.item1
else
    itemSprite = menu.item
end


if #Mercy == 0 then
if menu.select == 4 and (game.state == "menu" or game.state == "Act" or game.state == "subAct" or game.state == "Item" or game.state == "Mercy" or game.state == "subFight") then
        mercySprite = menu.mercybl1
    else
        mercySprite = menu.mercybl
    end
elseif menu.select == 4 and (game.state == "menu" or game.state == "Act" or game.state == "subAct" or game.state == "Item" or game.state == "Mercy" or game.state == "subFight") then
    mercySprite = menu.mercy1
else
    mercySprite = menu.mercy
end

    love.graphics.setColor(1,1,1,1)

    love.graphics.draw(fightSprite, 20, X)
    love.graphics.draw(actSprite, 190, X)
    love.graphics.draw(itemSprite, 350, X)
    love.graphics.draw(mercySprite, 510, X)

end


return UI
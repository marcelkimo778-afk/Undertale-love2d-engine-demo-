local Submenu = {}


--you can have "" that for nothing i use it for spare 
function Submenu.load()
Fight = {
    "* Enemy",
}
Act = {
    "* Check",
    "* Talk",
    "* Pose",
    "* Command",
    "* Act5",
    "* something",
}
subAct = {
    "* Enemy",
}
Item = {
    "* Pie",
}
Mercy = {
    "* Spare",
    " ",
    "* Flee",
}
submenu = {
    index = 0,
    page = 0,
}
end

function Submenu.update(dt)

local list = nil

if game.state == "Act" then
    list = Act
elseif game.state == "subFight" then
    list = Fight
elseif game.state == "Item" then
    list = Item
elseif game.state == "Mercy" then
    list = Mercy
elseif game.state == "subAct" then
    list = subAct
end

if list and #list > 0 then

    local itemsPerPage = 4
    local maxPages = math.max(1, math.ceil(#list / itemsPerPage))

    submenu.index = math.max(1, math.min(submenu.index, #list))

    submenu.page = math.floor((submenu.index - 1) / itemsPerPage)

else
    submenu.page = 0
    submenu.index = 1
end

end


function Submenu.keypressed(key)
    local stateLists = {
        Act      = Act,
        subFight = Fight,
        Item     = Item,
        Mercy    = Mercy,
        subAct   = subAct
    }

    local list = stateLists[game.state]
    if not list or #list == 0 then return end

    local oldIndex = submenu.index
    local oldPage  = submenu.page

    local itemsPerPage = 4
    local maxPages = math.ceil(#list / itemsPerPage)

    local posInPage = (submenu.index - 1) % itemsPerPage
    local col = posInPage % 2
    local row = math.floor(posInPage / 2)

    local function trySet(newPage, newCol, newRow)
        local newPos = newRow * 2 + newCol
        local newIndex = newPage * itemsPerPage + newPos + 1

        if list[newIndex] and list[newIndex] ~= " " then
            submenu.page = newPage
            submenu.index = newIndex
        end
    end

    if key == "right" then
        if col == 0 then
            trySet(submenu.page, 1, row)
        elseif col == 1 then
            if submenu.page < maxPages - 1 then
                if submenu.index == submenu.page * itemsPerPage + 4 then
                    local savedIndex = submenu.index
                    local savedPage  = submenu.page
                    trySet(submenu.page + 1, 0, 1)
                    if submenu.index == savedIndex and submenu.page == savedPage then
                        trySet(submenu.page + 1, 0, 0)
                    end
                else
                    trySet(submenu.page + 1, 0, row)
                end
            elseif submenu.page == maxPages - 1 then
                if row == 0 then
                    -- index 2 on last page -> first page, index 1
                    local targetIndex = 1
                    if list[targetIndex] and list[targetIndex] ~= " " then
                        submenu.page = 0
                        submenu.index = targetIndex
                    end
                elseif row == 1 then
                    -- index 4 on last page -> first page, try index 3 fallback index 1
                    local target3 = 3
                    local target1 = 1
                    if list[target3] and list[target3] ~= " " then
                        submenu.page = 0
                        submenu.index = target3
                    elseif list[target1] and list[target1] ~= " " then
                        submenu.page = 0
                        submenu.index = target1
                    end
                end
            end
        end

    elseif key == "left" then
        if col == 1 then
            trySet(submenu.page, 0, row)
        elseif col == 0 then
            if submenu.page > 0 then
                trySet(submenu.page - 1, 1, row)
            elseif submenu.page == 0 then
                if row == 0 then
                    local lastPage = maxPages - 1
                    local targetIndex = lastPage * itemsPerPage + 2
                    if list[targetIndex] and list[targetIndex] ~= " " then
                        submenu.page = lastPage
                        submenu.index = targetIndex
                    end
                elseif row == 1 then
                    local lastPage = maxPages - 1
                    local target4 = lastPage * itemsPerPage + 4
                    local target2 = lastPage * itemsPerPage + 2
                    if list[target4] and list[target4] ~= " " then
                        submenu.page = lastPage
                        submenu.index = target4
                    elseif list[target2] and list[target2] ~= " " then
                        submenu.page = lastPage
                        submenu.index = target2
                    end
                end
            end
        end

    elseif key == "down" then
        if row == 0 then
            trySet(submenu.page, col, 1)
        elseif row == 1 then
            local targetIndex = submenu.page * itemsPerPage + 1 + col
            if list[targetIndex] and list[targetIndex] ~= " " then
                submenu.index = targetIndex
            end
        end

    elseif key == "up" then
        if row == 1 then
            trySet(submenu.page, col, 0)
        elseif row == 0 then
            local targetIndex = submenu.page * itemsPerPage + 3 + col
            if list[targetIndex] and list[targetIndex] ~= " " then
                submenu.index = targetIndex
            end
        end
    end

    if submenu.index ~= oldIndex or submenu.page ~= oldPage then
        menu.move:play()
    end
end

function Submenu.draw()

local font = love.graphics.newFont("Assets/font/dete.ttf", 16 *2)
love.graphics.setFont(font)

local list = nil

if game.state == "subFight" then
    list = Fight
elseif game.state == "Act" then
    list = Act
elseif game.state == "subAct" then
    list = subAct
elseif game.state == "Item" then
    list = Item
elseif game.state == "Mercy" then
    list = Mercy
end

if list then
    local start = submenu.page * 4

    printOutlined(
       (list[start + 1] or "") .. "\n" ..
        (list[start + 3] or ""),
        100, 265
    )
    printOutlined(
        (list[start + 2] or "") .. "\n" ..
        (list[start + 4] or ""), 425, 265
    )
    if math.ceil(#list / 4) > 1 then
        printOutlined(
            "\n\n  PAGE " .. submenu.page, 425, 265
        )
    end
end

end

return Submenu
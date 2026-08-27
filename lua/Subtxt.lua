local subtxt = {}
local txt = require("lua/txt")
local soul = require("lua/soul")

local heals = love.audio.newSource("Assets/sound/snd_heal_c.wav", "static")

local function heal(amount)
    soul.hp = math.min(soul.hp + amount, soul.maxhp - soul.kr)
end

local dialogue = {

    ["* Check"] = {
        {"* You check out the monster:)", 9, 50, 245, 32, "dete", {1,1,1,1}, "skp", "nobub", "UI"},
        {"* ...", 1, 50, 245, 32, "Papy", {1,1,1,1}, "skp", "nobub", "UI"},
        {"* hear me out!...", 9, 50, 245, 32, "Papy", {1,1,1,1}, "skp", "nobub", "UI"},
        {"* 32 HP and 2 ATT 3 DEF", 9, 50, 245, 32, "dete", {1,1,1,1}, "skp", "nobub", "UI"}
    },


    ["* Pose"] = {
        {"* You POSE for the monster", 9, 50, 245, 32, "dete", {1,1,1,1}, "skp", "nobub", "UI"},
        {"* no reaction", 9, 50, 245, 32, "dete", {1,0,0,1}, "skp", "nobub", "UI"},
        {"* You can't decide on how it should\nDIE...", 9, 50, 245, 32, "dete", {1,0,0,1}, "skp", "nobub", "UI"}
    },


    ["* Talk"] = {
        {"* You ask the monster on how\nit's day is?", 9, 50, 245, 32, "dete", {1,1,1,1}, "skp", "nobub", "UI"},
        {"* again...", 9, 50, 245, 32, "dete", {1,0,0,1}, "skp", "nobub", "UI"},
        {"* no reaction...", 9, 50, 245, 32, "dete", {1,0,0,1}, "skp", "nobub", "UI"}
    },


    ["* Command"] = {
        {"* You COMMAND the Monster to be\nyour'e Femboy", 9, 50, 245, 32, "dete", {1,1,1,1}, "skp", "nobub", "UI"},
        {"* ...\nGood boy >:)", 9, 50, 245, 32, "dete", {1,0,0,1}, "skp", "nobub", "UI"}
    },

    ["* Spare"] = {
        {"* You try to SPARE the monster...", 9, 50, 245, 32, "dete", {1,1,1,1}, "skp", "nobub", "UI"},
        {"* The monster doesn't understand...", 9, 50, 245, 32, "dete", {1,0,0,1}, "skp", "nobub", "UI"}
    },


    ["* Flee"] = {
        {"* You try to FLEE...", 9, 50, 245, 32, "dete", {1,1,1,1}, "skp", "nobub", "UI"},
        {"* ... FAIL", 9, 50, 245, 32, "dete", {1,1,1,1}, "noskip", "nobub", "UI"}
    },


    ["* Pie"] = {
    {"* You throw a PIE at the monster.", 9, 50, 245, 32, "dete", {1,1,1,1}, "skp", "nobub", "UI"},
    {"* The monster looks confused...", 9, 50, 245, 32, "Papy", {1,0,0,1}, "skp", "nobub", "UI"},
    {"* It smells like pie now.", 9, 50, 245, 32, "dete", {1,1,1,1}, "skp", "nobub", "UI",
        function()
            heal(30)
            heals:play() 
            removeValue(Item, "* Pie")
        end},
},

}




function subtxt.update(dt)
    if game.state ~= "Acttxt"
    and game.state ~= "Itemtxt"
    and game.state ~= "Mercytxt" then
        return
    end

    if #txt.texts > 0 then
        return
    end

    local action = dialogue[game.indexselect]
    if not action then
        game.state = "evade"
        txt.alltxtcounter = 0 
        return
    end

    local line = action[txt.alltxtcounter + 1]

    if not line then
        txt.alltxtcounter = 0
        game.state = "evade"
        return
    end

txt.setText(
    line[1],
    line[2],
    line[3],
    line[4],
    line[5],
    line[6],
    line[7][1],
    line[7][2],
    line[7][3],
    line[7][4],
    line[8],
    line[9],
    line[10]
)

txt.texts[1].action = line[11]


if line[11] then
    txt.texts[1].action = line[11]
end

    txt.alltxtcounter = txt.alltxtcounter + 1
end

return subtxt
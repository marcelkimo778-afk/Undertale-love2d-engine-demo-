local runner = {}

runner.index = 0
runner.lines = nil
runner.running = false
runner.onComplete = nil

local txt

function runner.load(textSystem)
    txt = textSystem
end

function runner.play(lines, onComplete)
    runner.lines = lines
    runner.onComplete = onComplete
    runner.index = 1
    runner.running = true
    runner.next()
end

function runner.next()
    local line = runner.lines[runner.index]

    if not line then
        runner.running = false
        runner.lines = nil
        runner.index = 0

        local cb = runner.onComplete
        runner.onComplete = nil

        if cb then
            cb()
        end

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
end

function runner.update(dt)
    if runner.running and #txt.texts == 0 then
        runner.index = runner.index + 1
        runner.next()
    end
end

return runner
--WAIT
wait(2,
-- 2 = time to wait in seconds

function()
-- function = the code that runs after waiting

    soul.speed = 200
    -- the action that happens after the wait

end)
-- end = closes the function
-- ) = closes wait()

--WAIT_UNTIL

local example variable = 200

waituntil(
    function() --to run code
        return --to keep asking until true
        example variable == 200 --the if statment just imagine an if before that
    end --close the function
    function() --this function will only run when condition is true
        print("youre gay") --write anything you want
    end) --end function














19877d28 22fe9ca5
19877d44 19877e88 19877d48

##example



##togever
waituntil(
    function() 
        return soul.speed == 200 
        -- checks every frame: "is soul.speed equal to 200?"
        -- if yes, the action below starts
    end,

    function() -- starts the action when the condition is true
        print("ytrue")
        -- runs immediately when soul.speed becomes 200

        wait(2, function() -- waits 2 seconds, then runs this function
            soul.speed = 100
            -- changes the speed to 100 after the 2 second wait

            print("soulspeed = 100")
            -- prints that the speed changed

            wait(5, function() -- waits another 5 seconds AFTER the first wait finishes
                soul.speed = 200
                -- changes the speed back to 200

                print("soulspeed = 200")
                -- prints that the speed changed back
            end) -- ends the 5 second wait function

        end) -- ends the 2 second wait function

    end -- ends the action function
)
-- ends the waituntil function call

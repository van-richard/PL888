local hook = require("Hook")

function myMsgHook(kind,a)
    if (kind == "avail") then

        table.insert(a,1,"This system has ...\n")
        -- Here is text that would go at the end of avail:
        a[#a+1] = "yet more blah blah ...\n"
    elseif (kind == "list") then
        table.insert(a,2,"blah blah blah ...\n")
    end
    return a
end

hook.register("msgHook", myMsgHook)

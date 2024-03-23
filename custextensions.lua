function table.CreateIterator (t)
    local i = 0
    local n = table.getn(t)
    return function ()
             i = i + 1
             if i <= n then return t[i] end
           end
end

function math.percent(percent,maxvalue)
    if tonumber(percent) and tonumber(maxvalue) then
        return (maxvalue*percent)/100
    end
    return false
end
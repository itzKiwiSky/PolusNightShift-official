return function()
    local table_pool = {}
    function emptyTable()
        local t = table_pool[1]

        if not t then
            return {}
        else
            table.remove(table_pool, 1)
            return t
        end
    end

    function recicleTable(t)
        if t then
            for i in pairs(t) do
                t[i] = nil
            end
    
            toLast(table_pool, t)
        end
    end

    function string.explode(str, div, plain)
        assert(type(str) == "string" and type(div) == "string", "invalid arguments")
        
        local o = emptyTable()
        while true do
            local pos1,pos2 = str:find(div, 1, plain)
    
            if not pos1 then
                o[#o+1] = str
                break
            end
    
            o[#o+1],str = str:sub(1,pos1-1),str:sub(pos2+1)
        end
    
        return o
    end
end
--% Thx AyanoTheFoxy to help improve the toolkit with addons %--

function math.multiply(z, size) return math.floor(z / size) * size end

function math.lerp(a, b, t)
    if a == b then return a
    else
        if math.abs(a - b) < 0.005 then return b
        else return a + (b - a) * t end
    end
end

function math.isPercent(a, b) return a / b * 100 end

function math.onRange(n, max, range) return n / max * range end

function math.round(n, idp) return tonumber(string.format( '%.' .. (idp or 0) .. 'f', n)) end

function math.byteToSize(byte)
    local kb = byte / 1024
    local mb = kb / 1024
    local gb = mb / 1024
    local tb = gb / 1024
    
    if byte > 1024 and kb < 1024 then return math.round(kb, 2) .. "kb"
    elseif kb > 1024 and mb < 1024 then return math.round(mb, 2) .. "mb"
    elseif mb > 1024 and gb < 1024 then return math.round(gb, 2) .. "gb"
    elseif gb > 1024 then return math.round(tb, 2) .. "tb" end
end

function math.dist(x1, x2, y1, y2) return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 2 end

function math.clamp(mode, low, n, high)
    if n == low or n == high then return n
    elseif mode == 'inverse' then
        if n < low or n > high then return n end
    else return math.min(math.max(low, n), high)
    end
end

function math.signed(n)
    if n == 0 or n < 0 then return n
    else return -math.abs(n) end
end

function math.transform(a, b, t) return b / a * t end

function math.root(a, i, n)
    if i == 0 then return 1
    elseif a == 1 then return 1
    elseif a == 0 then return 0
    else return a ^ (n / i) end
end

return math.multiply, math.lerp, math.round, math.onRange, math.dist, math.root, math.isPercent, math.clamp, math.signed, math.transform
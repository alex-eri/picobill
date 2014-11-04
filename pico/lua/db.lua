sql = require "luasql.sqlite3"
sqlite = sql.sqlite3()

raddb = sqlite:connect("/picobill/db/radius.db")

if not raddb then
	error("Failed to connect to radius.db")
end

-- string format, if $ - format as value, if % format as key
function interpSQL(s, tab)
  return (s:gsub('($%b{})', function(w)
        v = tab[w:sub(3, -2)]
        if type(v) == 'string' then return '"' .. v .. '"';
        elseif type(v) == 'number' then return v;
        else return "NULL" end;
    end))
end
-- getmetatable("").__mod = interp
-- end string format

function keypat(kv)
    local keys  = {}
    local pats = {}
    local n = 0
    for k,v in pairs(kv) do
       n=n+1
       keys[n] = k 
       pats[n] = "${"..k.."}"
    end
    return keys,pats    
end


function insertSQL(t,kv)
    local keys,patterns = keypat(kv)
    local req = "INSERT INTO "..t.."("..table.concat(keys,',')..") VALUES ("..table.concat(patterns,',')..");";
    return interpSQL(req,kv);
end

function updateSQL(t,kv)
    local keys,patterns = keypat(kv)
    local sets = {}
    local n=0   
    for i = 1,#keys do
        
        if keys[i] ~= 'id' then
            n=n+1
            sets[n] = keys[i].."="..patterns[i];
            print(sets[n])
        end
    end
    
    local req = "UPDATE "..t.." SET "..table.concat(sets,', ').." WHERE id = ${id} ;"
    return interpSQL(req,kv);
end

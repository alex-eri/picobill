require("uci")

settings = uci.cursor()

sql = require "luasql.sqlite3"
sqlite = sql.sqlite3()

local raddbfile = settings:get('pico','radius','dbfile')
local bildbfile = settings:get('pico','billing','dbfile')

assert(bildbfile)
assert(raddbfile)

raddb = sqlite:connect(raddbfile)
bildb = sqlite:connect(bildbfile)

if not raddb then
	error("Failed to connect to radius db:"..raddbfile)
end
print(raddb)

if not bildb then
	error("Failed to connect to billing db:"..bildbfile)
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

function keypat_op(kv)
    local keys,patterns = keypat(kv)
    local sets = {}
    local n=0   
    for i = 1,#keys do
        
        if keys[i] ~= 'ubus_rpc_session' then
            n = n+1
            m = string.gmatch(keys[i],"([^__]+)")
            field = m() or keys[i]
            op = m() or "="
            sets[n] = field..' '..op..' '..patterns[i];
        end
    end
    return sets
end
-- {... where:{id:12}}
SQL = {

insert = function (t,kv)
    local keys,patterns = keypat(kv)
    local req = "INSERT INTO "..t.."("..table.concat(keys,',')..") VALUES ("..table.concat(patterns,',')..");";
    return interpSQL(req,kv);
end,

update = function (t,kv)
    local sets = keypat_op(kv)
    local req = "UPDATE "..t.." SET "..table.concat(sets,', ').." WHERE id = ${_id} ;"
    return interpSQL(req,kv);
end,

select = function (t,kv)
    local sets = keypat_op(kv)
    local where = ''
    if #sets > 0 then where = " WHERE "..table.concat(sets,' AND ') end
    local req = "SELECT * FROM "..t..where.." ORDER BY id ;"
    return interpSQL(req,kv);
end,

delete = function (t,kv)
    return interpSQL("DELETE FROM "..t.." WHERE id = ${_id}",kv)
end,

}

ubusDB = {
list = function (t,db)
    return function(req,msg)
        --print(db)
        --print(SQL.select(t,msg))
        local cur = db:execute (SQL.select(t,msg));
        --print(cur)
        if not cur then return end
        local row = cur:fetch ({}, "a");
        while row do
            conn:reply(req, row);
            --print(row.id);
            row = cur:fetch (row, "a");
        end
        cur:close()
    end
end,

add = function (t,db) 
    return function(req,msg)
        --print(db)
        --for k,v in pairs(msg) do print(k,v) end
        --print(SQL.insert('nas', msg))
        local cur = db:execute( SQL.insert('nas', msg));
        cur = db:execute ("SELECT last_insert_rowid() as id;")
        local row = cur:fetch ({}, "a");
        conn:reply(req, row);
        cur:close()
    end
end,

remove = function (t,db) 
    return function(req,msg)
        local cur = db:execute( SQL.delete('nas', msg));
        conn:reply(req, {success=cur});
    end
end,

edit = function (t,db) 
    return function(req,msg)
        local cur = db:execute( SQL.update('nas', msg));
        conn:reply(req, {success=cur});
    end
end,
}



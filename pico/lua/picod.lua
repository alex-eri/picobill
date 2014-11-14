#!/usr/bin/env lua

require "ubus"
require "uloop"

uloop.init()

conn = ubus.connect()
if not conn then
	error("Failed to connect to ubus")
end

require "db"
require "nas"


function get_handler(schema)
        local handler={}
        for table, columns in pairs(schema.tables) do
                local path = 'pico.'..schema.section..'.'..table
                local sec = {}
                for fu,deco in pairs(ubusDB) do
                      sec[fu] = {deco(table,schema.db), columns}  
                end
                handler[path] = sec
        end
        return handler
end

nas_handler = get_handler(nas_schema)

conn:add(nas_handler)

uloop.run()

raddb:close()
sqlite:close()


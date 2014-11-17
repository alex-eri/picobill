require "ubus"
require "db"

--[[nas_handler = {
["pico.radius.nas"] = {
        list = {
            ubusDB.list('nas',raddb), {}
        },
        add = {
            ubusDB.add('nas',raddb),
            {   nasname=ubus.STRING,
                shortname=ubus.STRING,
                ["type"]=ubus.STRING,
                ports=ubus.INT32,
                secret=ubus.STRING,
                server=ubus.STRING,
                community=ubus.STRING,
                description=ubus.STRING 
            }
        },
        edit = {
            function(req, msg)
                if not(msg.id) then return end
                raddb:execute( updateSQL('nas', msg));
                
            end, {  id=ubus.INT32,
                    nasname=ubus.STRING,
                    shortname=ubus.STRING,
                    ["type"]=ubus.STRING,
                    ports=ubus.INT32,
                    secret=ubus.STRING,
                    server=ubus.STRING,
                    community=ubus.STRING,
                    description=ubus.STRING 
            }
        
        },
        remove = {
            function(req, msg)
                if not(msg.id) then return end
                raddb:execute( deleteSQL('nas',msg))
            end, {  id=ubus.INT32 }
    }
--}
--}
--]]

nas_schema={
db=raddb,
section='radius',
tables={nas={   id=ubus.INT32,
                nasname=ubus.STRING,
                shortname=ubus.STRING,
                ["type"]=ubus.STRING,
                ports=ubus.INT32,
                secret=ubus.STRING,
                server=ubus.STRING,
                community=ubus.STRING,
                description=ubus.STRING 
            }}
}




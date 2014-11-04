require "ubus"
require "uloop"
require "db"

nas_handler = {
["pico.nas"] = {
        list = {
            function(req)
                cur = assert (raddb:execute ("SELECT * from nas ORDER BY id;"));
                row = cur:fetch ({}, "a");
                while row do
                    conn:reply(req, row);
                    row = cur:fetch (row, "a");
                end
                cur:close()
            end, {}
        },
        add = {
            function(req, msg)
                assert(msg.nasname and msg.secret)
                raddb:execute( insertSQL('nas', msg) );
            end, {  nasname=ubus.STRING,
                    shortname=ubus.STRING,
                    ["type"]=ubus.STRING,
                    ports=ubus.INT32,
                    secret=ubus.STRING,
                    server=ubus.STRING,
                    community=ubus.STRING,
                    description=ubus.STRING 
            }
        },
        update = {
            function(req, msg)
                assert(msg.id)
                print(updateSQL('nas', msg))
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
                assert(msg.id)
                raddb:execute( interpSQL([[DELETE FROM nas WHERE id = ${id}]],msg))
            end, {  id=ubus.INT32 }
    }
}
}


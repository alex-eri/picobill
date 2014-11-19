require "ubus"
require "db"

local radius_schema={
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
            },
        radacct={},
        radcheck={},
        radgroupcheck={},
        radgroupreply={},
        radreply={},
        radusergroup={},
        radpostauth={}
        
        }
}


conn:add(get_handler(radius_schema))


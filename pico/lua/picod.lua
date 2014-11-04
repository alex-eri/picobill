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

assert(nas_handler)
conn:add(nas_handler)

uloop.run()

raddb:close()
sqlite:close()


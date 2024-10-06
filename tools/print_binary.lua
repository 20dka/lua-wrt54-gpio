#!/usr/bin/lua

local bit = require('bit')

local len = tonumber(arg[1]) or '*a'
local str = io.read(len)
--local str = string.char(1)


local function convert_byte_to_binary_string(byte)
	local out = ''
	for i=7,0,-1 do
		out = out .. (bit.band(byte, bit.lshift(1, i)) > 0 and '1' or '0')
	end
	return out
end


for i=1, string.len(str) do
	local c = string.sub(str, i, i)
	local b = string.byte(c)
	print('0b' .. convert_byte_to_binary_string(b))
end
		

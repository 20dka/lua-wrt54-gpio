#!/usr/bin/lua

local bits = arg[1] == '-' and io.read() or arg[1]

local function binary_to_byte(bits)
	local out = 0

	for i=1, 8 do
		local b = string.sub(bits, i, i)
		out = out + (b == '1' and 2^(8-i) or 0)
	end

	return string.char(out)
end

local len = string.len(bits)

for i=1, len, 8 do
	local bit = string.sub(bits, i, i+7)
	io.write(binary_to_byte(bit))
end

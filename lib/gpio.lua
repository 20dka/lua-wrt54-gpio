-- bleat :3
local M = { handles = {} }

M.pins = {
	FRONT_BUTTON = 4, 
	RESET_BUTTON = 6,
	WLAN_LED = 0,
	POWER_LED = 1,
	SES_WHITE_LED = 2,
	SES_AMBER_LED = 3,
	DMZ_LED = 7
}

local b = require('bit')
local nixio = require('nixio')

local function convert_byte_to_binary_string(byte)
        local out = ''
        for i=7,0,-1 do
                out = out .. (b.band(byte, b.lshift(1, i)) > 0 and '1' or '0')
        end
        return out
end

local function init()
	local rdwr = nixio.open_flags('rdwr')
	local outputEnable = nixio.open('/dev/gpio/outen', rdwr)
	local input = nixio.open('/dev/gpio/in', rdwr)
	local output = nixio.open('/dev/gpio/out', rdwr)

	if not outputEnable or not input or not output then
		print('failed to open file handles!')
		if outputEnable then outputEnable:close() end
		if input then input:close() end
		if output then output:close() end
	else
		M.handles = {
			outputEnable = outputEnable,
			input = input,
			output = output
		}
	end
end

init()

local function setBit(byte, bit)
	return b.bor(byte, b.lshift(1, bit))
end

local function clearBit(byte, bit)
	return b.band(byte, b.bnot(b.lshift(1, bit)))
end

function M.readRegister(reg)
--print('reading register')
	local fhandle = M.handles[reg]
	local str = fhandle:read(4)
	local char = str:sub(1,1)
	local byte = string.byte(char)

	return byte
	
--return string.byte(string.sub(M.handles[reg]:read(4), 1,1))
end

function M.writeRegister(reg, val)
--print('writing register')
	if type(val) == 'number' then val = string.char(val) end
	M.handles[reg]:write(val .. string.char(0,0,0))
end

function M.enablePinOutput(pin, enable)
	local pinMask = b.lshift(1, pin)
	local pinDirections = M.readRegister('outputEnable')

	local isEnabled = b.band(pinDirections, pinMask) > 0

	if enable ~= isEnabled then
		if enable then
print('setting pin as output')
			pinDirections = setBit(pinDirections, pin)
		else
print('setting pin as input')
			pinDirections = clearBit(pinDirections, pin)
		end

		M.writeRegister('outputEnable', pinDirections)

else
--print('pin direction was already correct')

	end
end


function M.setPin(pin, state)
	local pinMask = b.lshift(1, pin)

--print( 'pinMask:', convert_byte_to_binary_string(pinMask))

	M.enablePinOutput(pin, true)

	local outRegister = M.readRegister('output')

--print('outRegister:', convert_byte_to_binary_string(outRegister))

	local oldState = b.band(outRegister, pinMask) > 0

	if state ~= oldState then
		if state then
			outRegister = outRegister + pinMask
		else
			outRegister = outRegister - pinMask
		end
--print('setting pin output state to', (state and 'high' or 'low'), 'reg:', convert_byte_to_binary_string(outRegister))
		M.writeRegister('output', outRegister)

else
--print('pin output state was already correct')
	end
end

function M.readPin(pin)
	local pinMask = b.lshift(1, pin)

	M.enablePinOutput(pin, false)

	local inputRegister = M.readRegister('input')

	return b.band(inputRegister, pinMask) > 0
end

return M

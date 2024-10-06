-- this example demonstrates a basic usecase of the 'gpio' library by enabling the amber LED behind the front button for as long as the user holds it.

local gpio = require('gpio')
local socket = require('socket')

local lastbtn = false

while true do

	local button = not gpio.readPin(gpio.pins.FRONT_BUTTON)

	if button ~= lastbtn then print(button) end

	gpio.setPin(gpio.pins.SES_AMBER_LED, not button)
	gpio.setPin(gpio.pins.DMZ_LED, button)

	lastbtn = button
	socket.sleep(0.05)
end

# lua-wrt54g-gpio

This repo contains a library in `lib/gpio.lua` that enables simple control of the GPIO pins found on WRT54G series routers running OpenWrt firmware.

## Dependencies:
- **Nixio** can be downloaded from the [OpenWrt archive](https://archive.openwrt.org/backfire/10.03/brcm-2.4/packages/luci-nixio_0.9.0-1_brcm-2.4.ipk)

## Tested on:
  Wrt54G**L** v1.1 running OpenWrt v10.03 Backfire

### Also included:
- A demo file `gpio_test.lua` that illuminates the front LED as long as the front button is held.
- 2 binary conversion tools that can be used to directly access the `/dev/gpio/*` files using shell commands

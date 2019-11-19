# Aquarea H-generation Prometheus exporter

A prometheus.io exporter for the Panasonic Aquarea H-generation heatpump, for a NodeMCU/ESP8266 connected to the CN-CNT port.

## Setup

  1. Add a file `credentials.lua` with the following contents:

```
SSID=""
WIFI_PASSWORD=""
NTP_SERVER=""
```

  2. Upload these files to an ESP8266 running the NodeMCU firmware
  3. Refer to [Egyras' work](https://github.com/Egyras/Panasonic-H-Aquarea) for wiring
  
## Security

Please take note that `application.lua` exposes a Lua interpreter over telnet (see `telnet_init()`). This is intended behaviour while reverse engineering the serial protocol, but might not be what you want in your network.

function parse_uart_response(res)
    local d = {}

    -- 3rd arg to struct.unpack starts at 1: one added to all byte offsets
    d.mode_on_off_force_dhw        =  struct.unpack('<B', res, 5)
    d.mode_holiday                 =  struct.unpack('<B', res, 6)
    d.mode_select                  =  struct.unpack('<B', res, 7)
    d.mode_quiet_or_power          =  struct.unpack('<B', res, 8)

    d.zone_sensor_select           =  struct.unpack('<B', res, 23)

    d.set_curve_or_direct          =  struct.unpack('<B', res, 29)

    d.set_zone1_heat               =  struct.unpack('<B', res, 39) - 128
    d.set_zone1_cool               =  struct.unpack('<B', res, 40) - 128
    d.set_zone2_heat               =  struct.unpack('<B', res, 41) - 128
    d.set_zone2_cool               =  struct.unpack('<B', res, 42) - 128
    d.set_dhw_tank_temp            =  struct.unpack('<B', res, 43) - 128

    d.set_holiday_heat_shift       =  struct.unpack('<B', res, 44) - 128
    d.set_dhw_heat_shift           =  struct.unpack('<B', res, 45) - 128

    d.set_zone1_curve_outlet_high  =  struct.unpack('<B', res, 76) - 128
    d.set_zone1_curve_outlet_low   =  struct.unpack('<B', res, 77) - 128
    d.set_zone1_curve_outside_low  =  struct.unpack('<B', res, 78) - 128
    d.set_zone1_curve_outside_high =  struct.unpack('<B', res, 79) - 128
    d.set_zone2_curve_outlet_high  =  struct.unpack('<B', res, 80) - 128
    d.set_zone2_curve_outlet_low   =  struct.unpack('<B', res, 81) - 128
    d.set_zone2_curve_outside_low  =  struct.unpack('<B', res, 82) - 128
    d.set_zone2_curve_outside_high =  struct.unpack('<B', res, 83) - 128

    d.set_floor_heat_delta         =  struct.unpack('<B', res, 85) - 128

    d.set_floor_cool_delta         =  struct.unpack('<B', res, 95) - 128

    d.set_auto_crossover_temp      =  struct.unpack('<B', res, 97) - 128
    d.set_dhw_max_room_operation   = (struct.unpack('<B', res, 98) - 1) * 30
    d.set_dhw_max_heat_time        =  struct.unpack('<B', res, 99) - 128
    d.set_dhw_reheat_delta         =  struct.unpack('<B', res, 100) - 128
    d.set_dhw_sterilization_temp   =  struct.unpack('<B', res, 101) - 128
    d.set_dhw_sterilization_time   =  struct.unpack('<B', res, 102) - 1

    d.mode_3way_valve              =  struct.unpack('<B', res, 112) - 0x54

    d.temp_air_zone1               =  struct.unpack('<B', res, 140) - 128
    d.temp_air_zone2               =  struct.unpack('<B', res, 141) - 128
    d.temp_water_tank              =  struct.unpack('<B', res, 142) - 128
    d.temp_air_outdoor             =  struct.unpack('<B', res, 143) - 128
    d.temp_water_inlet             =  struct.unpack('<B', res, 144) - 128
    d.temp_water_outlet            =  struct.unpack('<B', res, 145) - 128
    d.temp_water_zone1             =  struct.unpack('<B', res, 146) - 128
    d.temp_water_zone2             =  struct.unpack('<B', res, 147) - 128
    d.temp_target_zone1            =  struct.unpack('<B', res, 148) - 128
    d.temp_target_zone2            =  struct.unpack('<B', res, 149) - 128
    d.temp_water_buffer            =  struct.unpack('<B', res, 150) - 128
    d.temp_water_solar             =  struct.unpack('<B', res, 151) - 128
    d.temp_water_pool              =  struct.unpack('<B', res, 152) - 128

    d.temp_target_outlet           =  struct.unpack('<B', res, 154) - 128
    d.temp_outlet2_temp            =  struct.unpack('<B', res, 155) - 128
    d.temp_discharge               =  struct.unpack('<B', res, 156) - 128
    d.temp_room_thermostat         =  struct.unpack('<B', res, 157) - 128
    d.temp_indoor_piping           =  struct.unpack('<B', res, 158) - 128
    d.temp_outdoor_piping          =  struct.unpack('<B', res, 159) - 128
    d.temp_defrost                 =  struct.unpack('<B', res, 160) - 128
    d.temp_EVA_outlet              =  struct.unpack('<B', res, 161) - 128
    d.temp_bypass_outlet           =  struct.unpack('<B', res, 162) - 128
    d.temp_IPM                     =  struct.unpack('<B', res, 163) - 128

    d.compressor_pressure_high     = (struct.unpack('<B', res, 164) - 1) / 5
    d.compressor_pressure_low      =  struct.unpack('<B', res, 165) - 1
    d.compressor_operating_time    = (struct.unpack('<B', res, 166) - 1) / 5
    d.compressor_frequency         =  struct.unpack('<B', res, 167) - 1

    d.pump_flow                    =  struct.unpack('<B', res, 171)
                                   + (struct.unpack('<B', res, 170) - 1) / 250

    d.pump_speed                   = (struct.unpack('<B', res, 172) - 1) * 50
    d.pump_duty                    =  struct.unpack('<B', res, 173) - 1
    d.fan_speed                    = (struct.unpack('<B', res, 174) - 1) * 10
    d.fan_speed2                   =  struct.unpack('<B', res, 175) - 1

    d.num_operations               =  struct.unpack('<H', res, 180) - 1

    d.operating_time               =  struct.unpack('<H', res, 183) - 1

    d.room_heater_operating_time   =  struct.unpack('<B', res, 186) - 1

    return d
end
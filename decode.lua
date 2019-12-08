function id(value)
    return value
end

function min1(value)
    return value - 1
end

function min128(value)
    return value - 128
end

function min1div5(value)
    return (value - 1)/5
end

function read_pump_flow(data, i)
    local frac, i = struct.unpack('<B', data, i)
    local int, i = struct.unpack('<B', data, i)

    return int + (frac-1)/250, i
end

function r2(data, tweak, i) -- read unsigned short (2 bytes)
    local short, i = struct.unpack('<H', data, i)

    return tweak(short), i
end

function r(data, tweak, i) -- read unsigned char (1 byte)
    local char, i = struct.unpack('<B', data, i)

    return tweak(char), i
end

function parse_uart_response(answer)
    local d = {}
    local i = 1

                                    i = i + 4 -- skip to byte 4
    d.mode_on_off_force_dhw         , i = r(answer, function (v) return v==0x96 and 1 or 0 end, i)
    d.mode_holiday                  , i = r(answer, function (v) return v==0x65 and 1 or 0 end, i)
    d.mode_select                   , i = r(answer, id, i)
    d.mode_quiet_or_power           , i = r(answer, id, i)
                                    i = i + 14 -- skip to byte 22
    d.zone_sensor_select            , i = r(answer, id, i)
                                    i = i + 5 -- skip to byte 28
    d.set_curve_or_direct               , i = r(answer, id, i)
                                    i = i + 9 -- skip to byte 38
    d.set_zone1_heat                , i = r(answer, min128, i)
    d.set_zone1_cool                , i = r(answer, min128, i)
    d.set_zone2_heat                , i = r(answer, min128, i)
    d.set_zone2_cool                , i = r(answer, min128, i)
    d.set_dhw_tank_temp             , i = r(answer, min128, i)
    d.set_holiday_heat_shift        , i = r(answer, min128, i)
    d.set_dhw_heat_shift            , i = r(answer, min128, i)
                                    i = i + 30 -- skip to byte 75
    d.set_zone1_curve_outlet_high   , i = r(answer, min128, i)
    d.set_zone1_curve_outlet_low    , i = r(answer, min128, i)
    d.set_zone1_curve_outside_low   , i = r(answer, min128, i)
    d.set_zone1_curve_outside_high  , i = r(answer, min128, i)
    d.set_zone2_curve_outlet_high   , i = r(answer, min128, i)
    d.set_zone2_curve_outlet_low    , i = r(answer, min128, i)
    d.set_zone2_curve_outside_low   , i = r(answer, min128, i)
    d.set_zone2_curve_outside_high  , i = r(answer, min128, i)
                                    i = i + 1 -- skip to byte 84
    d.set_floor_heat_delta          , i = r(answer, min128, i)
                                    i = i + 9 -- skip to byte 94
    d.set_floor_cool_delta          , i = r(answer, min128, i)
                                    i = i + 2 -- skip to byte 97
    d.set_dhw_max_room_operation    , i = r(answer, min128, i)
    d.set_dhw_max_heat_time         , i = r(answer, min128, i)
    d.set_dhw_reheat_delta          , i = r(answer, min128, i)
    d.set_dhw_sterilization_temp    , i = r(answer, min128, i)
    d.set_dhw_sterilization_time    , i = r(answer, min128, i)
                                    i = i + 9 -- skip to byte 111
    d.mode_3way_valve               , i = r(answer, function (v) return v-0x54 end, i)
                                    i = i + 27 -- skip to byte 139
    d.temp_air_zone1                    , i = r(answer, min128, i)
    d.temp_air_zone2                    , i = r(answer, min128, i)
    d.temp_water_tank                     , i = r(answer, min128, i)
    d.temp_air_outdoor                  , i = r(answer, min128, i)
    d.temp_water_inlet                    , i = r(answer, min128, i)
    d.temp_water_outlet                   , i = r(answer, min128, i)
    d.temp_water_zone1              , i = r(answer, min128, i)
    d.temp_water_zone2              , i = r(answer, min128, i)
    d.temp_target_zone1             , i = r(answer, min128, i)
    d.temp_target_zone2             , i = r(answer, min128, i)
    d.temp_water_buffer             , i = r(answer, min128, i)
    d.temp_water_solar              , i = r(answer, min128, i)
    d.temp_water_pool               , i = r(answer, min128, i)
                                    i = i + 1 -- skip to byte 153
    d.temp_target_outlet            , i = r(answer, min128, i)
    d.temp_outlet2_temp                  , i = r(answer, min128, i)
    d.temp_discharge                , i = r(answer, min128, i)
    d.temp_room_thermostat          , i = r(answer, min128, i)
    d.temp_indoor_piping            , i = r(answer, min128, i)
    d.temp_outdoor_piping           , i = r(answer, min128, i)
    d.temp_defrost                  , i = r(answer, min128, i)
    d.temp_EVA_outlet               , i = r(answer, min128, i)
    d.temp_bypass_outlet            , i = r(answer, min128, i)
    d.temp_IPM                      , i = r(answer, min128, i)
    d.compressor_pressure_high      , i = r(answer, min1div5, i)
    d.compressor_pressure_low       , i = r(answer, min1, i)
    d.compressor_operating_time     , i = r(answer, min1div5, i)
    d.compressor_frequency          , i = r(answer, min1, i)
                                    i = i + 2 -- skip to byte 169
    d.pump_flow                     , i = read_pump_flow(answer, i)
    d.pump_speed                    , i = r(answer, function (v) return min1(v)*50 end, i)
    d.pump_duty                     , i = r(answer, min1, i)
    d.fan_speed                     , i = r(answer, function (v) return min1(v)*10 end, i)
    d.fan_speed2                    , i = r(answer, min1, i)
                                    i = i + 7 -- skip to byte 182
    d.operating_time                , i = r2(answer, function (v) return min1(v) end, i)
    return d
end
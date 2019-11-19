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

function r(data, tweak, i) -- read 2 bytes
    local bytes, i = struct.unpack('<B', data, i)

    return tweak(bytes), i
end

function parse_uart_response(answer)
    local d = {}
    local i = 1

                                i = i + 4 -- skip
    d.force_dhw                 , i = r(answer, function (v) return v==0x96 and 1 or 0 end, i)
    d.holiday_mode              , i = r(answer, function (v) return v==0x65 and 1 or 0 end, i)
    d.mode                      , i = r(answer, id, i)
    d.quiet_or_power_mode       , i = r(answer, id, i)
                                i = i + 30 -- skip
    d.zone1_heat_set            , i = r(answer, min128, i)
    d.zone1_cool_set            , i = r(answer, min128, i)
    d.zone2_heat_set            , i = r(answer, min128, i)
    d.zone2_cool_set            , i = r(answer, min128, i)
    d.dhw_set                   , i = r(answer, min128, i)
                                i = i + 56 -- skip
    d.dhw_reheat_delta          , i = r(answer, min128, i)
                                i = i + 11 -- skip
    d.room_or_tank              , i = r(answer, function (v) return v-0x54 end, i)
                                i = i + 27 -- skip
    d.zone1_temp                , i = r(answer, min128, i)
    d.zone2_temp                , i = r(answer, min128, i)
    d.tank_temp                 , i = r(answer, min128, i)
    d.outdoor_temp              , i = r(answer, min128, i)
    d.inlet_temp                , i = r(answer, min128, i)
    d.outlet_temp               , i = r(answer, min128, i)
    d.zone1_water_temp          , i = r(answer, min128, i)
    d.zone2_water_temp          , i = r(answer, min128, i)
    d.zone1_water_temp_target   , i = r(answer, min128, i)
    d.zone2_water_temp_target   , i = r(answer, min128, i)
    d.buffer_water_temp         , i = r(answer, min128, i)
    d.solar_water_temp          , i = r(answer, min128, i)
    d.pool_water_temp           , i = r(answer, min128, i)
                                i = i + 1 -- unknown 2 bytes
    d.outlet_target_temp_target , i = r(answer, min128, i)
    d.outlet2_temp              , i = r(answer, min128, i)
    d.discharge_temp            , i = r(answer, min128, i)
    d.room_temp_internal        , i = r(answer, min128, i)
    d.indoor_piping_temp        , i = r(answer, min128, i)
    d.outdoor_piping_temp       , i = r(answer, min128, i)
    d.defrost_temp              , i = r(answer, min128, i)
    d.EVA_outlet_temp           , i = r(answer, min128, i)
    d.bypass_outlet_temp        , i = r(answer, min128, i)
    d.IPM_temp                  , i = r(answer, min128, i)
    d.high_pressure             , i = r(answer, min1div5, i)
    d.low_pressure              , i = r(answer, min1, i)
    d.outdoor_current           , i = r(answer, min1div5, i)
    d.compressor_frequency      , i = r(answer, min1, i)
                                i = i + 2 -- unknown 2 bytes
                                i = i + 2 -- unknown 2 bytes
    d.pump_flow                 , i = read_pump_flow(answer, i)
    d.pump_speed                , i = r(answer, function (v) return min1(v)*50 end, i)
    d.pump_duty                 , i = r(answer, min1, i)
    d.fan_motor_speed           , i = r(answer, function (v) return min1(v)*10 end, i)
    d.fan_motor_speed2          , i = r(answer, min1, i)
                                i = i + 2 -- unknown 2 bytes

    return d
end
PANASONIC_QUERY=string.char(0x71, 0x6c, 0x01, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x12)

function uart_send_query()
    print("u> [Panasonic query]")
    uart.write(0, PANASONIC_QUERY)
end

function makepromlines(name, source)
    return "# TYPE aquarea_"..name.." gauge\naquarea_"..name.." "..source.."\n"
end
  
function uart_init()
    print("setup UART...")
    uart.setup(0, 9600, 8, uart.PARITY_EVEN, uart.STOPBITS_1, 0)
end

function hex(buf)
    return buf:gsub('.', function (c) return string.format('%02X ', string.byte(c)) end)
end

function http_header()
    return "HTTP/1.0 200 OK\r\nServer: NodeMCU on ESP8266\r\nContent-Type: text/plain; version=0.0.4\r\n\r\n"
end

function http_init()

    print('starting web server...')

    srv = net.createServer(net.TCP, 20) -- 20s timeout

    if srv then
        srv:listen(80, function(conn)
            conn:on("receive", function(sock, data)
                print("h< "  .. data)
        
                -- register response callback
                uart.on("data", 203, function (uart_response)
                    print("u< "..hex(uart_response))

                    sock:send(http_header(), function ()
                        sock:send("# RAW: "..hex(uart_response).."\n", function ()
                            local readout = parse_uart_response(uart_response)
                            uart_response = nil
                            collectgarbage()

                            -- sends and removes the first key, value pair from the 'readout' table
                            local function send(sck)
                                k, v = next(readout, nil)
                                if k ~= nil then
                                    sck:send(makepromlines(k,v))
                                    readout[k] = nil
                                else
                                    sck:close()
                                    readout = nil
                                end
                            end

                            -- triggers the send() function again once the first chunk of data was sent
                            sock:on("sent", send)

                            send(sock)
                        end)
                    uart.on("data") -- unregister callback
                    end)
                end, 0)

                uart_send_query()
            end)
        end)
    end
end

function telnet_init()
    -- a simple telnet server
    s=net.createServer(net.TCP)
    s:listen(23,function(c)
    con_std = c
    function s_output(str)
        if(con_std~=nil)
            then con_std:send(str)
        end
    end
    node.output(s_output, 0)   -- re-direct output to function s_ouput.
        c:on("receive",function(c,l)
            node.input(l)           -- works like pcall(loadstring(l)) but support multiple separate line
        end)
        c:on("disconnection",function(c)
            con_std = nil
            node.output(nil)        -- un-regist the redirect output function, output goes to serial
        end)
    end)
end

dofile('decode.lua')
telnet_init()
uart_init()
http_init()
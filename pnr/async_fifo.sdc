# 1. Write clock: 100 MHz
create_clock -name wclk -period 10.0 [get_ports wclk]

# 2. Read clock: ~71.43 MHz
create_clock -name rclk -period 14.0 [get_ports rclk]

# 3. Asynchronous clock domains
set_clock_groups -asynchronous \
    -group [get_clocks wclk] \
    -group [get_clocks rclk]

# 4. Input delays
set_input_delay 2.0 -clock wclk [get_ports {wdata[*] winc}]
set_input_delay 2.0 -clock rclk [get_ports {rinc}]

# 5. Output delays
set_output_delay 2.0 -clock wclk [get_ports {wfull}]
set_output_delay 2.0 -clock rclk [get_ports {rdata[*] rempty}]
read_lef /Users/anigevorgyan/asic-learning/fsm_traffic/sky130hd.tlef
read_lef /Users/anigevorgyan/asic-learning/fsm_traffic/sky130_fd_sc_hd_merged.lef
read_liberty /Users/anigevorgyan/asic-learning/fsm_traffic/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog /Users/anigevorgyan/asic-learning/async_fifo/async_fifo_sky130.v
link_design async_fifo

puts "wptr_gray CLK pins: [llength [get_pins -hier *wptr_gray*/CLK]]"
puts "sync_w2r D pins:    [llength [get_pins -hier *sync_w2r*/D]]"

read_sdc /Users/anigevorgyan/asic-learning/async_fifo/async_fifo.sdc
exit
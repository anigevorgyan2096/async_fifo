# 1. Technology
read_lef /Users/anigevorgyan/asic-learning/fsm_traffic/sky130hd.tlef
read_lef /Users/anigevorgyan/asic-learning/fsm_traffic/sky130_fd_sc_hd_merged.lef
read_liberty /Users/anigevorgyan/asic-learning/fsm_traffic/sky130_fd_sc_hd__tt_025C_1v80.lib

# 2. Design
read_verilog /Users/anigevorgyan/asic-learning/async_fifo/synth/async_fifo_sky130.v
link_design async_fifo

# 3. Constraints
read_sdc /Users/anigevorgyan/asic-learning/async_fifo/pnr/async_fifo.sdc

# 4. Floorplan
initialize_floorplan -utilization 40 -aspect_ratio 1.0 -core_space 5.0 -site unithd
make_tracks

# 5. Power grid
add_global_connection -net VPWR -pin_pattern {^VPWR$} -power
add_global_connection -net VGND -pin_pattern {^VGND$} -ground
global_connect
set_voltage_domain -power VPWR -ground VGND
define_pdn_grid -name grid -pins met4
add_pdn_stripe -layer met1 -width 0.48 -followpins
add_pdn_stripe -layer met4 -width 1.6 -pitch 27.2 -offset 13.6
add_pdn_connect -layers {met1 met4}
pdngen

# 6. Wire RC
set_wire_rc -signal -layer met2
set_wire_rc -clock -layer met5

# 7. IO pins
place_pins -hor_layers met3 -ver_layers met2

# 8. Placement
global_placement -density 0.55
detailed_placement
check_placement
write_def /Users/anigevorgyan/asic-learning/async_fifo/async_fifo_placed.def

# 9. CTS
clock_tree_synthesis -root_buf sky130_fd_sc_hd__clkbuf_4 -buf_list sky130_fd_sc_hd__clkbuf_4
detailed_placement
check_placement

# 10. Routing
set_routing_layers -signal met1-met5 -clock met1-met5
global_route
detailed_route

#11. Post-route analysis
estimate_parasitics -global_routing
report_checks -path_delay max
report_checks -path_delay min
report_clock_skew
report_design_area

# 12. Outputs
write_db /Users/anigevorgyan/asic-learning/async_fifo/async_fifo.odb
write_def /Users/anigevorgyan/asic-learning/async_fifo/async_fifo_routed.def
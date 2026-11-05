#!/usr/bin/env bash
set -e

# Gate-level netlist has no parameters, so use a testbench copy without the #() override.
sed 's/async_fifo #(\.DATA_W(DATA_W), \.ADDR_W(ADDR_W)) dut/async_fifo dut/' async_fifo_tb.v > async_fifo_tb_gl.v

iverilog -o rtl_sim async_fifo.v dp_ram.v reset_sync.v rptr_empty.v sync_2ff.v wptr_full.v async_fifo_tb.v
vvp rtl_sim > rtl.txt

iverilog -o gl_sim cells_sim.v async_fifo_sky130.v async_fifo_tb_gl.v
vvp gl_sim > gl.txt

echo "=== RTL ==="
grep -n "PASS\|FAIL\|ERROR\|TIMEOUT\|stage" rtl.txt || true
echo "=== GATE-LEVEL ==="
grep -n "PASS\|FAIL\|ERROR\|TIMEOUT\|stage" gl.txt || true

echo "=== summary ==="
echo "RTL result: $(grep 'ASYNC FIFO' rtl.txt || echo none)"
echo "GL  result: $(grep 'ASYNC FIFO' gl.txt || echo none)"

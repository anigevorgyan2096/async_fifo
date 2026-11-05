# Async FIFO flow: RTL sim -> synthesis -> gate-level sim -> PnR -> GDS
# Layout:  rtl/  tb/  synth/  pnr/  scripts/   (run `make` from the project root)

IVERILOG ?= iverilog
VVP      ?= vvp
YOSYS    ?= yosys
OPENROAD ?= openroad
PY       ?= $(HOME)/klayout-env/bin/python3   # venv with `pip install klayout`

RTL = rtl/async_fifo.v rtl/dp_ram.v rtl/reset_sync.v rtl/rptr_empty.v rtl/sync_2ff.v rtl/wptr_full.v
NETLIST = synth/async_fifo_sky130.v

.PHONY: help all sim rtl_sim gl_sim synth pnr gds clean

help:
	@echo "make sim      - RTL + gate-level simulation, prints both results"
	@echo "make synth    - Yosys synthesis (synth/synth.ys) -> $(NETLIST)"
	@echo "make pnr      - OpenROAD place & route (pnr/run.tcl)"
	@echo "make gds      - DEF -> GDS via KLayout Python (scripts/def2gds.py)"
	@echo "make all      - synth, sim, pnr, gds"
	@echo "make clean    - remove generated simulation files"

all: synth sim pnr gds

build:
	mkdir -p build

build/rtl.txt: $(RTL) tb/async_fifo_tb.v | build
	$(IVERILOG) -o build/rtl_sim $(RTL) tb/async_fifo_tb.v
	$(VVP) build/rtl_sim > $@

# The netlist has no parameters, so use a testbench copy without the #() override.
build/async_fifo_tb_gl.v: tb/async_fifo_tb.v | build
	sed 's/async_fifo #(\.DATA_W(DATA_W), \.ADDR_W(ADDR_W)) dut/async_fifo dut/' $< > $@

build/gl.txt: synth/cells_sim.v $(NETLIST) build/async_fifo_tb_gl.v | build
	$(IVERILOG) -o build/gl_sim synth/cells_sim.v $(NETLIST) build/async_fifo_tb_gl.v
	$(VVP) build/gl_sim > $@

rtl_sim: build/rtl.txt
	@grep -n "PASS\|FAIL\|ERROR\|TIMEOUT\|stage" build/rtl.txt || true

gl_sim: build/gl.txt
	@grep -n "PASS\|FAIL\|ERROR\|TIMEOUT\|stage" build/gl.txt || true

sim: build/rtl.txt build/gl.txt
	@echo "RTL result: $$(grep 'ASYNC FIFO' build/rtl.txt || echo none)"
	@echo "GL  result: $$(grep 'ASYNC FIFO' build/gl.txt || echo none)"

synth: $(NETLIST)

$(NETLIST): $(RTL) synth/synth.ys
	$(YOSYS) -l synth/synth.log synth/synth.ys

pnr: $(NETLIST) pnr/async_fifo.sdc pnr/run.tcl
	$(OPENROAD) -exit -log pnr/pnr.log pnr/run.tcl

gds: async_fifo_routed.def
	$(PY) scripts/def2gds.py

clean:
	rm -rf build async_fifo.vcd
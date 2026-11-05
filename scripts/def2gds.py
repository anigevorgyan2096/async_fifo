import klayout.db as db

base = "/Users/anigevorgyan/asic-learning"
lefs = [
    f"{base}/fsm_traffic/sky130hd.tlef",
    f"{base}/fsm_traffic/sky130_fd_sc_hd_merged.lef",
]

cfg = db.LEFDEFReaderConfiguration()
cfg.lef_files = lefs

opt = db.LoadLayoutOptions()
opt.lefdef_config = cfg

ly = db.Layout()
ly.read(f"{base}/async_fifo/async_fifo_routed.def", opt)
ly.write(f"{base}/async_fifo/async_fifo.gds")
print("written", ly.top_cell().name)
import klayout.lay as lay

base = "/Users/anigevorgyan/asic-learning/async_fifo"

view = lay.LayoutView()
view.load_layout(f"{base}/async_fifo.gds", True)
view.max_hier()
view.zoom_fit()
view.save_image(f"{base}/async_fifo_gds.png", 2000, 2000)
print("saved")

module async_fifo #(
    parameter DATA_W = 8,
    parameter ADDR_W = 4
)(
    input  wire              wclk,
    input  wire              wrst,
    input  wire              winc,
    input  wire [DATA_W-1:0] wdata,
    output wire              wfull,
    input  wire              rclk,
    input  wire              rrst,
    input  wire              rinc,
    output wire [DATA_W-1:0] rdata,
    output wire              rempty
);
    wire wrst_s, rrst_s;
    reset_sync u_wrst_sync (.clk(wclk), .arst(wrst), .rst_sync(wrst_s));
    reset_sync u_rrst_sync (.clk(rclk), .arst(rrst), .rst_sync(rrst_s));

    wire [ADDR_W-1:0] waddr, raddr;
    wire [ADDR_W:0]   wptr, rptr;
    wire [ADDR_W:0]   wq2_rptr, rq2_wptr;

    sync_2ff #(.WIDTH(ADDR_W+1)) u_sync_r2w (.clk(wclk), .rst(wrst_s), .d(rptr), .q(wq2_rptr));
    sync_2ff #(.WIDTH(ADDR_W+1)) u_sync_w2r (.clk(rclk), .rst(rrst_s), .d(wptr), .q(rq2_wptr));

    wptr_full  #(.ADDR_W(ADDR_W)) u_wptr_full (
        .wclk(wclk), .wrst(wrst_s), .winc(winc),
        .wq2_rptr(wq2_rptr), .wfull(wfull), .waddr(waddr), .wptr(wptr));

    rptr_empty #(.ADDR_W(ADDR_W)) u_rptr_empty (
        .rclk(rclk), .rrst(rrst_s), .rinc(rinc),
        .rq2_wptr(rq2_wptr), .rempty(rempty), .raddr(raddr), .rptr(rptr));

    dp_ram #(.DATA_W(DATA_W), .ADDR_W(ADDR_W)) u_ram (
        .wclk(wclk), .we(winc & ~wfull), .waddr(waddr), .wdata(wdata),
        .rclk(rclk), .raddr(raddr), .rdata(rdata));
endmodule

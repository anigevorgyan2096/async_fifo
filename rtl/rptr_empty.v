module rptr_empty #(
    parameter ADDR_W = 4
)(
    input  wire              rclk,
    input  wire              rrst,
    input  wire              rinc,
    input  wire [ADDR_W:0]   rq2_wptr,
    output reg               rempty,
    output wire [ADDR_W-1:0] raddr,
    output reg  [ADDR_W:0]   rptr
);
    reg  [ADDR_W:0] rbin;
    wire [ADDR_W:0] rbin_next  = rbin + (rinc & ~rempty);
    wire [ADDR_W:0] rgray_next = (rbin_next >> 1) ^ rbin_next;

    wire rempty_val = (rgray_next == rq2_wptr);

    always @(posedge rclk or posedge rrst) begin
        if (rrst) begin
            rbin   <= 0;
            rptr   <= 0;
            rempty <= 1'b1;
        end else begin
            rbin   <= rbin_next;
            rptr   <= rgray_next;
            rempty <= rempty_val;
        end
    end

    assign raddr = rbin[ADDR_W-1:0];
endmodule

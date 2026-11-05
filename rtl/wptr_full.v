module wptr_full #(
    parameter ADDR_W = 4
)(
    input  wire              wclk,
    input  wire              wrst,
    input  wire              winc,
    input  wire [ADDR_W:0]   wq2_rptr,
    output reg               wfull,
    output wire [ADDR_W-1:0] waddr,
    output reg  [ADDR_W:0]   wptr
);
    reg  [ADDR_W:0] wbin;
    wire [ADDR_W:0] wbin_next  = wbin + (winc & ~wfull);
    wire [ADDR_W:0] wgray_next = (wbin_next >> 1) ^ wbin_next;

    wire wfull_val = (wgray_next == {~wq2_rptr[ADDR_W:ADDR_W-1], wq2_rptr[ADDR_W-2:0]});

    always @(posedge wclk or posedge wrst) begin
        if (wrst) begin
            wbin  <= 0;
            wptr  <= 0;
            wfull <= 1'b0;
        end else begin
            wbin  <= wbin_next;
            wptr  <= wgray_next;
            wfull <= wfull_val;
        end
    end

    assign waddr = wbin[ADDR_W-1:0];
endmodule

module reset_sync (
    input  wire clk,
    input  wire arst,
    output wire rst_sync
);
    reg [1:0] ff;

    always @(posedge clk or posedge arst) begin
        if (arst)
            ff <= 2'b11;
        else
            ff <= {ff[0], 1'b0};
    end

    assign rst_sync = ff[1];
endmodule

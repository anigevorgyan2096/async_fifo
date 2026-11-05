// 2-FF synchronizer՝ բազմաբիթ (Gray) ազդանշանը մյուս ժամացույցի տիրույթ տեղափոխելու համար
module sync_2ff #(
    parameter WIDTH = 4
)(
    input  wire             clk,    // ՆՊԱՏԱԿԻ ժամացույցը
    input  wire             rst,    // ասինխրոն reset (ակտիվ 1)
    input  wire [WIDTH-1:0] d,      // մուտք՝ ԱՅԼ ժամացույցի տիրույթից
    output wire [WIDTH-1:0] q       // ելք՝ clk տիրույթում
);
    reg [WIDTH-1:0] ff1, ff2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ff1 <= {WIDTH{1'b0}};
            ff2 <= {WIDTH{1'b0}};
        end else begin
            ff1 <= d;
            ff2 <= ff1;
        end
    end

    assign q = ff2;
endmodule
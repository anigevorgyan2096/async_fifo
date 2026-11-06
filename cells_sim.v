// Behavioral models of the sky130_fd_sc_hd cells used by async_fifo
module sky130_fd_sc_hd__and4b_1 (input A_N, B, C, D, output X);
  assign X = ~A_N & B & C & D;
endmodule
module sky130_fd_sc_hd__clkinv_1 (input A, output Y);
  assign Y = ~A;
endmodule
module sky130_fd_sc_hd__conb_1 (output HI, output LO);
  assign HI = 1'b1;
  assign LO = 1'b0;
endmodule
module sky130_fd_sc_hd__dfrtp_1 (input CLK, D, RESET_B, output reg Q);
  always @(posedge CLK or negedge RESET_B)
    if (!RESET_B) Q <= 1'b0; else Q <= D;
endmodule
module sky130_fd_sc_hd__dfstp_1 (input CLK, D, SET_B, output reg Q);
  always @(posedge CLK or negedge SET_B)
    if (!SET_B) Q <= 1'b1; else Q <= D;
endmodule
module sky130_fd_sc_hd__dfxtp_1 (input CLK, D, output reg Q);
  always @(posedge CLK) Q <= D;
endmodule
module sky130_fd_sc_hd__edfxtp_1 (input CLK, D, DE, output reg Q);
  always @(posedge CLK) if (DE) Q <= D;
endmodule
module sky130_fd_sc_hd__mux2i_1 (input A0, A1, S, output Y);
  assign Y = ~(S ? A1 : A0);
endmodule
module sky130_fd_sc_hd__mux4_2 (input A0, A1, A2, A3, S0, S1, output X);
  assign X = S1 ? (S0 ? A3 : A2) : (S0 ? A1 : A0);
endmodule
module sky130_fd_sc_hd__nand2_1 (input A, B, output Y);
  assign Y = ~(A & B);
endmodule
module sky130_fd_sc_hd__nand2b_1 (input A_N, B, output Y);
  assign Y = ~(~A_N & B);
endmodule
module sky130_fd_sc_hd__nand3_1 (input A, B, C, output Y);
  assign Y = ~(A & B & C);
endmodule
module sky130_fd_sc_hd__nand3b_1 (input A_N, B, C, output Y);
  assign Y = ~(~A_N & B & C);
endmodule
module sky130_fd_sc_hd__nand4b_1 (input A_N, B, C, D, output Y);
  assign Y = ~(~A_N & B & C & D);
endmodule
module sky130_fd_sc_hd__nor2_1 (input A, B, output Y);
  assign Y = ~(A | B);
endmodule
module sky130_fd_sc_hd__nor2b_1 (input A, B_N, output Y);
  assign Y = ~(A | ~B_N);
endmodule
module sky130_fd_sc_hd__nor3_1 (input A, B, C, output Y);
  assign Y = ~(A | B | C);
endmodule
module sky130_fd_sc_hd__o211ai_1 (input A1, A2, B1, C1, output Y);
  assign Y = ~((A1 | A2) & B1 & C1);
endmodule
module sky130_fd_sc_hd__o21ai_0 (input A1, A2, B1, output Y);
  assign Y = ~((A1 | A2) & B1);
endmodule
module sky130_fd_sc_hd__or3_1 (input A, B, C, output X);
  assign X = A | B | C;
endmodule
module sky130_fd_sc_hd__xnor2_1 (input A, B, output Y);
  assign Y = ~(A ^ B);
endmodule
module sky130_fd_sc_hd__xnor3_1 (input A, B, C, output X);
  assign X = ~(A ^ B ^ C);
endmodule
module sky130_fd_sc_hd__xor2_1 (input A, B, output X);
  assign X = A ^ B;
endmodule
module sky130_fd_sc_hd__and4_1 (input A, B, C, D, output X);
  assign X = A & B & C & D;
endmodule
module sky130_fd_sc_hd__a21oi_1 (input A1, A2, B1, output Y);
  assign Y = ~((A1 & A2) | B1);
endmodule
module sky130_fd_sc_hd__and3b_1 (input A_N, B, C, output X);
  assign X = ~A_N & B & C;
endmodule
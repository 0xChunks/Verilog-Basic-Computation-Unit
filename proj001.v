module proj001 (
  
    input [3:0] d_in,
    input [1:0] op,
    input capture, rst_n, clock,
    output valid,
    output [4:0] result
    
);

  datapath data ( .d_in(d_in), .capture(capture), .rst_n(rst_n), .clock(clock), .op(op), .result(result) );

  controller control ( .capture(capture), .rst_n(rst_n), .clock(clock), .valid(valid) );

endmodule

module controller (
    input capture, rst_n, clock,
    output valid
);

    wire w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11;
    wire Q2, Q2_n, Q1, Q1_n, Q0, Q0_n, capture_n;

    assign capture_n = ~capture;

    assign w1 = Q0_n & Q2;
    assign w2 = Q1 & Q0 & capture;
    assign w3 = w1 | w2;

    assign w4 = Q1 & Q0_n;
    assign w5 = Q1 & capture_n;
    assign w6 = Q2_n & Q1_n & Q0 & capture;
    assign w7 = w4 | w5 | w6;

    assign w8 = Q2 & Q0_n;
    assign w9 = Q0_n & capture;
    assign w10 = Q2_n & Q0 & capture_n;
    assign w11 = w8 | w9 | w10;

    dff dffQ0 ( .clk(clock), .rst_n(rst_n), .d(w11), .q(Q0), .q_n(Q0_n) );
    dff dffQ1 ( .clk(clock), .rst_n(rst_n), .d(w7), .q(Q1), .q_n(Q1_n) );
    dff dffQ2 ( .clk(clock), .rst_n(rst_n), .d(w3), .q(Q2), .q_n(Q2_n) );

    assign valid = Q2 & Q1_n & Q0;

endmodule

module datapath (

  input [3:0] d_in,
  input capture, rst_n, clock,
  input [1:0] op,
  output [4:0] result,
  wire ignore,
  wire [3:0] wA, wB, wC, wD, wA1, wB1, wC1, wD1,
  wire [3:0] Aout, Bout, Cout, Dout,
  wire [4:0] w1, w2, w3

);

// 41 MUXES
mux41A mux41A ( .d_in(d_in), .Aout(Aout), .op(op), .wA(wA) );
mux41B mux41B ( .d_in(d_in), .Bout(Bout), .op(op), .wB(wB) );
mux41C mux41C ( .d_in(d_in), .Cout(Cout), .op(op), .wC(wC) );
mux41D mux41D ( .d_in(d_in), .Dout(Dout), .op(op), .wD(wD) );

// CAPTURES
mux21 capA ( .A(Aout), .B(wA), .sel(capture), .F(wA1) );
mux21 capB ( .A(Bout), .B(wB), .sel(capture), .F(wB1) );
mux21 capC ( .A(Cout), .B(wC), .sel(capture), .F(wC1) );
mux21 capD ( .A(Dout), .B(wD), .sel(capture), .F(wD1) );

// DFFS
dff dffA ( .clk(clock), .rst_n(rst_n), .d(wA1), .q(Aout), .q_n(Aout_n) );
dff dffB ( .clk(clock), .rst_n(rst_n), .d(wB1), .q(Bout), .q_n(Bout_n) );
dff dffC ( .clk(clock), .rst_n(rst_n), .d(wC1), .q(Cout), .q_n(Cout_n) );
dff dffD ( .clk(clock), .rst_n(rst_n), .d(wD1), .q(Dout), .q_n(Dout_n) );
// FULL ADDERS
fa4bit faApB ( .A(Aout), .B(Bout), .F(w1), .Cin_tied(1'b0) );
fa4bit faCpD ( .A(Cout), .B(Dout), .F(w2), .Cin_tied(1'b0) );

inverter w2_n ( .A(w2), .An(w3) );

fa5bit faW1pW3 ( .A(w1), .B(w3), .F(result), .Cin_tied(1'b1), .Cout(ignore) );


endmodule

module notgate (
    input A,
    output An
);

    assign An = ~A;
endmodule

module and3 (
    input A, B, C,
    output F
);

    assign F = A & B & C;
endmodule

module and4 (
    input A, B, C, D,
    output F
);

    assign F = A & B & C & D;
endmodule

module andgate (
    input A, B,
    output F
);

    assign F = A & B;
endmodule

module orgate (
    input A, B,
    output F
);

    assign F = A | B;
endmodule

module or3 (
    input A, B, C,
    output F
);

    assign F = A | B | C;
endmodule

module mux41A (
    input [3:0] d_in, Aout, 
    input [1:0] op,
    output [3:0] wA );

    assign wA = (op == 2'b00) ? d_in : Aout;

endmodule

module mux41B (
    input [3:0] d_in, Bout, 
    input [1:0] op,
    output [3:0] wB );

    assign wB = (op == 2'b01) ? d_in : Bout;

endmodule

module mux41C (
    input [3:0] d_in, Cout, 
    input [1:0] op,
    output [3:0] wC );

    assign wC = (op == 2'b10) ? d_in : Cout;

endmodule

module mux41D (
    input [3:0] d_in, Dout, 
    input [1:0] op,
    output [3:0] wD );

    assign wD = (op == 2'b11) ? d_in : Dout;

endmodule

module inverter (
    input [4:0] A,
    output [4:0] An
);

    assign An = ~A;

endmodule
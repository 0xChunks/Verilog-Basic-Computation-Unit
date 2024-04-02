// Structural 4-bit adder
module fa4bit (
  input [3:0] A, B,
  input Cin_tied,
  output [4:0] F
);

  wire w1, w2, w3;

  fa U1 ( Cin_tied, A[0], B[0], w1, F[0] );
  fa U2 ( w1, A[1], B[1], w2, F[1] );
  fa U3 ( w2, A[2], B[2], w3, F[2] );
  fa U4 ( w3, A[3], B[3], F[4], F[3] );

endmodule

module fa5bit (
  input [4:0] A, B,
  input Cin_tied,
  output  Cout,
  output [4:0] F
 
);

wire w1, w2, w3, w4;

  fa U1 ( Cin_tied, A[0], B[0], w1, F[0] );
  fa U2 ( w1, A[1], B[1], w2, F[1] );
  fa U3 ( w2, A[2], B[2], w3, F[2] );
  fa U4 ( w3, A[3], B[3], w4, F[3] );
  fa U5 ( w4, A[4], B[4], Cout, F[4] );

endmodule

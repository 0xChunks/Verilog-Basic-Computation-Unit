module proj001_tb;

  reg rst_n, clock;
  wire [3:0] d_in;
  wire [1:0] op;
  wire capture;
  wire valid;
  wire [4:0] result;

  // for stimulus from tb_player file
  wire [6:0] play_vec;
  wire done;

  // free running clock 
  initial clock = 0;
  always #5 clock = ~clock;

  // active low synchronous reset
  initial begin
        rst_n = 0;
    #10 rst_n = 1;
  end

  // DUT
  proj001 DUT (
    .rst_n( rst_n ),
    .clock( clock ),
    .d_in( d_in ),
    .op( op ),
    .capture( capture ),
    .valid( valid ),
    .result( result )
  );

  tb_player #(
    .WIDTH( 7 ),
    .PFILE( "single_op.dat" )
  ) player (
    .rst_n( rst_n ),
    .clock( clock ),
    .play( play_vec ),
    .done( done )
  );

  // pull out the signals from stimulus
  assign { capture, op, d_in } = play_vec;

  // get the simulator to stop
  initial begin
    wait( done );
    #10 $stop();
  end

endmodule


module Cblock_tb();
  /* Dump Test Waveform To VPD File */
  initial begin
    $fsdbDumpfile("waveform.fsdb");
    $fsdbDumpvars();
  end

	logic enable;
	logic [2:0] left_i;
	logic       up_o;
	logic       up_i;
	logic [2:0] right_o;
	logic       down_i;
	logic       down_o;
	logic [17:0] bits;

initial begin
	enable = 1;
	left_i = 3'bzzz;
	up_i = 1'bz;
	down_i = 1'bz;
	// 6V 3LU 3DR 3UR 3LD
	bits = 18'b000001_100_000_000_010;
	#10 enable = 0;
	#20 left_i = 3'b110;
	up_i = 0;
	down_i = 1 ;
	#5 $display("right_o: %b up_o: %b, down_o: %b", right_o, up_o, down_o);
end

  Cblock DUT
    (.wr_en   ( enable )
    ,.left_i  ( left_i )
    ,.up_o    ( up_o )
    ,.up_i    ( up_i )
    ,.right_o ( right_o )
    ,.down_i  ( down_i )
    ,.down_o  ( down_o )
    ,.bits    ( bits )
    );
endmodule

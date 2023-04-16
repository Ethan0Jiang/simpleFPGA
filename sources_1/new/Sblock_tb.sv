
module Sblock_tb();
  /* Dump Test Waveform To VPD File */
  initial begin
    $fsdbDumpfile("waveform.fsdb");
    $fsdbDumpvars();
  end

	logic enable;
	logic [2:0] left_i;
	logic [2:0] up_i;
	logic [2:0] right_o;
	logic [2:0] down_o;
	logic [17:0] bits;
initial begin
	enable = 1;
	left_i = 3'b000;
	up_i = 3'b000;
	// 9H 9V
	bits = 18'b111000111111000111;
	#10 enable = 0;
	#20 left_i = 3'b111;
	up_i = 3'b111;
	#5 $display("right_o: %b down_o: %b", right_o, down_o);
end

  Sblock DUT
    (.wr_en   ( enable )
    ,.left_i  ( left_i )
    ,.up_i    ( up_i )
    ,.right_o ( right_o )
    ,.down_o  ( down_o )
    ,.bits    ( bits )
    );
endmodule

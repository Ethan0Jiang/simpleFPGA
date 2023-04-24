
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

	task set_bits(ref enable, ref [17:0] bits, input [17:0] bit_in);
		#10
		enable = 1'b1;
		bits = bit_in;
		#10
		enable = 1'b0;
	endtask

	task test_io(ref [2:0] left_i, ref up_i, ref down_i, input [4:0] bit_in, input [4:0] bit_expect);
	//task test_io(ref [2:0] left_i, ref up_i, ref down_i, ref [2:0] right_o, ref down_o, ref up_o, input [4:0] bit_in);
		#10
		left_i = bit_in[4:2]; up_i = bit_in[1]; down_i = bit_in[0];
		#10
		if({right_o, down_o, up_o} != bit_expect) begin
			$display("ERROR:          right_o: %b down_o: %b, up_o: %b", right_o, down_o, up_o);
			$display("EXPECTED:       right_o: %b down_o: %b, up_o: %b", bit_expect[4:2], bit_expect[1], bit_expect[0]);
		end
		else
			$display("PASS");
	endtask

initial begin
    $display("  _______        _   _                     _     ");
    $display(" |__   __|      | | | |                   | |    ");
    $display("    | | ___  ___| |_| |__   ___ _ __   ___| |__  ");
    $display("    | |/ _ \/ __| __| '_ \ / _ \ '_ \ / __| '_ \ ");
    $display("    | |  __/\__ \ |_| |_) |  __/ | | | (__| | | |");
    $display("    |_|\___||___/\__|_.__/ \___|_| |_|\___|_| |_|");
    $display("                                                 ");
    // Testsuite: intended to make error here
	//set_bits(enable, bits, 18'b111111000000000000);
	//test_io(left_i, up_i, down_i, 5'b11001, 5'b00110);
	//test_io(left_i, up_i, down_i, 5'b00110, 5'b11001);

    // Testsuite: all horizontal + all vertical
	set_bits(enable, bits, 18'b111111000000000000);
	test_io(left_i, up_i, down_i, 5'b11001, 5'b11001);
	test_io(left_i, up_i, down_i, 5'b00110, 5'b00110);

    // Testsuite: middle highway propagate to top&down CLB
	set_bits(enable, bits, 18'b001001010000000010);
	test_io(left_i, up_i, down_i, 5'b11100, 5'b11111);
	test_io(left_i, up_i, down_i, 5'b10111, 5'b10100);

    // Testsuite: top&down CLB propagate to different highway
	set_bits(enable, bits, 18'b100110000010001000);
	test_io(left_i, up_i, down_i, 5'b1zz11, 5'b111zz);
	test_io(left_i, up_i, down_i, 5'b0zz00, 5'b000zz);

    // Testsuite: top&down CLB propagate to different highway, but also continues to vertically propagate (1 drive 2)
	set_bits(enable, bits, 18'b111111000010001000);
	test_io(left_i, up_i, down_i, 5'b1zz11, 5'b11111);
	test_io(left_i, up_i, down_i, 5'b0zz00, 5'b00000);

    // Testsuite: one CLB broadcast to three highways, and propagates vertically (1 drive 4)
	set_bits(enable, bits, 18'b111000000111000000);
	test_io(left_i, up_i, down_i, 5'bzzz01, 5'b1111z);
	test_io(left_i, up_i, down_i, 5'bzzz10, 5'b0000z);

    // Testsuite: CLB line make a U-turn to another CLB line (maybe won't exist in real-world case)
	set_bits(enable, bits, 18'b110011000100000100);
	test_io(left_i, up_i, down_i, 5'bzzzz1, 5'bzzz1z);
	test_io(left_i, up_i, down_i, 5'bzzz10, 5'bzzz0z);

    // Testsuite: first highway contribute to CLB line, and another CLB line propagates to two remaining highway
	set_bits(enable, bits, 18'b100011000011000100);
	test_io(left_i, up_i, down_i, 5'b1zzz1, 5'b111z1);
	test_io(left_i, up_i, down_i, 5'b1zz10, 5'b100z1);

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

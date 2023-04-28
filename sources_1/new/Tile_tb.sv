module Tile_tb;
//           lc_V_o,cl_V_i       sc_V_i
//               _|_|_       ___|__|__|___
//   cl_H_i---->|     |---->|             |---->cl_H_o
//   lc_H_o<----|_____|<----|_____________|<----lc_H_i
//                | |           |  |  |
//                | |           |  |  |
//               ------       -----------
//    sc_H_i--->|      |--->|             |---->sc_H_o
//          --->|      |--->|             |---->
//          --->|______|--->|_____________|---->
//                | |           |  |  |
//           lc_V_i,cl_V_o       sc_V_o   

    // Inputs
    logic clk;
    logic wr_en;
  	logic [76:0] bits;
    logic cl_V_i; // to the CLB
    logic cl_H_i;
    logic lc_V_i;   // to the bottom left C
    logic lc_H_i;   // to the top right C
    logic [2:0] sc_V_i;  // to the CBlock
    logic [2:0] sc_H_i;

    // Outputs
    logic lc_V_o;   // CLB to up
    logic lc_H_o;   // CLB to left
    logic cl_V_o;   // bottom left out
    logic cl_H_o;   // top right out
  	logic [2:0] sc_V_o;
  	logic [2:0] sc_H_o;


    // Instantiate the CLB module
    Tile dut (
        .clk,
        .wr_en,
        .bits,
        .cl_V_i,
        .cl_H_i,
        .lc_V_i,
        .lc_H_i,  
        .sc_V_i, 
        .sc_H_i,
        .lc_V_o,  
        .lc_H_o,  
        .cl_V_o,  
        .cl_H_o, 
        .sc_V_o,
        .sc_H_o
    );

  // Clock generation
  parameter CLOCK_PERIOD=5;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
    end // initial

  // Stimulus
    initial begin
        `ifndef PRE_SYN
        $sdf_annotate("Tile.sdf", dut); // dut name
        `endif
        $fsdbDumpfile("Tile.fsdb");
        $fsdbDumpvars(0, Tile_tb);  // module_tb name
        $dumpfile("Tile.vcd");
        $dumpvars();
//       $dumpfile("dump.vcd"); $dumpvars;
    end

    // 77 bits: CLB BL TR S
    task set_bits(output wr_en, output [76:0] bits, input clk, input [76:0] bit_in); 
        $display("write bit: %b", bit_in);
		wr_en <= 0;	bits <= 77'd0;	@(posedge clk); // all direct in/out
		wr_en <= 1;	bits <= bit_in;	@(posedge clk); // all direct in/out
        wr_en <= 0;	bits <= 77'd0;	@(posedge clk); // all direct in/out
	endtask

    task test_comb(
        output cl_V_i,  // to the CLB
        output cl_H_i,
        output lc_V_i,   // to the bottom left C
        output lc_H_i,   // to the top right C
        output [2:0] sc_V_i,  // to the CBlock
        output [2:0] sc_H_i,
        input lc_V_o,   // CLB to up
        input lc_H_o,   // CLB to left
        input cl_V_o,   // bottom left out
        input cl_H_o,   // top right out
        input [2:0] sc_V_o,
        input [2:0] sc_H_o,
        input clk
        ); 
      for (int i = 0; i < 20; i++) begin
	    lc_V_o <= $urandom_range(0, 2); 
            lc_H_o <= $urandom_range(0, 2);
            cl_V_o <= $urandom_range(0, 2);
            cl_H_o <= $urandom_range(0, 2);
            sc_V_o <= $urandom_range(0, 7); 
            sc_H_o <= $urandom_range(0, 7);
            @(posedge clk);
            assert (lc_V_o === (dut.CLB0.up_i&dut.CLB0.down_i|dut.CLB0.right_i&dut.CLB0.left_i));
            assert (lc_H_o === (dut.CLB0.up_i&dut.CLB0.down_i|dut.CLB0.right_i&dut.CLB0.left_i));
            assert (dut.CLB0.up_i === cl_V_i);
            assert (dut.CLB0.down_i === sc_H_i[2]);
            assert (dut.CLB0.right_i === sc_V_i[2]);
	    assert (dut.CLB0.left_i === cl_H_i);

            assert (cl_H_o === sc_V_i[1]);

            assert (sc_H_o[2] === 1'bZ);
            assert (sc_H_o[1] === sc_H_i[1]);
            assert (sc_H_o[0] === 1'bZ);

            assert (sc_V_o[2] === sc_V_i[0]);
            assert (sc_V_o[1] === cl_H_i);
            assert (sc_V_o[0] === lc_H_i);

            assert (cl_V_o === sc_H_i[0]);
        end
		
	endtask

    initial begin
        $display("Testbench Started");
        // Wait a few clock cycles
        repeat(5) @(posedge clk);
        set_bits(wr_en, bits, clk, 77'b10011100001000100011111_000000100000000001_000000010000000100_000111000111111111);
      	test_comb(cl_V_i, cl_H_i, lc_V_i, lc_H_i, sc_V_i, sc_H_i, lc_V_o, lc_H_o, cl_V_o, cl_H_o, sc_V_o, sc_H_o, clk);
        repeat(2) @(posedge clk);
        $display("Testbench finished");
        $finish;
    end
endmodule

`timescale 1ns / 1ps
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
    // $dumpfile("dump.vcd"); $dumpvars;
  end

  initial begin
    $display("Testbench Started");
    // Wait a few clock cycles
    repeat(5) @(posedge clk);
    $display("write bit: %b", 77'b10011100001000100011111_000000100000000001_000000010010100100_000111000111111111);
		wr_en <= 0;	bits <= 77'd0;	@(posedge clk); // all direct in/out
		wr_en <= 1;	bits <= 77'b10011100001000100011111_000000100000000001_000000010010100100_000111000111111111;	@(posedge clk);
    wr_en <= 0;	bits <= 77'd0;	@(posedge clk); // all direct in/out
    for (int i = 0; i < 36; i++) begin
      lc_V_i = i % 2;
      lc_H_i = (i + 1) % 2;
      cl_V_i = (i + 2) % 2;
      cl_H_i = (i + 3) % 2;
      sc_V_i = i % 8;
      sc_H_i = (i + 1) % 8;
      @(posedge clk);
      assert (lc_V_o === ((dut.CLB0.up_i&dut.CLB0.down_i)|(dut.CLB0.right_i&dut.CLB0.left_i))); ///
      assert (lc_H_o === (dut.CLB0.up_i&dut.CLB0.down_i|dut.CLB0.right_i&dut.CLB0.left_i)); ///
      assert (dut.CLB0.up_i === cl_V_i);
      assert (dut.CLB0.down_i === sc_H_i[2]);
      assert (dut.CLB0.right_i === sc_V_i[0]);
      assert (dut.CLB0.left_i === cl_H_i);
      assert (dut.CLB0.left_i === dut.CLB0.right_o);

      assert (cl_H_o === sc_V_i[1]);

      assert (sc_H_o[2] === 1'bZ);
      assert (sc_H_o[1] === sc_H_i[1]);
      assert (sc_H_o[0] === 1'bZ);

      assert (sc_V_o[2] === sc_V_i[2]);
      assert (sc_V_o[1] === cl_H_i); 
      assert (sc_V_o[0] === lc_H_i);
      
      // $display("lut_addr = %b, lc_V_o = %b", dut.CLB0.lut_addr, lc_V_o);
//       $display("dut.S0.up_i[2] = %b, dut.S0.up_i[1] = %b, dut.S0.up_i[0] = %b", dut.S0.up_i[2], dut.S0.up_i[1], dut.S0.up_i[0]);

      assert (cl_V_o === sc_H_i[0]);
    end

  repeat(2) @(posedge clk);
  $display("Testbench finished");
  $finish;
  
  end
endmodule

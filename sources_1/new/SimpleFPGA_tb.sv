`timescale 1ns / 1ps
module SimpleFPGA_tb;
// top row i:
// cl_V_in[0]  sc_V_in[0][2:0]   cl_V_in[1]  sc_V_in[1][2:0]   cl_V_in[2]  sc_V_in[2][2:0]   cl_V_in[3]  sc_V_in[3][2:0]      
// bottom row o;
// cl_V_out[0]                   cl_V_out[1]                   cl_V_out[2]                   cl_V_out[3]   

    logic rst;
    logic clk;
    logic [76:0] bit_i;
    logic bit_v_i;
    logic bit_r_o;
    logic done_o;
    logic [3:0] cl_V_in;  // first row input to clb
    logic [3:0][2:0] sc_V_in;
    logic [3:0] cl_V_out;
    logic [76:0] bit_w [0:15];
    logic [1:0] A,B,S;
    logic cout;
    integer cnt, fin;
  
    assign cl_V_in[0] = A[0];
    assign cl_V_in[1] = A[1];
    assign sc_V_in[0][2] = B[0];
    assign sc_V_in[1][2] = B[1];
    assign S[0] = cl_V_out[0];
    assign S[1] = cl_V_out[1];

  // Instantiate the CLB module
    SimpleFPGA dut (.*);

  // Clock generation
    parameter CLOCK_PERIOD=50;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
    end // initial

// Stimulus
    initial begin
        `ifndef PRE_SYN
        $sdf_annotate("SimpleFPGA.sdf", dut); // dut name
        `endif
        $fsdbDumpfile("SimpleFPGA.fsdb");
        $fsdbDumpvars(0, SimpleFPGA_tb);  // module_tb name
        $dumpfile("SimpleFPGA.vcd");
        $dumpvars();
// $dumpfile("dump.vcd"); $dumpvars;
    end

  initial begin
    bit_w[00] = 77'b01001100011001100110011000111000000000000000001000000000010000000000000000000;
    bit_w[01] = 77'b00000000000000000000000000000000000000000000000100000000000000000000000111000;
    bit_w[02] = 77'b00101100000000000110011000000000000000000111000000100000001000000000000111111;
    bit_w[03] = 77'b00101100011001111001100000111000000000000100000000010000001000000000111111000;
    bit_w[04] = 77'b01001100011001100110011000111000000000000000001000000000010000000000000000000;
    bit_w[05] = 77'b00101100001000101110111000000000000000000111000000000000001000000000000111000;
    bit_w[06] = 77'b00101100110011010011001000111000000000000100000000010000001000000000111111000;
    bit_w[07] = 77'b00000000000000000000000000111000000000000000000000000000000000000000111000000;
    bit_w[08] = 77'b00000000000000000000000000111000000000000000000000000000000000000000000000000;
    bit_w[09] = 77'b01001100101010101010101000111000000000000000000000000000000000000000000000000;
    bit_w[10] = 77'b00000000000000000000000000000000000000000000000000000000000000000000000000000;
    bit_w[11] = 77'b00000000000000000000000000000000000000000000000000000000000000000000000000000;
    bit_w[12] = 77'b00000000000000000000000000000000000000000000000000000000000000000000000000000;
    bit_w[13] = 77'b00000000000000000000000000000000000000000000000000000000000000000000000000000;
    bit_w[14] = 77'b00000000000000000000000000000000000000000000000000000000000000000000000000000;
    bit_w[15] = 77'b00000000000000000000000000000000000000000000000000000000000000000000000000000;
    

    $display("Testbench Started");
    bit_v_i<=0;
    cnt <=0; fin <=0;
    rst <=0; repeat(5) @(posedge clk);
    rst <=1; repeat(5) @(posedge clk);
    rst <=0; repeat(5) @(posedge clk);
    // Wait a few clock cycles
    $display("write bit");
    bit_i <=bit_w[0]; bit_v_i=1;  @(posedge clk);
    bit_i <=bit_w[1]; bit_v_i=1;  @(posedge clk);
    bit_i <=bit_w[2]; bit_v_i=1;  @(posedge clk);
    bit_i <=bit_w[3]; bit_v_i=1;  @(posedge clk);
    bit_v_i=0; repeat(5) @(posedge clk);
    bit_i <=bit_w[4]; bit_v_i=1;  @(posedge clk);
    bit_i <=bit_w[5]; bit_v_i=1;  @(posedge clk);
    bit_i <=bit_w[6]; bit_v_i=1;  @(posedge clk);
    bit_i <=bit_w[7]; bit_v_i=1;  @(posedge clk);
    bit_v_i=0; repeat(5) @(posedge clk);
    bit_i <=bit_w[8]; bit_v_i=1;  @(posedge clk);
    bit_i <=bit_w[9]; bit_v_i=1;  @(posedge clk);
    bit_i <=bit_w[10]; bit_v_i=1;  @(posedge clk);
    bit_i <=bit_w[11]; bit_v_i=1;  @(posedge clk);
    bit_v_i=0; repeat(5) @(posedge clk);
    bit_i <=bit_w[12]; bit_v_i=1;  @(posedge clk);
    bit_i <=bit_w[13]; bit_v_i=1;  @(posedge clk);
    bit_i <=bit_w[14]; bit_v_i=1;  @(posedge clk);
    bit_i <=bit_w[15]; bit_v_i=1;  @(posedge clk);
    bit_v_i=0; repeat(5) @(posedge clk);
    bit_v_i=0; repeat(2) @(posedge clk);
    $display("finish writing");
    
	A <= 0; B <= 0; @(posedge clk);
    assert (S == A+B);
    A <= 0; B <= 1; @(posedge clk);
    assert (S == A+B);
    A <= 0; B <= 2; @(posedge clk);
    assert (S == A+B);
    A <= 0; B <= 3; @(posedge clk);
    assert (S == A+B);
    
    A <= 1; B <= 0; @(posedge clk);
    assert (S == A+B);
    A <= 1; B <= 1; @(posedge clk);
    assert (S == A+B);
    A <= 1; B <= 2; @(posedge clk);
    assert (S == A+B);
    A <= 1; B <= 3; @(posedge clk);
    assert (S == A+B);
    
    
    
  repeat(2) @(posedge clk);
  $display("Testbench finished");
  $finish;
  
  end
endmodule

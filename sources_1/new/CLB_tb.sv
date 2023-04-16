module CLB_tb;

  // Inputs
  logic clk_i;
  logic wr_en;
  logic up_i;
  logic down_i;
  logic right_i;
  logic left_i;
  logic [22:0] bits;

  // Outputs
  logic up_o;
  logic down_o;
  logic right_o;
  logic left_o;

  logic [15:0] lut;

  // Instantiate the CLB module
  CLB dut (
    .clk_i(clk_i),
    .wr_en(wr_en),
    .up_i(up_i),
    .down_i(down_i),
    .right_i(right_i),
    .left_i(left_i),
    .bits(bits),
    .up_o(up_o),
    .down_o(down_o),
    .right_o(right_o),
    .left_o(left_o)
  );

  // Clock generation
  parameter CLOCK_PERIOD=5;
  initial begin
    clk_i <= 0;
    forever #(CLOCK_PERIOD/2) clk_i <= ~clk_i; // Forever toggle the clock
  end // initial

  // Stimulus
  initial begin
    `ifndef PRE_SYN
    $sdf_annotate("CLB.sdf", dut); // dut name
    `endif
    //$vcdpluson;
    $fsdbDumpfile("CLB.fsdb");
    $fsdbDumpvars(0, CLB_tb);  // module_tb name
    $dumpfile("CLB.vcd");
    $dumpvars();

    wr_en = 0;
    up_i = 0;
    down_i = 0;
    right_i = 0;
    left_i = 0;
    bits = 0;

    // Wait a few clock cycles
    repeat(3) @(posedge clk_i);

    // test direct connection
    // Enable the write and set some bits
    wr_en = 1;	bits = 23'b0000_0_11_0101001000110111;	@(posedge clk_i); // all direct in/out
    wr_en = 0;	bits = 23'b0000_0_11_0101001000110111;	@(posedge clk_i); // wrote in
    // Change the input values and check the outputs
    up_i = 1;	down_i = 1;	right_i = 0;	left_i = 1;	@(posedge clk_i);
    assert (down_o === up_i); 
    assert (up_o === down_i);
    assert (left_o === right_i);
    assert (right_o === left_i);
    
    up_i = 0;	down_i = 1;	right_i = 1;	left_i = 0;	@(posedge clk_i);
    assert (down_o === up_i); 
    assert (up_o === down_i);
    assert (left_o === right_i);
    assert (right_o === left_i);
    
    // Wait a few more clock cycles
    repeat(3) @(posedge clk_i);
    
    // test LUT
    assign lut = 16'b0101101000110111;
    // Enable the write and set some bits
    wr_en = 1;	bits = {{23'b0110_1_10},{lut}};	@(posedge clk_i); // all direct in/out
    wr_en = 0;	bits = {{23'b0110_1_10},{lut}};	@(posedge clk_i); // wrote in
    // Change the input values and check the outputs
    up_i <= 1;	down_i <= 1;	right_i <= 0;	left_i <= 1;	@(posedge clk_i);
    assert (up_o === down_i);
    assert (left_o === right_i);
    assert (down_o === lut[4'b1101]);
    assert (right_o === lut[4'b1101]);
    
    up_i = 0;	down_i = 0;	right_i = 0;	left_i = 1;	@(posedge clk_i);
    assert (up_o === down_i);
    assert (left_o === right_i);
    assert (down_o === lut[4'b0001]);
    assert (right_o === lut[4'b0001]);
    
    // Wait a few more clock cycles
    repeat(3) @(posedge clk_i);
    
    // test LUT
    assign lut = 16'b1111111100000000;
    // Enable the write and set some bits
    wr_en <= 1;	bits <= {{23'b1111_0_00},{lut}};	@(posedge clk_i); // all direct in/out
    wr_en <= 0;	bits <= {{23'b1111_0_00},{lut}};	@(posedge clk_i); // wrote in
    // Change the input values and check the outputs
    up_i <= 1;	down_i <= 1;	right_i <= 0;	left_i <= 1;	@(posedge clk_i);
    @(posedge clk_i);
    assert (up_o === lut[4'b1101]);
    assert (left_o === lut[4'b1101]);
    assert (down_o === lut[4'b1101]);
    assert (right_o === lut[4'b1101]);
    
    up_i <= 0;	down_i <= 0;	right_i <= 0;	left_i <= 0;	@(posedge clk_i);
    @(posedge clk_i);
    assert (up_o === lut[4'b1101]);
    assert (left_o === lut[4'b1101]);
    assert (down_o === lut[4'b1101]);
    assert (right_o === lut[4'b1101]);
    
    up_i <= 0;	down_i <= 0;	right_i <= 0;	left_i <= 1;	@(posedge clk_i);
    assert (up_o === lut[4'b1101]);
    assert (left_o === lut[4'b1101]);
    assert (down_o === lut[4'b1101]);
    assert (right_o === lut[4'b1101]);
    
    @(posedge clk_i);
    assert (up_o === lut[4'b0001]);
    assert (left_o === lut[4'b0001]);
    assert (down_o === lut[4'b0001]);
    assert (right_o === lut[4'b0001]);
    
    // Wait a few more clock cycles
    repeat(3) @(posedge clk_i);

    $display("Testbench finished");
    $finish;
  end

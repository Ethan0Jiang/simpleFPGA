module CLB(
    input logic clk,
    input logic wr_en,
    input logic up_i,
    input logic down_i,
    input logic right_i,
    input logic left_i,
    input logic [22:0] bits, //  22:19 out_sel,  18 LUTorDFF_mux,  17:16 DFF_en_mux, 15:0 lut
    output logic up_o,
    output logic down_o,
    output logic right_o,
    output logic left_o
    );
    
//    logic [3:0] red;    // output at: 3up, 2down, 1right, 0left 
//    logic [3:0] green;  // output at: 3up, 2down, 1right, 0left  
    logic [3:0] out_sel;  // if 1 , connect to sig out if 0, direct input to output
    logic o_mux_ctrl;     // if 1 luts, if 0 ff
    logic [1:0] ff_en_ctrl; // 00 use left input, 01 right, 10 alway_1, 11 up
    logic [15:0] lut;
    logic lut_out;
    logic ff_out;
    logic sig_out;
   	logic up, down, right, left; 
    logic [3:0] lut_addr;
    logic ff_en;
    always_ff @(posedge clk) begin
		if (wr_en) begin
            out_sel <= bits[22:19];
            o_mux_ctrl <= bits[18];
            ff_en_ctrl <= bits[17:16];
            lut <= bits[15:0];
        end
    end
    
    assign up_o     = out_sel[3] ? sig_out : down_i;
    assign down_o   = out_sel[2] ? sig_out : up_i;
    assign right_o  = out_sel[1] ? sig_out : left_i;
    assign left_o   = out_sel[0] ? sig_out : right_i;
//    assign lut_addr  = {up_i,down_i,right_i, left_i};
    assign sig_out = o_mux_ctrl ? lut_out: ff_out;
//    assign up = up_i ? 1:0;
//	assign down = down_i ? 1:0;
//	assign right = right_i ? 1:0;
//	assign left = left_i ? 1:0;
	always_comb begin
		up = 0;
		down = 0;
		right = 0;
		left = 0;
		if (up_i) up = 1;
		if (down_i) down = 1;
		if (right_i) right = 1;
		if (left_i) left = 1;
	end


	assign lut_addr  = {up,down,right, left};
    always_comb begin
        lut_out = 0;
        case(lut_addr)
            4'd15: lut_out=lut[0];4'd14: lut_out=lut[1];
            4'd13: lut_out=lut[2];4'd12: lut_out=lut[3];
            4'd11: lut_out=lut[4];4'd10: lut_out=lut[5];
            4'd09: lut_out=lut[6];4'd08: lut_out=lut[7];
            4'd07: lut_out=lut[8];4'd06: lut_out=lut[9];
            4'd05: lut_out=lut[10];4'd04: lut_out=lut[11];
            4'd03: lut_out=lut[12];4'd02: lut_out=lut[13];
            4'd01: lut_out=lut[14];4'd00: lut_out=lut[15];
        endcase
        ff_en = 1;
        case(ff_en_ctrl)        // Careful with the ff_en_ctrl bits
            2'b00: ff_en=left_i;
            2'b01: ff_en=right_i;
            2'b10: ff_en=1;     // not using the down port input. 
            2'b11: ff_en=up_i;
        endcase
    end
    
    always_ff @(posedge clk) if (ff_en) ff_out <= lut_out;
    
endmodule

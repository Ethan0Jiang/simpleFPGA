module Sblock(
	input logic wr_en,
	input logic [2:0]  left_i,
	input logic [2:0]  up_i,
	output logic [2:0]  right_o, // using wire here, otherwise VCS gives error
	output logic [2:0]  down_o,
	input logic [17:0] bits, // 9(dots)*2(bits/dot)
	input logic clk
);
	logic [8:0] dot_ctrl_H; //should synthesize to DLH std cell (high enable latch)
	logic [8:0] dot_ctrl_V; //should synthesize to DLH std cell (high enable latch)
	always_ff(@posedge clk) begin
		if (wr_en) begin
			dot_ctrl_H <= bits[17:9];
			dot_ctrl_V <= bits[8:0];
		end
	end

	//         port_in        port_in        port_in
	//
	//port_in   (buf)   wire   (buf)   wire   (buf)   port_out
	//
        //          wire           wire           wire
	//
	//port_in   (buf)   wire   (buf)   wire   (buf)   port_out
	//
        //          wire           wire           wire
	//
	//port_in   (buf)   wire   (buf)   wire   (buf)   port_out
	//
	//         port_out       port_out       port_out
	//==========================================================
	//           up_i[2]        up_i[1]        up_i[0]
	//
	//left_i[2] H[8]/V[8] H_12 H[7]/V[5] H_02 H[6]/V[2] right_o[2]
	//
        //            V_21           V_11           V_01
	//
	//left_i[1] H[5]/V[7] H_11 H[4]/V[4] H_01 H[3]/V[1] right_o[1]
	//
        //            V_20           V_10           V_00
	//
	//left_i[0] H[2]/V[6] H_10 H[1]/V[3] H_00 H[0]/V[0] right_o[0]
	//
	//          down_o[2]      down_o[1]      down_o[0]
	
	// Using bottom-right as (0,0), Input/Output LSB convention

	logic H_00, H_01, H_02, H_10, H_11, H_12;
	logic V_00, V_01, V_10, V_11, V_20, V_21;

	assign right_o[2] = dot_ctrl_H[6] ? left_i[2] : 1'bZ;
	assign right_o[1] = dot_ctrl_H[3] ? left_i[2] : 1'bZ;
	assign right_o[0] = dot_ctrl_H[0] ? left_i[2] : 1'bZ;

	assign down_o[2] = dot_ctrl_V[6] ? left_i[2] : 1'bZ;
	assign down_o[1] = dot_ctrl_V[3] ? left_i[2] : 1'bZ;
	assign down_o[0] = dot_ctrl_V[0] ? left_i[2] : 1'bZ;

endmodule



module Cblock(
	input logic wr_en,
	input logic [2:0] left_i,
	input logic [1:0] up_i,
	input logic [17:0] bits, // 6(dots)*3(bits/dot)
	output wire [2:0] right_o, // using wire here, otherwise VCS gives error
	output wire [1:0] down_o
);
	logic [5:0] dot_ctrl_V; //should synthesize to DLH std cell (high enable latch)
	logic [5:0] dot_ctrl_UR; //up to right, should synthesize to DLH std cell (high enable latch)
	logic [5:0] dot_ctrl_LD; //left to down, should synthesize to DLH std cell (high enable latch)
	always_latch begin
		if (wr_en) begin
			dot_ctrl_V = bits[17:12];
			dot_ctrl_UR = bits[11:6];
			dot_ctrl_LD = bits[5:0];
		end
	end

	//         port_in        port_in  
	//               UR             UR
	//port_in   (buf)   wire   (buf)    port_out
	//        LD             LD
        //          wire           wire    
	//               UR             UR
	//port_in   (buf)   wire   (buf)    port_out
	//        LD             LD
        //          wire           wire    
	//               UR             UR
	//port_in   (buf)   wire   (buf)    port_out
	//        LD             LD
	//         port_out       port_out 

	wire H_0, H_1, H_2;
	wire V_00, V_01, V_10, V_11;

	//     out     in         enable(high)
	bufif1(H_10, left_i[1], dot_ctrl_H[5]);
	bufif1(H_11, H_10, dot_ctrl_H[4]);
	bufif1(right_o[1], H_11, dot_ctrl_H[3]);
	bufif1(H_20, left_i[2], dot_ctrl_H[2]);
	bufif1(H_21, H_20, dot_ctrl_H[1]);
	bufif1(right_o[2], H_21, dot_ctrl_H[0]);

	bufif1(V_00, up_i[0], dot_ctrl_V[8]);
	bufif1(V_01, V_00, dot_ctrl_V[7]);
	bufif1(down_o[0], V_01, dot_ctrl_V[6]);
	bufif1(V_10, up_i[1], dot_ctrl_V[5]);
	bufif1(V_11, V_10, dot_ctrl_V[4]);
	bufif1(down_o[1], V_11, dot_ctrl_V[3]);
	bufif1(V_20, up_i[2], dot_ctrl_V[2]);
	bufif1(V_21, V_20, dot_ctrl_V[1]);
	bufif1(down_o[2], V_21, dot_ctrl_V[0]);
endmodule


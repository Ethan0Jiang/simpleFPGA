module Cblock(
	input logic        wr_en,
	input wire [2:0]  left_i,
	output wire        up_o,
	input wire        up_i,
	output wire [2:0]  right_o, // using wire here, otherwise VCS gives error
	input wire        down_i,
	output wire        down_o,
	input logic [17:0] bits // 6(dots)*3(bits/dot)
);
	logic [5:0] dot_ctrl_V; //should synthesize to DLH std cell (high enable latch)
	logic [2:0] dot_ctrl_LU; 
	logic [2:0] dot_ctrl_DR; 
	logic [2:0] dot_ctrl_UR; 
	logic [2:0] dot_ctrl_LD; 
	always_latch begin
		if (wr_en) begin
			//Vertical, LeftUp, DownRight, UpRight, LeftDown
			dot_ctrl_V = bits[17:12];
			dot_ctrl_LU = bits[11:9];
			dot_ctrl_DR = bits[8:6];
			dot_ctrl_UR = bits[5:3];
			dot_ctrl_LD = bits[2:0];
		end
	end

	//         port_out       port_in  
	//        LU                    UR
	//port_in   ( V )   wire   ( V )    port_out
	//               DR      LD
        //          wire           wire    
	//        LU                    UR
	//port_in   ( V )   wire   ( V )    port_out
	//               DR      LD
        //          wire           wire    
	//        LU                    UR
	//port_in   ( V )   wire   ( V )    port_out
	//               DR      LD
	//         port_in        port_out 
	//=============================================
	//               up_o                up_i  
	//          LU[2]                        UR[2]
	//left_i[2]      V[3]       H_2      V[2]      right_o[2]
	//                   DR[2]      LD[2]
        //               V_11                V_01    
	//          LU[1]                        UR[1]
	//left_i[1]      V[4]       H_1      V[1]      right_o[1]
	//                   DR[1]      LD[1]
        //               V_10                V_00    
	//          LU[0]                        UR[0]
	//left_i[0]      V[5]       H_0      V[0]      right_o[0]
	//                   DR[0]      LD[0]
	//              down_i              down_o 

	// Using bottom-right as (0,0), Input/Output LSB convention
	// 
	// Some combinations of bitstream may not work, be careful
	// with bitstream generation.
	//
	// In this design, the 3-horizontal lines are highways
	// CLB may use DR/UR to get in the highway
	// CLB may use LU/LD to get off the highway
	// The highway itself's connection is controlled by Sblock
	
	wire H_0, H_1, H_2;
	wire V_00, V_01, V_10, V_11;

	assign H_2 = left_i[2];
	assign right_o[2] = H_2;
	assign H_1 = left_i[1];
	assign right_o[1] = H_1;
	assign H_0 = left_i[0];
	assign right_o[0] = H_0;

	//     out     in         enable(high)
	bufif1(V_01, up_i, dot_ctrl_V[2]);
	bufif1(V_00, V_01, dot_ctrl_V[1]);
	bufif1(down_o, V_00, dot_ctrl_V[0]);
	bufif1(V_10, down_i, dot_ctrl_V[5]);
	bufif1(V_11, V_10, dot_ctrl_V[4]);
	bufif1(up_o, V_11, dot_ctrl_V[3]);

	bufif1(up_o, left_i[2], dot_ctrl_LU[2]);
	bufif1(V_11, left_i[1], dot_ctrl_LU[1]);
	bufif1(V_10, left_i[0], dot_ctrl_LU[0]);
	bufif1(H_2, V_11, dot_ctrl_DR[2]);
	bufif1(H_1, V_10, dot_ctrl_DR[1]);
	bufif1(H_0, down_i, dot_ctrl_DR[0]);

	bufif1(right_o[2], up_i, dot_ctrl_UR[2]);
	bufif1(right_o[1], V_01, dot_ctrl_UR[1]);
	bufif1(right_o[0], V_00, dot_ctrl_UR[0]);
	bufif1(V_01, H_2, dot_ctrl_LD[2]);
	bufif1(V_00, H_1, dot_ctrl_LD[1]);
	bufif1(down_o, H_0, dot_ctrl_LD[0]);

endmodule


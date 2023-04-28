module Cblock(
	input logic        wr_en,
	input logic [2:0]  left_i,
	output logic        up_o,
	input logic        up_i,
	output logic [2:0]  right_o, // using wire here, otherwise VCS gives error
	input logic        down_i,
	output logic        down_o,
	input logic [17:0] bits, // 6(dots)*3(bits/dot)
	input logic clk
);
	logic [5:0] dot_ctrl_V; //should synthesize to DLH std cell (high enable latch)
	logic [2:0] dot_ctrl_LU; 
	logic [2:0] dot_ctrl_DR; 
	logic [2:0] dot_ctrl_UR; 
	logic [2:0] dot_ctrl_LD; 
	always_ff @(posedge clk) begin
		if (wr_en) begin
			//Vertical, LeftUp, DownRight, UpRight, LeftDown
			dot_ctrl_V <= bits[17:12];
			dot_ctrl_LU <= bits[11:9];
			dot_ctrl_DR <= bits[8:6];
			dot_ctrl_UR <= bits[5:3];
			dot_ctrl_LD <= bits[2:0];
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


    always_comb begin
        up_o = 1'bZ;
        casez ({dot_ctrl_LU[2:0],dot_ctrl_V[5:3]})
            6'b100_???: up_o = left_i[2];
            6'b010_???: up_o = left_i[1];
            6'b001_???: up_o = left_i[0];
            6'b000_111: up_o = down_i;
            default : up_o  = 1'bZ;
        endcase

        down_o = 1'bZ;
        casez ({dot_ctrl_LD[2:0],dot_ctrl_V[2:0]})
            6'b100_???: down_o = left_i[2];
            6'b010_???: down_o = left_i[1];
            6'b001_???: down_o = left_i[0];
            6'b000_111: down_o = up_i;
            default : down_o  = 1'bZ;
        endcase

        right_o[2] = left_i[2];
        case ({dot_ctrl_DR[2],dot_ctrl_UR[2]})
            2'b10: right_o[2] = down_i;
            2'b01: right_o[2] = up_i;
            default : right_o[2]  = left_i[2];
        endcase

        right_o[1] = left_i[1];
        case ({dot_ctrl_DR[1],dot_ctrl_UR[1]})
            2'b10: right_o[1] = down_i;
            2'b01: right_o[1] = up_i;
            default : right_o[1]  = left_i[1];
        endcase

        right_o[0] = left_i[0];
        case ({dot_ctrl_DR[0],dot_ctrl_UR[0]})
            2'b10: right_o[0] = down_i;
            2'b01: right_o[0] = up_i;
            default : right_o[0]  = left_i[0];
        endcase

    end

endmodule
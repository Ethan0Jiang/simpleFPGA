module Tile(
    input logic clk,
    input logic wr_en,
    input logic [76:0] bits,
    input logic cl_V_i,  // to the CLB
    input logic cl_H_i,
    input logic lc_V_i,   // to the bottom left C
    input logic lc_H_i,   // to the top right C
    input logic [2:0] sc_V_i,  // to the CBlock
    input logic [2:0] sc_H_i,
    output logic lc_V_o,   // CLB to up
    output logic lc_H_o,   // CLB to left
    output logic cl_V_o,   // bottom left out
    output logic cl_H_o,   // top right out
    output logic [2:0] sc_V_o,
    output logic [2:0] sc_H_o
    );
    
    logic en = wr_en;
    logic L_Ctr, L_Cbl;  // internal connection from L to C
    logic Ctr_L, Cbl_L;  // internal connection from C to L
    logic [2:0] Ctr_S, Cbl_S;

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
        
    CLB CLB0(
        .clk(clk),
        .wr_en(en),
        .up_i(cl_V_i),
        .down_i(Cbl_L),
        .right_i(Ctr_L),
        .left_i(cl_H_i),
        .bits(bits[76:54]), //  22:19 out_sel,  18 LUTorDFF_mux,  17:16 DFF_en_mux, 15:0 lut  23
        .up_o(lc_V_o),
        .down_o(L_Cbl),
        .right_o(L_Ctr),
        .left_o(lc_H_o)
    );
    
    Cblock BL(  // bottom left
        .clk(clk),
        .wr_en(en),
        .left_i(sc_H_i),      // 3
        .up_o(Cbl_L),
        .up_i(L_Cbl),
        .right_o(Cbl_S), // using wire here, otherwise VCS gives error  3
        .down_i(lc_V_i),
        .down_o(cl_V_o),
        .bits(bits[53:36]) // 6(dots)*3(bits/dot)  18
    );

    Cblock TR(  // top right
        .clk(clk),
        .wr_en(en),
        .left_i(sc_V_i),      // 3
        .up_o(Ctr_L),
        .up_i(L_Ctr),
        .right_o(Ctr_S), // using wire here, otherwise VCS gives error  3
        .down_i(lc_H_i),
        .down_o(cl_H_o),
        .bits(bits[35:18]) // 6(dots)*3(bits/dot)  18
    );
    
    Sblock S0(
        .clk(clk),
        .wr_en(en),
        .left_i(Cbl_S),  // 3
        .up_i(Ctr_S),    // 3
        .right_o(sc_H_o), // using wire here, otherwise VCS gives error 3
        .down_o(sc_V_o), // 3
        .bits(bits[17:0]) // 9(dots)*2(bits/dot) 18
    );
    
    
endmodule

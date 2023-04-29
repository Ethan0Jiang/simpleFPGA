module SimpleFPGA (
    input logic rst,
    input logic clk,
    input logic [76:0] bit_i,
    input logic bit_v_i,
    output logic bit_r_o,
    output logic done_o,
    input logic [3:0] cl_V_in,  // first row input to clb
    input logic [3:0][2:0] sc_V_in,
    output logic [3:0] cl_V_out
    );
    
    // top row i:
    // cl_V_in[0]  sc_V_in[0][2:0]   cl_V_in[1]  sc_V_in[1][2:0]   cl_V_in[2]  sc_V_in[2][2:0]   cl_V_in[3]  sc_V_in[3][2:0]      
    // bottom row o;
    // cl_V_out[0]                   l_V_out[1]                    l_V_out[2]                    l_V_out[3]                      
    logic [3:0][76:0] data_row;
    logic [3:0] col_en_o;
    
    logic [3:0][3:0][2:0] sc_V;     // 3row, 4 column ,go down ////
    logic [3:0][3:0] lc_V;          // 3row, 4 column ,go up
    logic [3:0][3:0] cl_V;          // 3row, 4 column ,go down
    
    logic [3:0][3:0][2:0] sc_H;     // 4row, 3 column ,go right ////
    logic [3:0][3:0] lc_H;          // 4row, 3 column ,go left
    logic [3:0][3:0] cl_H;          // 4row, 3 column ,go right
    
    GlobalFSM fsm (
    .rst_i(rst),
    .clk_i(clk),
    .bit_i,
    .bit_v_i,
    .bit_r_o,
    .done_o,
    .data_row,
    .col_en_o
    );
    
    genvar row,col; //row col
    generate
        for( row = 0; row < 4; row++) begin : eachRow 
            for(col = 0; col < 4; col++) begin: eachCol
                if (row==0 && col==0) begin
                   Tile corner_Tile (
                    .clk,
                    .wr_en(col_en_o[col]),
                    .bits(data_row[row]),
                    .cl_V_i(cl_V_in[col]),  // input top
                    .cl_H_i(),              // no input on left side
                    .lc_V_i(lc_V[row][col]),
                    .lc_H_i(lc_H[row][col]),  
                    .sc_V_i(sc_V_in[col]),  // input top
                    .sc_H_i(),              // left side
                    .lc_V_o(),              // top
                    .lc_H_o(),              // left side
                    .cl_V_o(cl_V[row][col]),  
                    .cl_H_o(lc_H[row][col]), 
                    .sc_V_o(sc_V[row][col]),
                    .sc_H_o(sc_H[row][col])
                    );
                end else if (row==0) begin
                    Tile top_Tile (
                    .clk,
                    .wr_en(col_en_o[col]),
                    .bits(data_row[row]),
                    .cl_V_i(cl_V_in[col]),  // input top
                    .cl_H_i(cl_H[row][col-1]),// left side
                    .lc_V_i(lc_V[row][col]),
                    .lc_H_i(lc_H[row][col]),  
                    .sc_V_i(sc_V_in[col]),  // input top
                    .sc_H_i(sc_H[row][col-1]),// left side
                    .lc_V_o(),              // top
                    .lc_H_o(lc_H[row][col-1]),// left side
                    .cl_V_o(cl_V[row][col]),  
                    .cl_H_o(lc_H[row][col]), 
                    .sc_V_o(sc_V[row][col]),
                    .sc_H_o(sc_H[row][col])
                    );
                end else if (col==0) begin
                    Tile left_Tile (
                    .clk,
                    .wr_en(col_en_o[col]),
                    .bits(data_row[row]),
                    .cl_V_i(cl_V[row-1][col]),
                    .cl_H_i(),              // no input on left side
                    .lc_V_i(lc_V[row][col]),
                    .lc_H_i(lc_H[row][col]),  
                    .sc_V_i(sc_V[row-1][col]),  
                    .sc_H_i(),              // left side
                    .lc_V_o(lc_V[row-1][col]),
                    .lc_H_o(),              // left side
                    .cl_V_o(cl_V[row][col]),  
                    .cl_H_o(lc_H[row][col]), 
                    .sc_V_o(sc_V[row][col]),
                    .sc_H_o(sc_H[row][col])
                    );
                end else begin
                    Tile ATile (
                    .clk,
                    .wr_en(col_en_o[col]),
                    .bits(data_row[row]),
                    .cl_V_i(cl_V[row-1][col]),
                    .cl_H_i(cl_H[row][col-1]),
                    .lc_V_i(lc_V[row][col]),
                    .lc_H_i(lc_H[row][col]),  
                    .sc_V_i(sc_V[row-1][col]), 
                    .sc_H_i(sc_H[row][col-1]),
                    .lc_V_o(lc_V[row-1][col]),  
                    .lc_H_o(lc_H[row][col-1]),  
                    .cl_V_o(cl_V[row][col]),  
                    .cl_H_o(lc_H[row][col]), 
                    .sc_V_o(sc_V[row][col]),
                    .sc_H_o(sc_H[row][col])
                    );
                end                
            end
        end    
    
    endgenerate
    
    assign cl_V_out = cl_V[3];
    
endmodule
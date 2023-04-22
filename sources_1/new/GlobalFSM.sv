`timescale 1ns / 1ps
module GlobalFSM #(parameter Dim = 4) (
    input logic rst_i,
    input logic clk_i,
    input logic [76:0] bit_i,
    input logic bit_v_i,
    output logic bit_r_o,
    output logic done_o,
    output logic [76:0] data_row0,
    output logic [76:0] data_row1,
    output logic [76:0] data_row2,
    output logic [76:0] data_row3,
    output logic col_0_en_o,
    output logic col_1_en_o,
    output logic col_2_en_o,
    output logic col_3_en_o
    );
    
    enum bit [2:0] {S0, S1, S2, S3} ps, ns;
    logic [$clog2(Dim+1)-1:0] col_num;
    logic [$clog2(Dim+1)-1:0] count;
    logic ff_en;
    logic dec_en;
    
    always_comb begin
        ns = S0;
        case (ps)
            S0: if (!rst_i & bit_v_i)   ns = S1;
                else                    ns = S0;
            S1: if (count == 0)         ns = S2;
                else                    ns = S1;
            S2: if (col_num == Dim)     ns = S3;
                else                    ns = S1;
            S3: ns = S3;
        endcase
        
        bit_r_o = 0;
        ff_en = 0;
        dec_en = 0;
        done_o = 0;
        case (ps)
            S0: begin   bit_r_o = !rst_i;
                        ff_en = !rst_i & bit_v_i; end
            S1: begin   bit_r_o = (count!=0);
                        ff_en = (count!=0) & bit_v_i; end
            S2: begin   dec_en = (col_num!=Dim); end
            S3: begin   done_o = 1; end            
        endcase
        
        col_0_en_o=0; col_1_en_o=0; col_2_en_o=0; col_3_en_o=0;
        if (dec_en) begin
            if      (col_num==0) col_0_en_o = 1;
            else if (col_num==1) col_1_en_o = 1;
            else if (col_num==2) col_2_en_o = 1;
            else if (col_num==3) col_3_en_o = 1;
        end
    end
    
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            ps <= S0;
        end else begin
            ps <= ns;
        end
        if (ff_en) begin
            data_row3 <= data_row2;
            data_row2 <= data_row1;
            data_row1 <= data_row0;
            data_row0 <= bit_i;
        end
        if (ps==S0&ff_en) begin
            col_num <= 0;
            count <= Dim-1;
        end
        if (ps==S1&ff_en) count <= count-1;
        if (ps==S2) begin
            count <= Dim;
            col_num <= col_num+1;
        end
    end
    
endmodule

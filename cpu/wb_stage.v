`include "defines.v"

module wb_stage(
    input wire rst,
    input wire wb_signal,//MemtoReg
    input wire [`REG_BUS]m_data,
    input wire m_w_ena,
    input wire [4:0]m_w_addr,
    input wire reg_wr,
    output reg [`REG_BUS]wb_data,
    output reg wb_ena,
    output reg [4:0]wb_addr
);
    always @(*) begin
        if ( rst == 1'b1 )
        begin
        assign wb_data=`ZERO_WORD;
        end
        else
        begin
            case ( reg_wr )
            1'b1:
            begin
            if ( wb_signal == 1'b0 )//R- I- U- J-
            begin
            wb_data=m_data;
            wb_ena=m_w_ena;
            wb_addr=m_w_addr;
            end
            end
            default: 
            begin 
            wb_data=`ZERO_WORD;
            wb_ena=1'b0;
            wb_addr=5'b00000;
            end
            endcase
        end
    end
endmodule
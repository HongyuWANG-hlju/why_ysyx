`include "defines.v"

module wb_stage(
    input wire rst,
    input wire wb_signal,//MemtoReg
    input wire [`REG_BUS]m_data,
    input wire m_ena,
    input wire [4:0]m_addr,
    output wire [`REG_BUS]wb_data,
    output wire wb_ena,
    output wire [4:0]wb_addr
);
    always @(*) begin
        if ( rst == 1'b1 )
        begin
            wb_data=`ZERO_WORD;
        end
        else
        begin
            case ( wb_signal )
            0:
            begin
            wb_data=m_data;
            wb_ena=m_ena;
            wb_addr=m_addr;
            end
            defalut: 
            begin 
            wb_data=`ZERO_WORD;
            wb_ena=0;
            wb_addr=5'b00000;
            end
        end
    end
endmodule
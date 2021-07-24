`include "defines.v"

module m_stage(
    input wire rst,
    input wire [4:0]inst_type,//指令类型
    input wire [`REG_BUS]data,//写数据
    input wire w_ena,
    input wire [4:0]w_addr,
    output reg [`REG_BUS]m_data,
    output wire m_w_ena,
    output wire [4:0]m_w_addr,
    output wire wb_signal
);
    always @(*) 
    begin
        if( rst == 1'b1 )
        begin
            m_data = `ZERO_WORD
        end
        else
        begin
            case ( inst_type )
                10000: 
                begin
                m_data=data;
                m_w_ena=w_ena;
                m_w_addr=w_addr;
                wb_signal=0;
                end
                default: 
                begin
                m_data=data;
                m_w_ena=w_ena;
                m_w_addr=w_addr;
                wb_signal=x;
                end
            endcase
        end
    end
endmodule
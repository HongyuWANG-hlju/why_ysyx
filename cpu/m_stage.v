`include "defines.v"

module m_stage(
    input wire rst,
    input wire [4:0]inst_type,//指令类型
    input wire [`REG_BUS]data,//写数据
    input wire w_ena,
    input wire [4:0]w_addr,
    output reg [`REG_BUS]m_data,
    output reg m_w_ena,
    output reg [4:0]m_w_addr,
    output reg wb_signal,//MemtoReg
    output reg reg_wr
);
    always @(*) 
    begin
        if( rst == 1'b1 )
        begin
            m_data = `ZERO_WORD;
        end
        else
        begin
            case ( inst_type )
                5'b10000: 
                begin
                m_data=data;
                m_w_ena=w_ena;
                m_w_addr=w_addr;
                wb_signal=1'b0;
                reg_wr=1'b1;
                end
                default: 
                begin
                m_data=data;
                m_w_ena=w_ena;
                m_w_addr=w_addr;
                end
            endcase
        end
    end
endmodule
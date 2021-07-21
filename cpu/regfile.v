
`include "defines.v"

module regfile(
    input  wire clk,
	input  wire rst,
	
	input  wire  [4  : 0] w_addr,//写入地址
	input  wire  [`REG_BUS] w_data,//写入数据
	input  wire 		  w_ena,//写使能信号
	
	input  wire  [4  : 0] r_addr1,//读地址1
	output reg   [`REG_BUS] r_data1,//读数据1
	input  wire 		  r_ena1,//读使能信号1
	
	input  wire  [4  : 0] r_addr2,//读地址2
	output reg   [`REG_BUS] r_data2,//读数据2
	input  wire 		  r_ena2//读使能信号2
    );

    // 32 registers(64bit)
	reg [`REG_BUS] 	regs[0 : 31];
	
	always @(posedge clk) 
	begin
		if ( rst == 1'b1 ) 
		begin
			regs[ 0] <= `ZERO_WORD;
			regs[ 1] <= `ZERO_WORD;
			regs[ 2] <= `ZERO_WORD;
			regs[ 3] <= `ZERO_WORD;
			regs[ 4] <= `ZERO_WORD;
			regs[ 5] <= `ZERO_WORD;
			regs[ 6] <= `ZERO_WORD;
			regs[ 7] <= `ZERO_WORD;
			regs[ 8] <= `ZERO_WORD;
			regs[ 9] <= `ZERO_WORD;
			regs[10] <= `ZERO_WORD;
			regs[11] <= `ZERO_WORD;
			regs[12] <= `ZERO_WORD;
			regs[13] <= `ZERO_WORD;
			regs[14] <= `ZERO_WORD;
			regs[15] <= `ZERO_WORD;
			regs[16] <= `ZERO_WORD;
			regs[17] <= `ZERO_WORD;
			regs[18] <= `ZERO_WORD;
			regs[19] <= `ZERO_WORD;
			regs[20] <= `ZERO_WORD;
			regs[21] <= `ZERO_WORD;
			regs[22] <= `ZERO_WORD;
			regs[23] <= `ZERO_WORD;
			regs[24] <= `ZERO_WORD;
			regs[25] <= `ZERO_WORD;
			regs[26] <= `ZERO_WORD;
			regs[27] <= `ZERO_WORD;
			regs[28] <= `ZERO_WORD;
			regs[29] <= `ZERO_WORD;
			regs[30] <= `ZERO_WORD;
			regs[31] <= `ZERO_WORD;
		end
		else //若复位信号为0
		begin
			if ((w_ena == 1'b1) && (w_addr != 5'h00))	//若使能信号为1且地址不为0：为什么不能为0？明明有寄存器为0
				regs[w_addr] <= w_data;//对地址写入数据
		end
	end
	
	always @(*) begin
		if (rst == 1'b1)
			r_data1 = `ZERO_WORD;
		else if (r_ena1 == 1'b1)
			r_data1 = regs[r_addr1];
		else
			r_data1 = `ZERO_WORD;//若复位信号为0，但使能信号也为0，写数据归零
	end
	
	always @(*) begin
		if (rst == 1'b1)
			r_data2 = `ZERO_WORD;
		else if (r_ena2 == 1'b1)
			r_data2 = regs[r_addr2];
		else
			r_data2 = `ZERO_WORD;
	end

endmodule

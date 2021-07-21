
/* verilator lint_off UNDRIVEN */
/* verilator lint_off UNUSED */
//--xuezhen--

`include "defines.v"

module id_stage(
  input wire rst,
  input wire [31 : 0]inst,
  input wire [`REG_BUS]rs1_data,//等于regfile里的r_data1
  input wire [`REG_BUS]rs2_data,//等于regfile里的r_data2
  
  
  output wire rs1_r_ena,//r_ena1
  output wire [4 : 0]rs1_r_addr,//等于regfile里的r_addr1
  output wire rs2_r_ena,//r_ena2
  output wire [4 : 0]rs2_r_addr,//等于regfile里的r_addr2
  output wire rd_w_ena,//w_ena
  output wire [4 : 0]rd_w_addr,//w_addr
  
  output wire [4 : 0]inst_type,
  output wire [7 : 0]inst_opcode,
  output wire [`REG_BUS]op1,
  output wire [`REG_BUS]op2
);


// I-type 解析指令
wire [6  : 0]opcode;
wire [4  : 0]rd;
wire [2  : 0]func3;
wire [4  : 0]rs1;
wire [11 : 0]imm;
assign opcode = inst[6  :  0];
assign rd     = inst[11 :  7];
assign func3  = inst[14 : 12];
assign rs1    = inst[19 : 15];
assign imm    = inst[31 : 20];

//识别指令
wire inst_addi =   ~opcode[2] & ~opcode[3] & opcode[4] & ~opcode[5] & ~opcode[6]//RISCV中所有指令的opcode低两位均为11
                 & ~func3[0] & ~func3[1] & ~func3[2];//ADDI指令为func3:000,opcode：00100(11)

// arith inst: 10000; logic: 01000;示例代码中加法操作码为11
// load-store: 00100; j: 00010;  sys: 000001;
assign inst_type[4] = ( rst == 1'b1 ) ? 0 : inst_addi;

//确定类型/操作码
assign inst_opcode[0] = (  rst == 1'b1 ) ? 0 : inst_addi;
assign inst_opcode[1] = (  rst == 1'b1 ) ? 0 : 0;
assign inst_opcode[2] = (  rst == 1'b1 ) ? 0 : 0;
assign inst_opcode[3] = (  rst == 1'b1 ) ? 0 : 0;
assign inst_opcode[4] = (  rst == 1'b1 ) ? 0 : inst_addi;
assign inst_opcode[5] = (  rst == 1'b1 ) ? 0 : 0;
assign inst_opcode[6] = (  rst == 1'b1 ) ? 0 : 0;
assign inst_opcode[7] = (  rst == 1'b1 ) ? 0 : 0;


//产生寄存器读/写信号
//I型指令，读口1可读，读口2不可读，写口使能为1
assign rs1_r_ena  = ( rst == 1'b1 ) ? 0 : inst_type[4];
assign rs1_r_addr = ( rst == 1'b1 ) ? 0 : ( inst_type[4] == 1'b1 ? rs1 : 0 );
assign rs2_r_ena  = 0;
assign rs2_r_addr = 0;

assign rd_w_ena   = ( rst == 1'b1 ) ? 0 : inst_type[4];
assign rd_w_addr  = ( rst == 1'b1 ) ? 0 : ( inst_type[4] == 1'b1 ? rd  : 0 );

//获取操作数
assign op1 = ( rst == 1'b1 ) ? 0 : ( inst_type[4] == 1'b1 ? rs1_data : 0 );
assign op2 = ( rst == 1'b1 ) ? 0 : ( inst_type[4] == 1'b1 ? { {52{imm[11]}}, imm } : 0 );//52*imm的11位和imm原数拼接


endmodule

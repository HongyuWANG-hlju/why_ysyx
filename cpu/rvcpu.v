
/* verilator lint_off UNUSED */
/* verilator lint_off UNOPTFLAT */
//--xuezhen--

`timescale 1ns / 1ps

`include "defines.v"


module rvcpu(
  input wire            clk,
  input wire            rst,
  input wire  [31 : 0]  inst,
  
  output wire [63 : 0]  inst_addr, 
  output wire           inst_ena
);


// id_stage
// id_stage -> regfile
wire rs1_r_ena;
wire [4 : 0]rs1_r_addr;
wire rs2_r_ena;
wire [4 : 0]rs2_r_addr;
wire rd_w_ena;
wire [4 : 0]rd_w_addr;
// id_stage -> exe_stage
wire [4 : 0]inst_type;
wire [7 : 0]inst_opcode;
wire [`REG_BUS]op1;
wire [`REG_BUS]op2;

// regfile -> id_stage
wire [`REG_BUS] r_data1;
wire [`REG_BUS] r_data2;

// exe_stage
// exe_stage -> other stage
wire [4 : 0]inst_type_o;
// exe_stage -> regfile
wire [`REG_BUS]rd_data;

// m_stage -> wb_stage
wire [`REG_BUS]m_data;
wire m_w_ena;
wire [4:0]m_w_addr;
wire wb_signal;
wire reg_wr;

if_stage If_stage(
  .clk(clk),
  .rst(rst),
  
  .inst_addr(inst_addr),
  .inst_ena(inst_ena)
);

id_stage Id_stage(
  .rst(rst),
  .inst(inst),
  .rs1_data(r_data1),
  .rs2_data(r_data2),
  
  .rs1_r_ena(rs1_r_ena),
  .rs1_r_addr(rs1_r_addr),
  .rs2_r_ena(rs2_r_ena),
  .rs2_r_addr(rs2_r_addr),
  .rd_w_ena(rd_w_ena),
  .rd_w_addr(rd_w_addr),
  .inst_type(inst_type),
  .inst_opcode(inst_opcode),
  .op1(op1),
  .op2(op2)
);

exe_stage Exe_stage(
  .rst(rst),
  .inst_type_i(inst_type),
  .inst_opcode(inst_opcode),
  .op1(op1),
  .op2(op2),
  
  .inst_type_o(inst_type_o),
  .rd_data(rd_data)
);

regfile Regfile(
  .clk(clk),
  .rst(rst),
  .w_addr(rd_w_addr),
  .w_data(rd_data),
  .w_ena(rd_w_ena),
  
  .r_addr1(rs1_r_addr),
  .r_data1(r_data1),
  .r_ena1(rs1_r_ena),
  .r_addr2(rs2_r_addr),
  .r_data2(r_data2),
  .r_ena2(rs2_r_ena)
);

m_stage M_stage(
  .rst(rst),
  .inst_type(inst_type_o),
  .data(rd_data),
  .w_addr(rd_w_addr),
  .m_data(m_data),
  .m_w_addr(m_w_addr),
  .wb_signal(wb_signal),
  .reg_wr(reg_wr)
);

wb_stage Wb_stage(
  .rst(rst),
  .wb_signal(wb_signal),
  .m_data(m_data),
  .m_w_addr(m_w_addr),
  .wb_data(rd_data),
  .wb_addr(rd_w_addr),
  .reg_wr(reg_wr)
);

endmodule

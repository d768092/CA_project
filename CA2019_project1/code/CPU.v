`include "PC.v"
`include "MUX1_2.v"
`include "MUX32_2.v"
`include "Adder.v"
`include "Instruction_Memory.v"
`include "IF_ID.v"
`include "Control.v"
`include "ALU_Control.v"
`include "Registers.v"
`include "Sign_Extend.v"
`include "Shift_left.v"
`include "Equal.v"
`include "ID_EX.v"
`include "ALU.v"
`include "EX_MEM.v"
`include "Data_Memory.v"
`include "MEM_WB.v"
`include "Forwarding.v"
`include "MUX32_3.v"

module CPU
(
    clk_i, 
    start_i,
    rst_i
);

// Ports
input         clk_i;
input         start_i;
input         rst_i;


PC PC(
    .clk_i          (clk_i),
    .start_i        (start_i),
    .rst_i          (rst_i),
    .PCWrite_i      (1'b1),
    .pc_i           (MUX_PC.data_o),
    .pc_o           ()
);

MUX32_2 MUX_PC(
    .data1_i    (Add_PC.data_o),
    .data2_i    (Add_branch.data_o),
    .select_i   (1'b0),
    .data_o     ()
);

Adder Add_PC(
    .data1_in   (PC.pc_o),
    .data2_in   (4),
    .data_o     ()
);

Instruction_Memory Instruction_Memory(
    .addr_i         (PC.pc_o),
    .instr_o        ()
);

IF_ID IF_ID(
    .clk_i          (clk_i),
    .addr_i         (PC.pc_o),
    .instr_i        (Instruction_Memory.instr_o),
    .addr_o         (),
    .instr_o        ()
);

Control Control(
    .Op_i           (IF_ID.instr_o[6:0]),
    .Branch_o       (),
    .MemtoReg_o     (),
    .ALUOp_o        (),
    .MemWrite_o     (),
    .ALUSrc_o       (),
    .RegWrite_o     ()
);

ALU_Control ALU_Control(
    .funct_i    ({IF_ID.instr_o[31:25],IF_ID.instr_o[14:12]}),
    .ALUOp_i    (Control.ALUOp_o),
    .ALUCtrl_o  ()
);

Registers Registers(
    .clk_i          (clk_i),
    .RS1addr_i      (IF_ID.instr_o[19:15]),
    .RS2addr_i      (IF_ID.instr_o[24:20]),
    .RDaddr_i       (MEM_WB.RD_o),
    .RDdata_i       (MUX_WBSrc.data_o),
    .RegWrite_i     (MEM_WB.RegWrite_o),
    .RS1data_o      (),
    .RS2data_o      ()
);

Sign_Extend Sign_Extend(
    .data_i     (IF_ID.instr_o),
    .data_o     ()
);

Shift_left Shift_left(
    .data_i     (Sign_Extend.data_o),
    .data_o     ()
);

Adder Add_branch(
    .data1_in   (IF_ID.addr_o),
    .data2_in   (Shift_left.data_o),
    .data_o     ()
);

Equal Equal(
    .data1_i    (Registers.RS1data_o),
    .data2_i    (Registers.RS2data_o),
    .equal_o    ()
);

ID_EX ID_EX(
    .clk_i      (clk_i),
    .RS1data_i  (Registers.RS1data_o),
    .RS2data_i  (Registers.RS2data_o),
    .imm_i      (Sign_Extend.data_o),
    .RS1_i      (IF_ID.instr_o[19:15]),
    .RS2_i      (IF_ID.instr_o[24:20]),
    .RD_i       (IF_ID.instr_o[11:7]),
    .MemtoReg_i (Control.MemtoReg_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .MemWrite_i (Control.MemWrite_o),
    .ALUSrc_i   (Control.ALUSrc_o),
    .RegWrite_i (Control.RegWrite_o),
    .RS1data_o  (),
    .RS2data_o  (),
    .imm_o      (),
    .RS1_o      (),
    .RS2_o      (),
    .RD_o       (),
    .MemtoReg_o (),
    .ALUCtrl_o  (),
    .MemWrite_o (),
    .ALUSrc_o   (),
    .RegWrite_o ()
);

Forwarding Forwarding(
    .ID_EX_RS1          (ID_EX.RS1_o),   
    .ID_EX_RS2          (ID_EX.RS2_o), 
    .EX_MEM_RD          (EX_MEM.RD_o),
    .MEM_WB_RD          (MEM_WB.RD_o),
    .EX_MEM_RegWrite    (EX_MEM_RegWrite),  
    .MEM_WB_RegWrite    (MEM_WB_RegWrite),
    .Forward_A          (),
    .Forward_B          ()
);

MUX32_2 MUX_ALUSrc(
    .data1_i    (ID_EX.RS2data_o),
    .data2_i    (ID_EX.imm_o),
    .select_i   (ID_EX.ALUSrc_o),
    .data_o     ()
);

MUX32_3 MUX_ALUFor_A(
    .data1_i    (ID_EX.RS1data_o),
    .data2_i    (MUX_WBSrc.data_o),
    .data3_i    (EX_MEM.ALU_o),
    .select_i   (Forwarding.Forward_A),
    .data_o     ()
);

MUX32_3 MUX_ALUFor_B(
    .data1_i    (MUX_ALUSrc.data_o),
    .data2_i    (MUX_WBSrc.data_o),
    .data3_i    (EX_MEM.ALU_o),
    .select_i   (Forwarding.Forward_B),
    .data_o     ()
);


ALU ALU(
    .data1_i    (ID_EX.RS1data_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ID_EX.ALUCtrl_o),
    .data_o     ()
);

EX_MEM EX_MEM(
    .clk_i      (clk_i),
    .ALU_i      (ALU.data_o),
    .data_i     (ID_EX.RS2data_o),
    .RD_i       (ID_EX.RD_o),
    .MemtoReg_i (ID_EX.MemtoReg_o),
    .MemWrite_i (ID_EX.MemWrite_o),
    .RegWrite_i (ID_EX.RegWrite_o),
    .ALU_o      (),
    .data_o     (),
    .RD_o       (),
    .MemtoReg_o (),
    .MemWrite_o (),
    .RegWrite_o ()
);

Data_Memory Data_Memory(
    .clk_i          (clk_i),
    .addr_i         (EX_MEM.ALU_o),
    .MemWrite_i     (EX_MEM.MemWrite_o),
    .data_i         (EX_MEM.data_o),
    .data_o         ()
);

MEM_WB MEM_WB(
    .clk_i          (clk_i),
    .data_i         (Data_Memory.data_o),
    .ALU_i          (EX_MEM.ALU_o),
    .RD_i           (EX_MEM.RD_o),
    .MemtoReg_i     (EX_MEM.MemtoReg_o),
    .RegWrite_i     (EX_MEM.RegWrite_o),
    .data_o         (),
    .ALU_o          (),
    .RD_o           (),
    .MemtoReg_o     (),
    .RegWrite_o     ()
);

MUX32_2 MUX_WBSrc(
    .data1_i    (MEM_WB.ALU_o),
    .data2_i    (MEM_WB.data_o),
    .select_i   (MEM_WB.MemtoReg_o),
    .data_o     ()
);

endmodule


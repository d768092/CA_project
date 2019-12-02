module CPU
(
    clk_i, 
    start_i
);

// Ports
input         clk_i;
input         start_i;

// IF
wire    [31:0]    IF_pc;
wire    [31:0]    nextpc;
wire    [31:0]    pc_4;
wire    [31:0]    pc_branch;
wire    [31:0]    IF_instr;

// ID
wire    [31:0]    ID_pc;
wire    [31:0]    ID_instr;
wire    [31:0]    ID_RS1data;
wire    [31:0]    ID_RS2data;
wire    [31:0]    ID_imm;
wire              ID_Branch;
wire              ID_MemtoReg;
wire    [1:0]     ID_ALUOp;
wire              ID_MemWrite;
wire              ID_ALUSrc;
wire              ID_RegWrite;
wire    [2:0]     ID_ALUCtrl;

// EX
wire    [31:0]    EX_RS1data;
wire    [31:0]    EX_RS2data;
wire    [31:0]    EX_imm;
wire    [4:0]     EX_RS1;
wire    [4:0]     EX_RS2;
wire    [4:0]     EX_RD;
wire    [31:0]    select_data;
wire    [31:0]    EX_ALUresult;
wire              EX_MemtoReg;
wire    [2:0]     EX_ALUCtrl;
wire              EX_MemWrite;
wire              EX_ALUSrc;
wire              EX_RegWrite;

// MEM
wire    [31:0]    MEM_ALUresult;
wire    [4:0]     MEM_RD;
wire    [31:0]    MEM_writedata;
wire    [31:0]    MEM_readdata;
wire              MEM_MemtoReg;
wire              MEM_MemWrite;
wire              MEM_RegWrite;

//WB
wire    [31:0]    WB_readdata;
wire    [31:0]    WB_ALUresult;
wire    [4:0]     WB_RD;
wire    [31:0]    WB_data;
wire              WB_MemtoReg;
wire              WB_RegWrite;

PC PC(
    .clk_i          (clk_i),
    .start_i        (start_i),
    .PCWrite_i      (),
    .pc_i           (nextpc),
    .pc_o           (IF_pc)
);

MUX2 MUX_PC(
    .data1_i    (pc_4),
    .data2_i    (pc_branch),
    .select_i   (),
    .data_o     (nextpc)
);

Adder Add_PC(
    .data1_in   (IF_pc),
    .data2_in   (4),
    .data_o     (pc_4)
);

Instruction_Memory Instruction_Memory(
    .addr_i         (IF_pc),
    .instr_o        (IF_instr)
);

IF_ID IF_ID(
    .addr_i         (IF_pc),
    .instr_i        (IF_instr),
    .addr_o         (ID_pc),
    .instr_o        (ID_instr)
);

Control Control(
    .Op_i           (ID_instr[6:0]),
    .Branch_o       (ID_Branch),
    .MemtoReg_o     (ID_MemtoReg),
    .ALUOp_o        (ID_ALUOp),
    .MemWrite_o     (ID_MemWrite),
    .ALUSrc_o       (ID_ALUSrc),
    .RegWrite_o     (ID_RegWrite)
);

ALU_Control ALU_Control(
    .funct_i    ({ID_instr[31:25],ID_instr[14:12]}),
    .ALUOp_i    (ID_ALUOp),
    .ALUCtrl_o  (ID_ALUCtrl)
);

Registers Registers(
    .clk_i          (clk_i),
    .RS1addr_i      (ID_instr[19:15]),
    .RS2addr_i      (ID_instr[24:20]),
    .RDaddr_i       (WB_RD),
    .RDdata_i       (WB_data),
    .RegWrite_i     (WB_RegWrite),
    .RS1data_o      (ID_RS1data),
    .RS2data_o      (ID_RS2data)
);

Sign_Extend Sign_Extend(
    .data_i     (ID_instr),
    .data_o     (ID_imm)
);

Shift_left Shift_left(
    .data_i     (ID_imm),
    .data_o     (double_imm)
);

Adder Add_branch(
    .data1_in   (ID_pc),
    .data2_in   (double_imm),
    .data_o     (pc_branch)
);

Equal Equal(
    .data1_i    (ID_RS1data),
    .data2_i    (ID_RS2data),
    .equal_o    ()
);

ID_EX ID_EX(
    .RS1data_i  (ID_RS1data),
    .RS2data_i  (ID_RS2data),
    .imm_i      (ID_imm),
    .RS1_i      (ID_instr[19:15]),
    .RS2_i      (ID_instr[24:20])
    .RD_i       (ID_instr[11:7]),
    .MemtoReg_i (ID_MemtoReg),
    .ALUCtrl_i  (ID_ALUCtrl),
    .MemWrite_i (ID_MemWrite),
    .ALUSrc_i   (ID_ALUSrc),
    .RegWrite_i (ID_RegWrite)
    .RS1data_o  (EX_RS1data),
    .RS2data_o  (EX_RS2data),
    .imm_o      (EX_imm),
    .RS1_o      (EX_RS1),
    .RS2_o      (EX_RS2),
    .RD_o       (EX_RD),
    .MemtoReg_o (EX_MemtoReg),
    .ALUCtrl_o  (EX_ALUCtrl),
    .MemWrite_o (EX_MemWrite),
    .ALUSrc_o   (EX_ALUSrc),
    .RegWrite_o (EX_RegWrite)
);

MUX2 MUX_ALUSrc(
    .data1_i    (EX_RS2data),
    .data2_i    (EX_imm),
    .select_i   (EX_ALUSrc),
    .data_o     (select_data)
);

ALU ALU(
    .data1_i    (EX_RS1data),
    .data2_i    (select_data),
    .ALUCtrl_i  (EX_ALUCtrl),
    .data_o     (EX_ALUresult),
);

EX_MEM EX_MEM(
    .ALU_i      (EX_ALUresult),
    .data_i     (EX_RS2data),
    .RD_i       (EX_RD),
    .MemtoReg_i (EX_MemtoReg),
    .MemWrite_i (EX_MemWrite),
    .RegWrite_i (EX_RegWrite),
    .ALU_o      (MEM_ALUresult),
    .data_o     (MEM_writedata),
    .RD_o       (MEM_RD)
    .MemtoReg_o (MEM_MemtoReg),
    .MemWrite_o (MEM_MemWrite),
    .RegWrite_o (MEM_RegWrite)
);

Data_Memory Data_Memory(
    .clk_i          (clk_i),
    .addr_i         (MEM_ALUresult),
    .MemWrite_i     (MEM_MemWrite),
    .data_i         (MEM_writedata),
    .data_o         (MEM_readdata)
);

MEM_WB MEM_WB(
    .data_i         (MEM_readdata),
    .ALU_i          (MEM_ALUresult),
    .RD_i           (MEM_RD),
    .MemtoReg_i     (MEM_MemtoReg),
    .RegWrite_i     (MEM_RegWrite),
    .data_o         (WB_readdata),
    .ALU_o          (WB_ALUresult),
    .RD_o           (WB_RD)
    .MemtoReg_o     (WB_MemtoReg),
    .RegWrite_o     (WB_RegWrite),
);

MUX2 MUX_WBSrc(
    .data1_i    (WB_ALUresult),
    .data2_i    (WB_readdata),
    .select_i   (WB_MemtoReg),
    .data_o     (WB_data)
);

endmodule


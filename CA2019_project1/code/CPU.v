module CPU
(
    clk_i, 
    start_i
);

// Ports
input         clk_i;
input         start_i;

// IF
wire    [31:0]    thispc;
wire    [31:0]    nextpc;
wire    [31:0]    pc_4;
wire    [31:0]    pc_branch;
wire    [31:0]    Zero;
wire    [31:0]    instr;

// ID
wire    [31:0]    thispc2;
wire    [31:0]    instr2;
wire    [31:0]    RS1_data;
wire    [31:0]    RS2_data;
wire    [31:0]    imm;

// EX
wire    [31:0]    thispc3;
wire    [31:0]    RS1_data2;
wire    [31:0]    RS2_data2;
wire    [31:0]    imm2;
wire    [31:0]    select_data;
wire    [31:0]    ALU_result;
wire              Zero2;
wire    [31:0]    double_imm;
wire    [31:0]    pc_branch2;

// MEM
wire    [31:0]    ALU_result2;
wire    [31:0]    write_data;
wire    [31:0]    read_data;

//WB
wire    [31:0]    read_data2;
wire    [31:0]    ALU_result3;
wire    [31:0]    output_data;

PC PC(
    .clk_i          (clk_i),
    .start_i        (start_i),
    .PCWrite_i      (),
    .pc_i           (nextpc),
    .pc_o           (thispc)
);

MUX32 MUX_PC(
    .data1_i    (pc_4),
    .data2_i    (pc_branch),
    .select_i   (),
    .data_o     (nextpc)
);

Adder Add_PC(
    .data1_in   (thispc),
    .data2_in   (4),
    .data_o     (pc_4)
);

Instruction_Memory Instruction_Memory(
    .addr_i         (thispc),
    .instr_o        (instr)
);

IF_ID IF_ID(
    .addr_i         (thispc),
    .instr_i        (instr),
    .addr_o         (instr2)
);

Registers Registers(
    .clk_i          (clk_i),
    .RS1addr_i      (instr2[19:15]),
    .RS2addr_i      (instr2[24:20]),
    .RDaddr_i       (instr2[11:7]),
    .RDdata_i       (output_data),
    .RegWrite_i     (),
    .RS1data_o      (RS1_data),
    .RS2data_o      (RS2_data)
);

Sign_Extend Sign_Extend(
    .data_i     (instr2),
    .data_o     (imm)
);

ID_EX ID_EX(
    .pc_i       (thispc2),
    .RS1data_i  (RS1_data),
    .RS2data_i  (RS2_data),
    .imm_i      (imm),
    .pc_o       (thispc3),
    .RS1data_o  (RS1_data2),
    .RS2data_o  (RS2_data2),
    .imm_o      (imm2)
);

MUX32 MUX_ALUSrc(
    .data1_i    (RS2_data2),
    .data2_i    (imm2),
    .select_i   (),
    .data_o     (select_data)
);

ALU ALU(
    .data1_i    (RS1_data2),
    .data2_i    (select_data),
    .ALUCtrl_i  (),
    .data_o     (ALU_result),
    .Zero_o     (Zero2)
);

Shift_left Shift_left(
    .data_i     (imm2),
    .data_o     (double_imm)
);

Adder Add_branch(
    .data1_in   (thispc3),
    .data2_in   (double_imm),
    .data_o     (pc_branch2)
);

EX_MEM EX_MEM(
    .addr_i     (pc_branch2),
    .Zero_i     (Zero2),
    .ALU_i      (ALU_result),
    .data_i     (RS2_data2),
    .addr_o     (pc_branch),
    .Zero_o     (Zero),
    .ALU_o      (ALU_result2),
    .data_o     (write_data)
);

Data_Memory Data_Memory(
    .clk_i          (clk_i),

    .addr_i         (ALU_result2),
    .MemWrite_i     (),
    .data_i         (write_data),
    .data_o         (read_data)
);

MEM_WB MEM_WB(
    .data_i         (read_data),
    .ALU_i          (ALU_result2),
    .data_o         (read_data2),
    .ALU_o          (ALU_result3)
);

MUX32 MUX_WBSrc(
    .data1_i    (ALU_result3),
    .data2_i    (read_data2),
    .select_i   (),
    .data_o     (output_data)
);

endmodule


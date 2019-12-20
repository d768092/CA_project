module ID_EX
(
    input            clk_i,
    input   [31:0]   RS1data_i,
    input   [31:0]   RS2data_i,
    input   [31:0]   imm_i,
    input   [4:0]    RS1_i,
    input   [4:0]    RS2_i,
    input   [4:0]    RD_i,
    input            MemtoReg_i,
    input   [2:0]    ALUCtrl_i,
    input            MemWrite_i,
    input            MemRead_i,
    input            ALUSrc_i,
    input            RegWrite_i,
    input            MemStall_i,
    input   [31:0]   Stall_RS1data_i,
    input   [31:0]   Stall_RS2data_i,
    input   [31:0]   Stall_imm_i,
    input   [4:0]    Stall_RS1_i,
    input   [4:0]    Stall_RS2_i,
    input   [4:0]    Stall_RD_i,
    input            Stall_MemtoReg_i,
    input   [2:0]    Stall_ALUCtrl_i,
    input            Stall_MemWrite_i,
    input            Stall_MemRead_i,
    input            Stall_ALUSrc_i,
    input            Stall_RegWrite_i,
    output  [31:0]   RS1data_o,
    output  [31:0]   RS2data_o,
    output  [31:0]   imm_o,
    output  [4:0]    RS1_o,
    output  [4:0]    RS2_o,
    output  [4:0]    RD_o,
    output           MemtoReg_o,
    output  [2:0]    ALUCtrl_o,
    output           MemWrite_o,
    output           MemRead_o,
    output           ALUSrc_o,
    output           RegWrite_o
);

reg     [31:0]     RS1data_o, RS2data_o, imm_o;
reg     [4:0]      RS1_o, RS2_o, RD_o;
reg     [2:0]      ALUCtrl_o;
reg                MemtoReg_o, MemWrite_o, MemRead_o, ALUSrc_o, RegWrite_o;

always @ (posedge clk_i) begin
    if(MemStall_i) begin
        RS1data_o <= Stall_RS1data_i;
        RS2data_o <= Stall_RS2data_i;
        imm_o <= Stall_imm_i;
        RS1_o <= Stall_RS1_i;
        RS2_o <= Stall_RS2_i;
        RD_o <= Stall_RD_i;
        MemtoReg_o <= Stall_MemtoReg_i;
        ALUCtrl_o <= Stall_ALUCtrl_i;
        MemWrite_o <= Stall_MemWrite_i;
        MemRead_o <= Stall_MemRead_i;
        ALUSrc_o <= Stall_ALUSrc_i;
        RegWrite_o <= Stall_RegWrite_i;
    end
    else begin
        RS1data_o <= RS1data_i;
        RS2data_o <= RS2data_i;
        imm_o <= imm_i;
        RS1_o <= RS1_i;
        RS2_o <= RS2_i;
        RD_o <= RD_i;
        MemtoReg_o <= MemtoReg_i;
        ALUCtrl_o <= ALUCtrl_i;
        MemWrite_o <= MemWrite_i;
        MemRead_o <= MemRead_i;
        ALUSrc_o <= ALUSrc_i;
        RegWrite_o <= RegWrite_i;
    end
end

endmodule
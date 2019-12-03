module MEM_WB
(
    input            clk_i,
    input   [31:0]   ALU_i,
    input   [31:0]   data_i,
    input   [4:0]    RD_i,
    input            MemtoReg_i,
    input            RegWrite_i,
    output  [31:0]   ALU_o,
    output  [31:0]   data_o,
    output  [4:0]    RD_o,
    output           MemtoReg_o,
    output           RegWrite_o
);

reg     [31:0]     ALU_o, data_o;
reg     [4:0]      RD_o;
reg                MemtoReg_o, RegWrite_o;

always @ (posedge clk_i) begin
    ALU_o <= ALU_i;
    data_o <= data_i;
    RD_o <= RD_i;
    MemtoReg_o <= MemtoReg_i;
    RegWrite_o <= RegWrite_i;
end

endmodule
module HazardDetection(
    //stall
    input         MemtoReg_i,    //1 iff lw 
    input  [4:0]  RD_i,
    input  [31:0] instr_i,
    output        Stall_o,
    output [31:0] instr_o,
    //flush
    input         Branch_i,
    output        Flush_o
);

reg         Stall_o;
reg         Flush_o;

assign instr_o = instr_i;

always @* begin
    Stall_o = 0;
    if (MemtoReg_i&&RD_i!=0) begin
        if (instr_i[19:15]==RD_i)
            Stall_o = 1;
        else if (instr_i[5]==1'b1&&instr_i[24:20]==RD_i)
            Stall_o = 1;
    end
    Flush_o = Branch_i;
end

endmodule
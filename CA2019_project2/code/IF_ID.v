module IF_ID
(
    input           clk_i,
    input   [31:0]  addr_i,
    input   [31:0]  instr_i,
    input           Flush_i,
    input           Stall_i,
    input           MemStall_i,
    input   [31:0]  instr_pre,
    input   [31:0]  addr_pre,
    output  [31:0]  addr_o,
    output  [31:0]  instr_o
);

reg     [31:0]     addr_o;
reg     [31:0]     instr_o; 


always @ (posedge clk_i) begin
    addr_o = (Flush_i) ? 0 :
             (Stall_i|MemStall_i) ? addr_pre : addr_i;
    instr_o = (Flush_i) ? 0 :
             (Stall_i|MemStall_i) ? instr_pre : instr_i;
end

endmodule
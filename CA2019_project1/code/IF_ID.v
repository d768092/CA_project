module IF_ID
(
    input           clk_i,
    input   [31:0]  addr_i,
    input   [31:0]  instr_i,
    output   [31:0]  addr_o,
    output   [31:0]  instr_o
);

reg     [31:0]     addr_o;
reg     [31:0]     instr_o; 


always @ (posedge clk_i) begin
    addr_o = addr_i;
    instr_o = instr_i;
end

endmodule
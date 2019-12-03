module IF_ID
(
    input           clk_i,
    input   [31:0]  addr_i,
    input   [31:0]  instr_i,
    output   [31:0]  addr_o,
    output   [31:0]  instr_o
);

//reg     [31:0]     addr_o;
//reg     [31:0]     instr_o; 
reg     [31:0]    addr;
reg     [31:0]    instr;

assign addr_o = addr;
assign instr_o = instr;

always @ (posedge clk_i) begin
    addr <= addr_i;
    instr <= instr_i;
end

endmodule
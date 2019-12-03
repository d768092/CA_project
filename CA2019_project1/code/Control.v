module Control
(
    Op_i,
    Branch_o,
    MemtoReg_o,
    ALUOp_o,
    MemWrite_o,
    ALUSrc_o,
    RegWrite_o
);

// Ports
input   [6:0]       Op_i;
output              Branch_o;
output              MemtoReg_o;
output  [1:0]       ALUOp_o;
output              MemWrite_o;
output              ALUSrc_o; 
output              RegWrite_o;

// Read Data
assign  Branch_o = Op_i[6];   
assign  MemtoReg_o = ~Op_i[4];   
assign  ALUOp_o[1] = (Op_i[5:4] == 2'b11)? 1 : 0;
assign  ALUOp_o[0] = Op_i[6];
assign  MemWrite_o = (Op_i[6:4] == 3'b010) ? 1 : 0; 
assign  ALUSrc_o = (Op_i[5:4] == 2'b11) ? 0 : 1;
assign  RegWrite_o = (Op_i[5:4] == 2'b10) ? 0 : 1;
   
endmodule 

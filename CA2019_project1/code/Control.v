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
assign  ALUOp_o = Op_i[5:4];
assign  ALUSrc_o = ~(Op_i[5]&Op_i[4]);
   
endmodule 

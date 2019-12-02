module ALU_Control
(
    funct_i,
    ALUOp_i,
    ALUCtrl_o
);

// Ports
input   [9:0]      funct_i;
input   [1:0]      ALUOp_i;
output  [2:0]      ALUCtrl_o; 


// Read Data
wire    [2:0]      ALUCtrl;
assign  ALUCtrl[2] = funct_i[2];
assign  ALUCtrl[1] = funct_i[3];
assign  ALUCtrl[0] = funct_i[8];

assign  ALUCtrl_o = (ALUOp_i!=3)? 0:
                    (funct_i[2]==1)? funct_i[2:0]:ALUCtrl;
   
endmodule 

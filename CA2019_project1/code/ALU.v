module ALU
(
    data1_i,
    data2_i,
    ALUCtrl_i,
    data_o
);

// Ports
input   [31:0]      data1_i;
input   [31:0]      data2_i;
input   [2:0]       ALUCtrl_i;
output  [31:0]      data_o;


// Read Data
`define ADD 3'b000
`define SUB 3'b001
`define MUL 3'b010
`define OR  3'b110
`define AND 3'b111

assign  data_o = (ALUCtrl_i==`ADD)?data1_i+data2_i:
                 (ALUCtrl_i==`SUB)?data1_i-data2_i:
                 (ALUCtrl_i==`MUL)?data1_i*data2_i:
                 (ALUCtrl_i==`OR)?data1_i|data2_i:
                 (ALUCtrl_i==`AND)?data1_i&data2_i:data1_i;
   
endmodule 

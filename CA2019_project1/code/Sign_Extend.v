module Sing_Extend
(
    data_i,
    data_o
);

// Ports
input   [31:0]  data_i;
output  [31:0]  data_o;

// opcode: [6:0]
// addi:    0010011
// [31:20]
// lw:      0000011
// [31:20]
// sw:      0100011
// [31:25, 11:7]
// beq:     1100011
// [31, 7, 30:25, 11:8]

assign data_o[31:12] = {20{data_i[31]}};
assign data_o[11:0] = (data_i[6:4] == 3'b110) ? {data_i[31], data_i[7], data_i[30:25], data_i[11:8]} :  // beq
    (data_i[6:4] == 3'b010) ? {data_i[31:25], data_i[11:7]} :  // sw
    data_i[31:20];  // addi & lw (& else)

endmodule

module Forwarding (
	input [4:0]		ID_EX_RS1,   
	input [4:0]		ID_EX_RS2, 
	input [4:0]		EX_MEM_RD,
	input [4:0]		MEM_WB_RD,
	input 			EX_MEM_RegWrite,  
	input 			MEM_WB_RegWrite,
	output [1:0]	Forward_A,
	output [1:0]	Forward_B
);

assign Forward_A = (EX_MEM_RegWrite && (EX_MEM_RD != 0) && (EX_MEM_RD == ID_EX_RS1)) ? 2'b10 :
				   (MEM_WB_RegWrite && (MEM_WB_RD != 0) && (MEM_WB_RD == ID_EX_RS1)) ? 2'b01 :
				   2'b00;

assign Forward_B = (EX_MEM_RegWrite && (EX_MEM_RD != 0) && (EX_MEM_RD == ID_EX_RS2)) ? 2'b10 :
				   (MEM_WB_RegWrite && (MEM_WB_RD != 0) && (MEM_WB_RD == ID_EX_RS2)) ? 2'b01 :
				   2'b00;

endmodule
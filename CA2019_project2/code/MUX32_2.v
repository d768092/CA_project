module MUX32_2
(
    data1_i,
    data2_i,
    select_i,
    data_o
);

// Ports
input   [31:0]      data1_i;
input   [31:0]      data2_i;
input               select_i;
output  [31:0]      data_o; 


// Read Data      
assign  data_o = (select_i == 0)? data1_i : data2_i;
   
endmodule 

module MUX1_2
(
    data1_i,
    data2_i,
    select_i,
    data_o
);

// Ports
input         data1_i;
input         data2_i;
input         select_i;
output        data_o; 


// Read Data      
assign  data_o = (select_i == 0)? data1_i : data2_i;
   
endmodule 

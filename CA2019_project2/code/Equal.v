module Equal
(
    input   [31:0]   data1_i,
    input   [31:0]   data2_i,
    output           equal_o
);

assign equal_o = (data1_i==data2_i) ? 1 : 0;

endmodule
module Shift_left
(
    input    [31:0]   data_i,
    output   [31:0]   data_o
)

assign data_o = data_i<<1;

endmodule
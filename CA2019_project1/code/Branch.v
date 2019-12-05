module Branch(
    input     Branch_i,
    input     equal_i,
    output    Branch_o
);

reg    Branch_o;
always @* begin
    Branch_o = Branch_i & equal_i;
end

endmodule
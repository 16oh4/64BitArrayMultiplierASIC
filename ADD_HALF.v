`timescale 1ns / 1ps
module ADD_HALF(
    output cout,
    output sum,
    input a,
    input b
);
    xor(sum, a, b);
    and(cout, a, b);
endmodule
`timescale 1ns / 1ps

module FULL_ADDER(
    input a,b,cin,
    output cout,sum

);

wire half1_cout, half1_sum, half2_cout;

ADD_HALF HALF1(
.cout(half1_cout),
.sum(half1_sum),
.a(a),
.b(b)
);

ADD_HALF HALF2(
.cout(half2_cout),
.sum(sum),
.a(cin),
.b(half1_sum)
);

//for the carry out of both half adders
or(cout, half2_cout, half1_cout);

endmodule

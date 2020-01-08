`timescale 1ns / 1ps
module ARRAY_MULTIPLIER_SIM();

parameter bits = 64;
reg [bits-1:0] a,b;
wire [bits*2-1:0] p;

ARRAY_MULTIPLIER #(bits) UUT (
.a(a),
.b(b),
.p(p)
);


initial begin
//a = 2'b11;
//b = 2'b11;

a = 64'hABCD_EF77_4321_00A2;
b = 64'h38F3_440E_220F_EE30;

#10;

a = 64'h0000_1000_0000_0000;
b = 64'h0000_0000_0000_0010;

end


endmodule
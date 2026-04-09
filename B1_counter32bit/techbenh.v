`timescale 1ns/1ps
module tb_32bit;
wire  [31:0] Q;
reg rs,ud,E,clk;

counter_32bit_ud uut(.Q(Q), .rs(rs), .ud(ud), .E(E), .clk(clk) );

initial begin
	clk = 0;
	forever #10 clk = ~clk;
end

initial begin
rs = 1'b1;
ud = 1'b1;
E = 1'b1;
#50  ud = ~ud;
#100 E = 1'b0;
#500 $finish;
end
initial begin
	$monitor("At time %t, Q = %h", $time, Q);
	$dumpfile("counter_32bit.vcd");
	$dumpvars(0, tb_32bit);
end
endmodule
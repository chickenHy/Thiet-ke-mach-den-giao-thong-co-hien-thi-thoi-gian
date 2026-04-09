`timescale 1ns/1ps
module counter_32bit_ud(
	output reg [31:0] Q,
	input wire rs, ud, E,
	input wire clk
);

initial begin
	Q = 32'b0;
end
integer i;
always @(posedge clk) begin
	if(E) begin
		if (rs == 1'b0) begin
			Q <= 32'b0;
		end
		else begin
			if(ud) begin
				Q <= Q + 1;
			end
			else Q <= Q - 1;
		end
	end
end
endmodule

		
	
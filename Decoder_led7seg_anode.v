module Decoder_Led7Seg_Anode (
    input wire [3:0] timer,
    output reg [6:0]Q
);

always @(*) begin
    case(timer)
       'd0: Q= 7'b000_0001;
       'd1: Q= 7'b100_1111;
       'd2: Q= 7'b001_0010;
       'd3: Q= 7'b000_0110;
       'd4: Q= 7'b100_1000;
       'd5: Q= 7'b010_0100;
       'd6: Q= 7'b010_0000;
       'd7: Q= 7'b000_1111;
       'd8: Q= 7'b000_0000;
       'd9: Q= 7'b000_0100;
       default: Q <= 7'b111_1111;

    endcase
end
endmodule
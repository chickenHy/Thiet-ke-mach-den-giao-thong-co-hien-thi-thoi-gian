`timescale 1s/1ms
module tb_TrafficLight;

wire [5:0] Q;
wire [6:0] led7seg_DonVi1, led7seg_Chuc1, led7seg_DonVi2, led7seg_Chuc2;
reg clk, sw;
TrafficLight_FSM uut(
    .clk(clk), 
    .Q(Q), 
    .sw(sw),
    .led7seg_DonVi1(led7seg_DonVi1), 
    .led7seg_Chuc1(led7seg_Chuc1),
    .led7seg_DonVi2(led7seg_DonVi2), 
    .led7seg_Chuc2(led7seg_Chuc2)
    );

initial begin
    clk =0;
    forever #0.5 clk = ~clk;
end

initial begin
    sw = 0;
    #50 sw = 1; // Activate blinking mode
    #15 sw = 0;
    #50 $finish;
end

initial begin
    $monitor("sw = %1b ||| Time = %2d |  Den Q = %6b || TRL1 = %4d || TRL2 = %4d ||Chuc 1: %7b | Don Vi 1: %7b | Chuc 2: %7b | Don Vi 2: %7b",uut.sw, uut.timer, Q, uut.TRL1, uut.TRL2,led7seg_Chuc1, led7seg_DonVi1, led7seg_Chuc2, led7seg_DonVi2);
end

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,tb_TrafficLight);
end

endmodule
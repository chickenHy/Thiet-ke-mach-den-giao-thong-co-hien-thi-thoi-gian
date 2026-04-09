//==========================================================================================================================
// File Name: Decoder_led7seg_anode.v
// Project Name: Thiet ke mach den giao thong co hien thi thoi gian.
// Author: Le Chi Huy - 24119134 - nganh Cong Nghe Ky thuat may tinh - Truong Dai hoc Cong Nghe Ky Thuat TP.HCM
// Date: 09 - 04 - 2026
// Version: 1.0
// Description: Bo giai ma cho led 7 doan anode chung.
//              Dau vao: timer (gia tri tu 0 den 9 de hien thi tren led 7 doan)
//              Dau ra: Q (tin hieu dieu khien cho led 7 doan, 0 la sang, 1 la tat)
//==========================================================================================================================

`timescale 1s/1ms

module Decoder_Led7Seg_Anode (
//------------------- Thoi gian --------------------//
    input wire [4:0] timer, // Thoi gian tu 0 den 9 de hien thi tren led 7 doan

//------------------- switch --------------------//
    input wire sw, // sw = 0: Trang thai binh thuong, sw = 1: trang thai den nhap nhay

//------------------- Ngo ra --------------------//
    output reg [6:0] Q // Tin hieu dieu khien cho led 7 doan, 0 la sang, 1 la tat
);

//---------------------------------------------------------------//
// 1. GIAI MA THOI GIAN TU 0 DEN 9 THANH TIN HIEU CHO LED 7 DOAN ANODE
//---------------------------------------------------------------//
always @(*) begin
    if(sw) begin
        Q = 7'b1111111; // Tat tat ca khi o trang thai nhap nhay den vang
    end
    else begin
    case(timer)
       'd0: Q = 7'b0000001; // (a,b,c,d,e,f: sang; g: tat)
       'd1: Q = 7'b1001111; // (b,c: sang; a,d,e,f,g tat)
       'd2: Q = 7'b0010010; // (a,b,d,e,g: sang; c,f: tat)
       'd3: Q = 7'b0000110; // (a,b,c,d,g: sang; e,f: tat)
       'd4: Q = 7'b1001000; // (b,c,f,g: sang; a,d,e: tat)
       'd5: Q = 7'b0100100; // (a,c,d,f,g: sang; b,e: tat)
       'd6: Q = 7'b0100000; // (a,c,d,e,f,g: sang; b: tat)
       'd7: Q = 7'b0001111; // (a,b,c: sang; d,e,f,g: tat)
       'd8: Q = 7'b0000000; // (a,b,c,d,e,f,g: sang; h: tat)
       'd9: Q = 7'b0000100; // (a,b,c,d,f,g: sang; e: tat)
       default: Q = 7'b1111111; // Tat tat ca khi o trang thai nhap nhay den vang
    endcase
    end
    
end
endmodule
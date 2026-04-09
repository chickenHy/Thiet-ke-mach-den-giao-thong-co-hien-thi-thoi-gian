//==========================================================================================================================
// File Name: LightTraffic_fsm.v
// Project Name: Thiet ke mach den giao thong co hien thi thoi gian.
// Author: Le Chi Huy - 24119134 - nganh Cong Nghe Ky thuat may tinh - Truong Dai hoc Cong Nghe Ky Thuat TP.HCM
// Date: 09 - 04 - 2026
// Version: 1.0
// Description: Su dung mo hinh may trang thai huu han (FSM) de dieu khien den giao thong tai cac nga tu.
//              Ho tro che do binh thuong va che do nhap nhay vang (sw).
//              Tan so xung clock ngo vao la 1Hz.
//              Thoi gian moi cot se duoc hien thi tren 2 led 7 doan anode chung duoc ket noi truc tiep voi IO cua FPGA.
//==========================================================================================================================

`timescale 1s/1ms
module LightTraffic_fsm (
    //------- Clock -------//
    input wire clk, // Xung nhip cho he thong, tan so 1Hz

    //-------tin hieu dieu khien -------//
    input wire sw, // sw = 0: Trang thai binh thuong, sw = 1: trang thai den nhap nhay

    //------- Ngo ra -------//
    output reg [5:0] Q, // Tin hieu dieu khien den giao thong: Q[5:3] cho cot den 1(xanh, vang, do), Q[2:0] cho cot den 2(xanh, vang, do)
    output wire [6:0] led7seg_Chuc1,  // Du lieu cho led 7 doan hien thi hang chuc cua cot den 1
    output wire [6:0] led7seg_DonVi1, // Du lieu cho led 7 doan hien thi hang don vi cua cot den 1
    output wire [6:0] led7seg_Chuc2,  // Du lieu cho led 7 doan hien thi hang chuc cua cot den 2
    output wire [6:0] led7seg_DonVi2  // Du lieu cho led 7 doan hien thi hang don vi cua cot den 2
);

parameter [2:0] S1 = 3'b000, S2 = 3'b001, S3 = 3'b010, S4 = 3'b011; // Trang thai hoat dong binh thuong cua den giao thong
parameter [2:0] S5 = 3'b100, S6 = 3'b101; // Trang thai nhap nhay den vang

parameter Time_R = 15, Time_G = 15, Time_Y = 5, Time_YR = 5, Time_Blink = 1; // Thoi gian cho moi trang thai (don vi: giay)

parameter [5:0] l1 = 6'b100_001, l2 = 6'b010_001, l3 = 6'b001_010, l4 = 6'b001_100; // Cac trang thai ngo ra cho den giao thong
//l1: Cot 1 xanh, cot 2 do; l2: Cot 1 vang, cot 2 do; l3: Cot 1 do, cot 2 xanh; l4: Cot 1 do, cot 2 vang

parameter [5:0] BlinkLight = 6'b010_010; // Trang thai ngo ra o che do nhap nhay vang: ca hai cot deu bat den vang

reg [3:0] timer; // Bo dem thoi gian de thay doi trang thai den giao thong. Dem nguoc tu trang thai thoi hien tai ve 0, sau do chuyen trang thai tiep theo
reg [4:0] TRL1, TRL2; // Bo dem thoi gian cho moi cot den giao thong, giup hien thi thoi gian con lai tren Led 7 doan
reg [4:0] DonVi1, Chuc1, Chuc2, DonVi2; // Tach cac gia tri thoi gian con lai thanh hang don vi va hang chuc de hien thi tren Led 7 doan cua moi cot
reg [2:0] CurrentTime, NextTime; // Doc trang thai hien tai va tim kiem trang thai tiep theo dua vao trang thai hien tai

//------------Khoi tao nhung trang thai ban dau ------------//
initial begin
    CurrentTime = (sw) ? S5 : S1; // Xac nhan trang thai ban dau dua tren tin hieu dieu khien sw
    timer = Time_G; // Hien thi den xanh o cot 1 va den do o cot 2 khi bat dau
    TRL1 = Time_G; // Hien thi thoi gian dem nguoc cho den xanh o cot 1 khi bat dau
    TRL2 = Time_R + Time_Y; // Hien thi tong thoi gian dem nguoc cho den do o cot 2 khi bat dau (bao gom ca thoi gian den do o cot 2 va thoi gian den vang o cot 1)
end
//---------------------------------------------------------//

//----------------------------------------------------------------------------------------//
// 1. XAC DINH TRANG THAI HIEN TAI & TRANG THAI DEM NGUOC & THOI GIAN CHO MOI TRANG THAI //
//--------------------------------------------------------------------------------------//
always @(posedge clk or posedge sw) begin
    TRL1 <= TRL1 - 1; // Dem nguoc thoi gian hien thi tren led 7 doan cho cot den 1
    TRL2 <= TRL2 - 1; // Dem nguoc thoi gian hien thi tren led 7 doan cho cot den 2

    if(sw && CurrentTime != S5 && CurrentTime != S6) begin // Neu sw = 1, he thong chuyen sang che do nhap nhay vang, thoi gian dem nguoc cho ca hai cot den deu la Time_Blink
        timer <= Time_Blink;
        CurrentTime = S5; // Trang thai thoi gian hien tai la ca hai cot den deu bat den vang
        NextTime = S6; // Trang thai thoi gian tiep theo la ca hai c
    end
    else begin 
        if(timer > 1) begin  //  Dem nguoc thoi gian cho trang thai thoi gian hien tai
            timer <= timer - 1; 
        end

        else begin  // Xac dinh trang thai thoi gian hien tai sau khi cap nhat trang thai tiep theo
            CurrentTime = NextTime;
            case( CurrentTime)  // Xac dinh trang thai thoi gian hien tai va cap nhat thoi gian dem nguoc cho moi cot den giao thong tuong ung
                S1: begin // Trang thai 1: Cot 1 xanh, cot 2 do
                    timer <= Time_G;
                    TRL1 <= Time_G; // Hien thi thoi gian dem nguoc cho den xanh o cot 1 khi cot 2 bat den do
                    TRL2 <= Time_R + Time_Y; // Hien thi tong thoi gian dem nguoc cho den do o cot 2 khi cot 1 bat den xanh (bao gom ca thoi gian den do o cot 2 va thoi gian den vang o cot 1)
                end

                S2: begin // Trang thai 2: Cot 1 vang, cot 2 do
                    timer <= Time_Y;
                    TRL1 <= Time_Y; // Hien thi thoi gian dem nguoc cho den vang o cot 1 khi cot 2 van bat den do
                end

                S3: begin // Trang thai 3: Cot 1 do, cot 2 xanh
                    timer <= Time_YR;
                    TRL1 <= Time_YR + Time_R; // Hien thi tong thoi gian dem nguoc cho den do o cot 1 khi cot 1 bat den do (bao gom ca thoi gian den do o cot 1 va thoi gian den vang o cot 2)
                    TRL2 <= Time_YR; // Hien thi thoi gian dem nguoc cho den vang o cot 2 khi cot 1 bat den do
                end

                S4: begin  // Trang thai 4: Cot 1 do, cot 2 vang
                    timer <= Time_R;
                    TRL2 <= Time_G; // Hien thi thoi gian dem nguoc cho den xanh o cot 2 khi cot 1 bat den do
                end

                S5: begin // Trang thai 5: Ca hai cot den deu nhap nhay vang
                    timer <= Time_Blink; 
                    TRL1 <= 0; // Khong hien thi thoi gian dem nguoc cho cot den 1 trong che do nhap nhay vang
                    TRL2 <= 0; // Khong hien thi thoi gian dem nguoc cho cot den 2 trong che do nhap nhay vang
                end

                S6: begin // Trang thai 6: Ca hai cot den deu tat (trong che do nhap nhay vang)
                    timer <= Time_Blink;    
                    TRL1 <= 0; // Khong hien thi thoi gian dem nguoc cho cot den 1 trong che do nhap nhay vang
                    TRL2 <= 0; // Khong hien thi thoi gian dem nguoc cho cot den 2 trong che do nhap nhay vang
                end

                default: begin // Trang thai mac dinh: Cot 1 xanh, cot 2 do
                    timer <= Time_G;
                    TRL1 <= Time_G; // Hien thi thoi gian dem nguoc cho den xanh o cot 1 khi cot 2 bat den do
                    TRL2 <= Time_R + Time_Y; // Hien thi tong thoi gian dem nguoc cho den do o cot 2 khi cot 1 bat den xanh (bao gom ca thoi gian den do o cot 2 va thoi gian den vang o cot 1)
                end
            endcase
        end
    end
end

//----------------------------------------------------------------------------------------//
// 2. XAC DINH TRANG THAI TIEP
//----------------------------------------------------------------------------------------//
always @(*) begin

        if(sw) begin // He thong chuyen sang che do nhap nhay vang khi sw = 1
            case(CurrentTime) // Xac dinh trang thai thoi gian tiep theo trong che do nhap nhay vang
                S5: NextTime = S6; // Trang thai thoi gian tiep theo sau khi ca hai cot den deu bat den vang la ca hai cot den deu tat
                S6: NextTime = S5; // Trang thai thoi gian tiep theo sau khi ca hai cot den deu tat la ca hai cot den deu bat den vang
                default: NextTime = S5; // Trang thai thoi gian mac dinh cua ca hai cot den deu bat den vang
            endcase
        end
        else begin // He thong chuyen sang che do hoat dong binh thuong khi sw = 0
         case(CurrentTime) // Xac dinh trang thai thoi gian tiep theo (theo chu trinh S1 -> S2 -> S3 -> S4 -> S1)
            S1: NextTime = S2; // Trang thai thoi gian tiep theo la cot 1 vang, cot 2 do
            S2: NextTime = S3; // Trang thai thoi gian tiep theo la cot 1 do, cot 2 xanh
            S3: NextTime = S4; // Trang thai thoi gian tiep theo la cot 1 do, cot 2 vang
            S4: NextTime = S1; // Trang thai thoi gian tiep theo la cot 1 xanh, cot 2 do
            default: NextTime = S1; // Trang thai thoi gian mac dinh la cot 1 xanh, cot 2 do
         endcase
    end
end

//----------------------------------------------------------------------------------------//
// 3. HIEN THI THOI GIAN CON LAI TREN LED 7 DOAN & XAC DINH NGO RA CHO DEN GIAO THONG
//----------------------------------------------------------------------------------------//
always @(*) begin
    DonVi1 = TRL1 % 10; // Hien thi hang don vi cho cot den 1 tren led 7 doan
    Chuc1  = TRL1 / 10; // Hien thi hang chuc cot den 1 tren led 7 doan
    DonVi2 = TRL2 % 10; // Hien thi hang don vi cho cot den 2 tren led 7 doan
    Chuc2  = TRL2 / 10; // Hien thi hang chuc cho cot den 2 tren led 7 doan

end
//------------------Module giai ma Led 7 doan anode cho moi cot den giao thong------------------//
Decoder_Led7Seg_Anode DV1(.timer(DonVi1), .Q(led7seg_DonVi1), .sw(sw)); // Giai ma hang don vi cho cot den 1
Decoder_Led7Seg_Anode C1(.timer(Chuc1), .Q(led7seg_Chuc1), .sw(sw)); // Giai ma hang chuc cho cot den 1
Decoder_Led7Seg_Anode DV2(.timer(DonVi2), .Q(led7seg_DonVi2), .sw(sw)); // Giai ma hang don vi cho cot den 2
Decoder_Led7Seg_Anode C2(.timer(Chuc2), .Q(led7seg_Chuc2), .sw(sw)); // Giai ma hang chuc cho cot den 2
//---------------------------------------------------------------------------------------------//

always @(*) begin
    case(CurrentTime) // Xac dinh ngo ra cho den giao thong dua tren trang thai thoi gian hien tai
        S1:  Q = l1;  // Trang thai 1: Cot 1 xanh, cot 2 do
        S2:  Q = l2;  // Trang thai 2: Cot 1 vang, cot 2 do
        S3:  Q = l3;  // Trang thai 3: Cot 1 do, cot 2 xanh
        S4:  Q = l4;  // Trang thai 4: Cot 1 do, cot 2 vang
        S5:  Q = BlinkLight;  // Trang thai 5: Ca hai cot den deu nhap nhay vang
        S6:  Q = 6'b000_000; // Trang thai 6: Ca hai cot den deu tat (trong che do nhap nhay vang)
        default: Q = l1;  // Trang thai ngo ra mac dinh: Cot 1 xanh, cot 2 do
    endcase
end     

endmodule
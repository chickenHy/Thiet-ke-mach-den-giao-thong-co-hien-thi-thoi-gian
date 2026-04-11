//==========================================================================================================================
// File Name: TrafficLight_FSM.v
// Project Name: Thiet ke mach den giao thong co hien thi thoi gian.
// Version: 1.1
// Description: Su dung mo hinh may trang thai huu han (FSM) de dieu khien den giao thong tai cac nga tu.
//              Ho tro che do binh thuong va che do nhap nhay vang (sw).
//              Tan so xung clock ngo vao la 1Hz.
//              Thoi gian moi cot se duoc hien thi tren 2 led 7 doan anode chung duoc ket noi truc tiep voi IO cua FPGA.
//==========================================================================================================================

`timescale 1s/1ms
module TrafficLight_FSM (
    
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

parameter [4:0] Time_R = 15, Time_G = 15, Time_Y = 5, Time_YR = 5, Time_Blink = 1; // Thoi gian cho moi trang thai (don vi: giay)
parameter [4:0] TR = 20, TG = 15, TY = 5;
parameter [2:0] S1 = 3'b000, S2 = 3'b001, S3 = 3'b010, S4 = 3'b011; // Trang thai hoat dong binh thuong cua den giao thong
parameter [2:0] S5 = 3'b100, S6 = 3'b101; // Trang thai nhap nhay den vang

parameter [5:0] l1 = 6'b100_001, l2 = 6'b010_001, l3 = 6'b001_010, l4 = 6'b001_100; // Cac trang thai ngo ra cho den giao thong
//l1: Cot 1 xanh, cot 2 do; l2: Cot 1 vang, cot 2 do; l3: Cot 1 do, cot 2 xanh; l4: Cot 1 do, cot 2 vang
parameter [5:0] BlinkLight = 6'b010_010, NoBlinkLight = 6'b000_000; // Trang thai ngo ra o che do nhap nhay vang

reg [4:0] timer; // Bo dem thoi gian de thay doi trang thai den giao thong. Dem nguoc tu trang thai thoi hien tai ve 0, sau do chuyen trang thai tiep theo
reg [4:0] TRL1, TRL2; // Bo dem thoi gian cho moi cot den giao thong, giup hien thi thoi gian con lai tren Led 7 doan
reg [4:0] DonVi1, Chuc1, Chuc2, DonVi2; // Tach cac gia tri thoi gian con lai thanh hang don vi va hang chuc de hien thi tren Led 7 doan cua moi cot
reg [2:0] CurrentTime, NextTime; // Doc trang thai hien tai va tim kiem trang thai tiep theo dua vao trang thai hien tai

//------------Khoi tao nhung trang thai ban dau ------------//
initial begin
    CurrentTime = (sw) ? S5 : S1; // Xac nhan trang thai ban dau dua tren tin hieu dieu khien sw
    timer = Time_G; // Hien thi den xanh o cot 1 va den do o cot 2 khi bat dau
    TRL1 = Time_G + 1; // Hien thi thoi gian dem nguoc cho den xanh o cot 1 khi bat dau
    TRL2 = TR + 1; // Hien thi tong thoi gian dem nguoc cho den do o cot 2 khi bat dau (bao gom ca thoi gian den do o cot 2 va thoi gian den vang o cot 1)
end
//---------------------------------------------------------//

//----------------------------------------------------------------------------------------//
// 1. CAP NHAT TRANG THAI & THOI GIAN //
//----------------------------------------------------------------------------------------//
always @(posedge clk) begin
// Cap nhat thoi gian con lai cho moi cot den giao thong----------------------------------//
    if(sw == 1) begin //Thiet lap thoi gian cho che do nhap nhay vang
    TRL1 = TG;
    TRL2 = TR;
    end
    else begin // Cap nhat thoi gian con lai cho che do binh thuong
        TRL1 = TRL1 - 1;
        TRL2 = TRL2 - 1;
    end
    
// Cap nhat trang thai thoi gian hien tai cua den giao thong-----------------------------//
    case(CurrentTime)
        S1: begin // Trang thai 1: Cot 1 xanh, cot 2 do
            if(sw) NextTime = S5; // Chuyen sang trang thai nhap nhay vang
            else begin // Hoat dong binh thuong
                if(timer == 1) begin // Chuyen trang thai tiep theo khi het thoi gian cua trang thai hien tai
                    NextTime = S2;
                    timer = Time_Y; 
                    TRL1  = Time_Y; // Hien thi thoi gian dem nguoc cho den vang o cot 1 khi chuyen sang trang thai 2
                end
                else begin // Tiep tuc dem nguoc thoi gian cho trang thai hien tai
                    timer = timer - 1;
                    NextTime = S1; // Giu nguyen trang thai hien tai cho den khi het thoi gian 
                end
            end
        end

        S2: begin // Trang thai 2: Cot 1 vang, cot 2 do
            if(sw) NextTime = S5; // Chuyen sang trang thai nhap nhay vang
            else begin // Hoat dong binh thuong
                if(timer == 1) begin // Chuyen trang thai tiep theo khi het thoi gian cua trang thai hien tai
                    NextTime = S3;
                    timer = Time_YR;
                    TRL1  = TR; // Hien thi thoi gian dem nguoc cho den do o cot 2 khi chuyen sang trang thai 3 (bao gom ca thoi gian den do o cot 2 va thoi gian den vang o cot 1)
                    TRL2  = TY; // Hien thi thoi gian dem nguoc cho den vang o cot 2 khi chuyen sang trang thai 3
                    
                end
                else begin // Tiep tuc dem nguoc thoi gian cho trang thai hien tai
                    timer = timer - 1;
                    NextTime = S2; // Giu nguyen trang thai hien tai cho den khi het thoi gian 
                end
            end
        end

        S3: begin // Trang thai 3: Cot 1 do, cot 2 xanh
            if(sw) NextTime = S5; // Chuyen sang trang thai nhap nhay vang
            else begin // Hoat dong binh thuong
                if(timer == 1) begin // Chuyen trang thai tiep theo khi het thoi gian cua trang thai hien tai
                    NextTime = S4;
                    timer = Time_R;
                    TRL2  = TG; // Hien thi thoi gian dem nguoc cho den xanh o cot 2 khi chuyen sang trang thai 4
                end
                else begin // Tiep tuc dem nguoc thoi gian cho trang thai hien tai
                    timer = timer - 1;
                    NextTime = S3; // Giu nguyen trang thai hien tai cho den khi het thoi gian
                end
            end
        end

        S4: begin // Trang thai 4: Cot 1 do, cot 2 vang
            if(sw) NextTime = S5; // Chuyen sang trang thai nhap nhay vang
            else begin // Hoat dong binh thuong
                if(timer == 1) begin // Chuyen trang thai tiep theo khi het thoi gian cua trang thai hien tai
                    NextTime = S1;
                    timer = Time_G;
                    TRL1  = TG; // Hien thi thoi gian dem nguoc cho den xanh o cot 1 khi chuyen sang trang thai 1
                    TRL2  = TR; // Hien thi thoi gian dem nguoc cho den do o cot 2 khi chuyen sang trang thai 1 (bao gom ca thoi gian den do o cot 2 va thoi gian den vang o cot 1)
                end
                else begin // Tiep tuc dem nguoc thoi gian cho trang thai hien tai
                    timer = timer - 1;
                    NextTime = S4;  // Giu nguyen trang thai hien tai cho den khi het thoi gian
                end
            end
        end

        S5: begin // Trang thai 5: Ca hai cot den deu nhap nhay vang
            if(sw) NextTime = S6; // Chuyen sang trang thai ca hai cot den deu tat
            else begin // Tro ve trang thai binh thuong khi tat che do nhap nhay vang
                NextTime = S1;
                timer = Time_G;
            end
        end
        S6: begin // Trang thai 6: Ca hai cot den deu tat (trong che do nhap nhay vang)
            if(sw) NextTime = S5; // Chuyen sang trang thai ca hai cot den deu nhap nhay vang
            else begin // Tro ve trang thai binh thuong khi tat che do nhap nhay vang
                NextTime = S1;
                timer = Time_G;
            end
        end

        default: NextTime = S1;
    endcase 
end

//----------------------------------------------------------------------------------------//
// 2. XAC DINH TRANG THAI HIEN TAI
//----------------------------------------------------------------------------------------//
always @(*) begin
    CurrentTime = NextTime;
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
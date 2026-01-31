`timescale 1ns / 1ps

module alu_tb;
    reg [15:0] A;
    reg [15:0] B;
    reg [4:0]  F;   
    reg        Cin;
    wire [15:0] Result;
    wire [5:0]  Status; // Status Flags [C, Z, N, V, P, A]
    wire C_flag = Status[5];
    wire Z_flag = Status[4];
    wire N_flag = Status[3];
    wire O_flag = Status[2];
    wire P_flag = Status[1];
    wire A_flag = Status[0];
    alu uut (
        .A(A), 
        .B(B), 
        .F(F), 
        .Cin(Cin), 
        .Result(Result), 
        .Status(Status)
    );

    initial begin
        A = 0;
        B = 0;
        F = 0;
        Cin = 0;
        /*===========================Arithmetic=========================*/
        // 1. F = 00000: N/A
        F = 5'b00000; A = 16'h0000; B = 16'h0000; Cin = 0;
        #10;
        // 2. F = 00001: INC (Increment A) 
        F = 5'b00001; A = 16'h0B05; B = 16'h0000; Cin = 0;
        #10;
        // 3. F = 00010: N/A
        F = 5'b00010; A = 16'h0B05; B = 16'h0000; Cin = 0;
        #10;
        // 4. F = 00011: DEC (Decrement A)
        F = 5'b00011; A = 16'h0B05; B = 16'h0006; Cin = 0;
        #10;
        // 5. F = 00100: ADD 
        F = 5'b00100; A = 16'h0BA5; B = 16'h0003; Cin = 0;
        #10;
        // ADD Overflow Test
        F = 5'b00100; A = 16'h7FFF; B = 16'h0001; Cin = 0;
        #10;
        // 6. F = 00101: ADD CARRY 
        F = 5'b00101; A = 16'h0AB5; B = 16'h0CF3; Cin = 1;
        #10;
        // 7. F = 00110: SUB
        F = 5'b00110; A = 16'h050A; B = 16'h0BAC; Cin = 0;
        #10;
        // 8. F = 00111: SUB BORROW
        F = 5'b00111; A = 16'h000A; B = 16'h0003; Cin = 1;
        /*===========================logic==========================*/
        #10;
        // 9. F = 01000: AND
        F = 5'b01000; A = 16'hFFFF; B = 16'h00FF; Cin = 0;
        #10;
        // 10. F = 01001: OR
        F = 5'b01001; A = 16'hF000; B = 16'h000F; Cin = 0;
        #10;
        // 11. F = 01010: XOR
        F = 5'b01010; A = 16'hAAAA; B = 16'h5555; Cin = 0;
        #10;
        // 12. F = 01011: NOT
        F = 5'b01011; A = 16'h1010; B = 16'h0000; Cin = 0;
        /*===========================Shift===========================*/
        #10;
        // 13. F = 10000: SHL (Shift Left Logical)
        F = 5'b10000; A = 16'h0501; B = 16'h0001; Cin = 0;
        #10;
        // 14. F = 10001: SHR (Shift Right Logical)
        F = 5'b10001; A = 16'h0C02; B = 16'h0001; Cin = 0;
        #10;
        // 15. F = 10010: SAL (Arithmetic Shift Left)
        F = 5'b10010; A = 16'h7FFF; B = 16'h0001; Cin = 0;
        #10;
        // 16. F = 10011: SAR (Arithmetic Shift Right)
        F = 5'b10011; A = 16'h80F0; B = 16'h0001; Cin = 0;
        #10;
        // 17. F = 10100: ROL (Rotate Left)
        F = 5'b10100; A = 16'h8001; B = 16'h0001; Cin = 0;
        #10;
        // 18. F = 10101: ROR (Rotate Right)
        F = 5'b10101; A = 16'h8001; B = 16'h0001; Cin = 0;
        #10;
        // 19. F = 10110: RCL (Rotate Through Carry Left)
        F = 5'b10110; A = 16'h8008; B = 16'h0001; Cin = 1;
        #10;
        // 20. F = 10111: RCR (Rotate Through Carry Right)
        F = 5'b10111; A = 16'h8009; B = 16'h0001; Cin = 1;
        #10;
        /*===========================Sheet Cases==========================*/
        F = 5'b00111; A = 16'h0085; B = 16'h0095; Cin = 1; 
        #10;        // CASE 1: SBB AL, BL (AL=85, BL=95, CF=1)
        F = 5'b00100; A = 16'h0089; B = 16'h0087; Cin = 0; 
        #10;        // CASE 2: ADD AL, 87 (AL=89)
        F = 5'b10101; A = 16'h0082; B = 16'h000A; Cin = 0;
        #10;        // CASE 3: ROR AL, CL (AL=82, CL=0A)
        F = 5'b10010; A = 16'h0073; B = 16'h0001; Cin = 0;
        #10;        // CASE 4: SAL AL, 1 (AL=73)
        F = 5'b10111; A = 16'h0073; B = 16'h0001; Cin = 1;
        #10;        // CASE 5: RCR AL, 1 (AL=73, CF=1)
        F = 5'b00100; A = 16'h0006; B = 16'h0005; Cin = 0;        
        #10;        // CASE 6: ADD BL, 05 (BL=06)
        F = 5'b01010; A = 16'h0055; B = 16'h00FF; Cin = 0;
        #10;        // CASE 7: XOR AL, FF (AL=55)
        F = 5'b00110; A = 16'h56BC; B = 16'h47CD; Cin = 0; 
        #10;        // CASE 8: SUB AX, BX (AX=56BC, BX=47CD)
        F = 5'b00100; A = 16'h7FFF; B = 16'h3333; Cin = 0;   
        #10;        // CASE 9: ADD DX, CX (DX=7FFF, CX=3333)
        F = 5'b01000; A = 16'h5555; B = 16'h5AAA; Cin = 0;   
         #10;       // CASE 10: AND AX, BX (AX=5555, CX/BX=5AAA)
        $stop;
    end

endmodule
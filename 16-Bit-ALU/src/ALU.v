module alu (
    input  [15:0] A,
    input  [15:0] B,
    input  [4:0]  F,
    input         Cin,
    output reg [15:0] Result,
    output [5:0]  Status // {C, Z, N, V, P, A}
);

    reg        C;   
    reg        V;   
    reg        Aux;  

   
    assign Status[5] = C;       
    assign Status[4] = (Result == 16'h0000); 
    assign Status[3] = Result[15];   
    assign Status[2] = V;       
    assign Status[1] = ~^Result;     
    assign Status[0] = Aux;      

    always @(*) begin
    
        Result   = 16'h0000;
        C   = 0;
        V   = 0;
        Aux   = 0;

        case (F)
        /*===========================Arithmetic=========================*/
            5'b00000: begin
                Result = 16'h0000;
                C=0;
                V=0;
                Aux=0;

            end

            5'b00001: begin 
                {C,Result} = A + 1'b1;
                V   = (A == 16'h7FFF);
                Aux = (({1'b0, A[3:0]} + 1'b1) > 5'hF);
            end

            5'b00010: begin
                Result = 16'h0000;
                C=0;
                V=0;
                Aux=0;
            end

            5'b00011: begin
                {C,Result} = A - 1'b1;
               // C   = ~Res[16];
                V   = (A == 16'h8000);
                Aux   = (A[3:0] == 4'h0);
            end

            5'b00100: begin 
                {C,Result} = A + B;
                V   =  (A[15] == B[15]) && (Result[15] != A[15]); 
               Aux = (({1'b0, A[3:0]} + {1'b0, B[3:0]}) > 5'hF);
            end

            5'b00101: begin 
                {C,Result} = A + B + Cin;
                V   =  (A[15] == B[15]) && (Result[15] != A[15]); 
                Aux = (({1'b0, A[3:0]} + {1'b0, B[3:0]} + Cin) > 5'hF);
            end

            5'b00110: begin
                {C,Result} = A - B; 
                 V = (A[15] != B[15]) && (Result[15] != A[15]); 
                Aux   = (A[3:0] < B[3:0]);
            end

            5'b00111: begin 
                {C,Result} = A - B - Cin;
                 V = (A[15] != B[15]) && (Result[15] != A[15]);  
                Aux   = ({1'b0, A[3:0]} < ({1'b0, B[3:0]} + Cin));
            end

            /*===========================logic==========================*/


            5'b01000: Result = A & B; 
            5'b01001: Result = A | B; 
            5'b01010: Result = A ^ B; 
            5'b01011: Result = ~A;    


            /*===========================Shift===========================*/

            5'b10000: begin 
                C = A[15];    
                Result = A << 1;
            end

            5'b10001: begin
                C = A[0];       
                Result = A >> 1;
            end

            5'b10010: begin 
                C = A[15];
                Result = A << 1;
            end

            5'b10011: begin 
                C = A[0];
                Result = {A[15],A[15:1]}; 
            end

            5'b10100: begin 
                C = A[15];     
                Result = {A[14:0], A[15]}; 
            end

            5'b10101: begin 
                C = A[0];       
                Result = {A[0], A[15:1]}; 
            end

            5'b10110: begin 
                C = A[15];      
                Result = {A[14:0], Cin}; 
            end

            5'b10111: begin 
                C = A[0];       
                Result = {Cin, A[15:1]}; 
            end

            default: begin
            Result = 16'h0000;
            C=0;
            V=0;
            Aux=0;
            end
        endcase
    end

endmodule
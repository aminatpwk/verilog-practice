module alu(
    input [15:0] A,
    input [15:0] B,
    input [2:0] ALU_Op,
    input [1:0] mode, 
    input clk,
    output reg[15:0] Result,
    output reg Zero,
    output reg Overflow,
    output reg Negative,
    output reg Carry
);

wire[15:0] nota, notb;
assign nota = (mode[0]) ? ~A : A;
assign notb = (mode[1]) ? ~B : B;

always @(posedge clk) begin
    case(ALU_Op)
        3'b000: Result = nota + notb;
        3'b001: Result = nota - notb;
        3'b010: Result = nota & notb;
        3'b011: Result = nota | notb;
        3'b100: Result = nota ^ notb;
        3'b101: Result = nota << 2;
        3'b110: Result = nota >> 2;
        3'b111: Result = (nota < notb) ? 16'b1 : 16'b0;
        default: Result = 16'hxxxx;
    endcase

    Zero = (Result == 16'b0) ? 1 : 0;
    Negative = Result[15];
    Overflow = (ALU_Op == 3'b000 || ALU_Op == 3'b001) && ((nota[15] == notb[15]) && (Result[15] != nota[15]));
end

endmodule

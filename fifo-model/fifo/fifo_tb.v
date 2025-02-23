`timescale 1ns / 1ps
`define FWIDTH 32
`define FDEPTH 4
`define FCWIDTH 2

module fifo_tb;

    reg Clk;
    reg RstN;
    reg [`FWIDTH-1:0] Data_In;
    reg FInN;
    reg FClrN;
    reg FOutN;

    wire [`FWIDTH-1:0] F_Data;
    wire F_FullN;
    wire F_EmptyN;
    wire F_LastN;
    wire F_SLastN;
    wire F_FirstN;

    FIFO uut (
        .Clk(Clk),
        .RstN(RstN),
        .Data_In(Data_In),
        .FClrN(FClrN),
        .FInN(FInN),
        .FOutN(FOutN),
        .F_Data(F_Data),
        .F_FullN(F_FullN),
        .F_EmptyN(F_EmptyN),
        .F_LastN(F_LastN),
        .F_SLastN(F_SLastN),
        .F_FirstN(F_FirstN)
    );

    always #5 Clk = ~Clk; 

    initial begin
        $dumpfile("fifo_tb.vcd"); 
        $dumpvars(0, fifo_tb);

        Clk = 0;
        RstN = 0;
        FClrN = 1;
        FInN = 1;
        FOutN = 1;
        Data_In = 32'h00000000;

        #10 RstN = 1;

        #10 Data_In = 32'hA5A5A5A5; FInN = 0;
        #10 FInN = 1; // Latch Data
        #10 Data_In = 32'h5A5A5A5A; FInN = 0;
        #10 FInN = 1;

        #10 FOutN = 0;
        #10 FOutN = 1;

        #50 FOutN = 0;
        #10 FOutN = 1;

        #100 $finish; 
    end
endmodule

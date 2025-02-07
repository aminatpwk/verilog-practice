module alutlb;
    reg [15:0] A, B;
    reg [2:0] ALU_Op;
    reg [1:0] mode;
    reg clk;
    wire [15:0] Result;
    wire Zero, Overflow, Negative, Carry;

    alu uut (
        .A(A),
        .B(B),
        .ALU_Op(ALU_Op),
        .mode(mode),
        .clk(clk),
        .Result(Result),
        .Zero(Zero),
        .Overflow(Overflow),
        .Negative(Negative),
        .Carry(Carry)
    );

    always begin
        #5 clk = ~clk;  
    end

    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, alutlb);
        clk = 0;
        A = 16'b0000000000000001;  
        B = 16'b0000000000000010; 
        mode = 2'b00;  
        ALU_Op = 3'b000; 
        
        #10;  
        $display("Test 1: ALU Operation = A + B");
        $display("Result = %b, Zero = %b, Negative = %b, Overflow = %b, Carry = %b", Result, Zero, Negative, Overflow, Carry);

        ALU_Op = 3'b001; 
        #10;
        $display("Test 2: ALU Operation = A - B");
        $display("Result = %b, Zero = %b, Negative = %b, Overflow = %b, Carry = %b", Result, Zero, Negative, Overflow, Carry);

        ALU_Op = 3'b010;  
        #10;
        $display("Test 3: ALU Operation = A & B");
        $display("Result = %b, Zero = %b, Negative = %b, Overflow = %b, Carry = %b", Result, Zero, Negative, Overflow, Carry);

        ALU_Op = 3'b011;  
        #10;
        $display("Test 4: ALU Operation = A | B");
        $display("Result = %b, Zero = %b, Negative = %b, Overflow = %b, Carry = %b", Result, Zero, Negative, Overflow, Carry);

        ALU_Op = 3'b100; 
        #10;
        $display("Test 5: ALU Operation = A XOR B");
        $display("Result = %b, Zero = %b, Negative = %b, Overflow = %b, Carry = %b", Result, Zero, Negative, Overflow, Carry);

        ALU_Op = 3'b101; 
        #10;
        $display("Test 6: ALU Operation = A << 2");
        $display("Result = %b, Zero = %b, Negative = %b, Overflow = %b, Carry = %b", Result, Zero, Negative, Overflow, Carry);

        ALU_Op = 3'b110;  
        #10;
        $display("Test 7: ALU Operation = A >> 2");
        $display("Result = %b, Zero = %b, Negative = %b, Overflow = %b, Carry = %b", Result, Zero, Negative, Overflow, Carry);

        ALU_Op = 3'b111;  
        #10;
        $display("Test 8: ALU Operation = A < B");
        $display("Result = %b, Zero = %b, Negative = %b, Overflow = %b, Carry = %b", Result, Zero, Negative, Overflow, Carry);

        mode = 2'b10; 
        ALU_Op = 3'b000;  
        #10;
        $display("Test 9: ALU Operation = ~A + B");
        $display("Result = %b, Zero = %b, Negative = %b, Overflow = %b, Carry = %b", Result, Zero, Negative, Overflow, Carry);
        
        $finish;
    end
endmodule

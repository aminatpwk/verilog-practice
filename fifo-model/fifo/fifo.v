`define FWIDTH 32
`define FDEPTH 4
`define FCWIDTH 2

module FIFO(
    Clk,
    RstN,
    Data_In,
    FClrN,
    FInN,
    FOutN,
    F_Data,
    F_FullN,
    F_LastN,
    F_SLastN,
    F_FirstN,
    F_EmptyN
);

input Clk;
input RstN;
input [(`FWIDTH-1):0] Data_In;
input FInN;
input FClrN;
input FOutN;

output [(`FWIDTH-1):0] F_Data;
output F_FullN;
output F_EmptyN;
output F_LastN;
output F_SLastN;
output F_FirstN;

reg F_FullN;
reg F_EmptyN;
reg F_LastN;
reg F_SLastN;
reg F_FirstN;
reg [`FWIDTH:0] fcounter; //counter indicates num of data in FIFO
reg [`FCWIDTH-1:0] rd_ptr; // 2-bit read pointer
reg [`FCWIDTH-1:0] wr_ptr; // 2-bit write pointer

wire [(`FWIDTH-1):0] FIFODataOut;
wire [(`FWIDTH-1):0] FIFODataIn;
wire ReadN = FOutN;
wire WriteN = FInN;

assign F_Data = FIFODataOut;
assign FIFODataIn = Data_In;

FIFO_MEM_BLK memblk(.clk(CLK),
                    .writeN(WriteN),
                    .data_in(FIFODataIn),
                    .data_out(FIFODataOut),
                    .wr_addr(wr_ptr),
                    .rd_addr(rd_ptr)
);

always @(posedge Clk or negedge RstN)
begin
    if(!RstN) begin
        fcounter <= 0;
        rd_ptr <= 0;
        wr_ptr <= 0;
    end
    else begin
        if(~FClrN)begin
            fcounter <= 0;
            rd_ptr <= 0;
            wr_ptr <= 0;
        end
        else begin
            if(~WriteN)
                wr_ptr <= wr_ptr + 1;
            if(~ReadN)
                rd_ptr <= rd_ptr + 1;
            if(~WriteN && ~ReadN && F_FullN)
                fcounter <= fcounter + 1;
            else if(WriteN && ~ReadN && F_EmptyN)
                fcounter <= fcounter - 1;
        end
    end
end

always @(posedge Clk or negedge RstN)
begin
    if(!RstN)
        F_EmptyN <= 1'b0;
    else begin
        if(FClrN==1'b1) begin
            if(F_EmptyN==1'b0 && WriteN == 1'b0)
                F_EmptyN <= 1'b1;
            else if(F_FirstN == 1'b0 && ReadN == 1'b0 && WriteN == 1'b1)
                F_EmptyN <= 1'b0;
        end
        else 
            F_EmptyN <= 1'b0;
    end
end

always @(posedge Clk or negedge RstN)
begin
    if(!RstN)
        F_FirstN <= 1'b1;
    else begin
        if(FClrN == 1'b1) begin
            if((F_EmptyN==1'b0 && WriteN == 1'b0) || (fcounter==2 && ReadN ==1'b0 && WriteN ==1'b1))
                F_FirstN <= 1'b0;
            else if(F_FirstN==1'b0 && (WriteN ^ ReadN))
                F_FirstN <= 1'b1;
        end
        else begin
            F_FirstN <= 1'b1;
        end
    end
end

always @(posedge Clk or negedge RstN)
begin
    if(!RstN)
        F_SLastN <= 1'b1;
    else begin
        if(FClrN == 1'b1) begin
            if((F_LastN == 1'b0 && ReadN == 1'b0 && WriteN==1'b1) || (fcounter == (`FDEPTH-2) && WriteN==1'b0 && ReadN==1'b1))
                F_SLastN <= 1'b0;
            else if(F_SLastN == 1'b0 && (ReadN ^ WriteN))
                F_SLastN <= 1'b1;
        end
        else 
            F_SLastN <= 1'b1;
    end
end

always @(posedge Clk or negedge RstN)
begin
    if(!RstN)
        F_FullN <= 1'b1;
    else begin
        if(FClrN == 1'b1) begin
            if(F_LastN == 1'b0 && WriteN==1'b0 && ReadN == 1'b1)
                F_FullN <= 1'b0;
            else if(F_FullN == 1'b0 && ReadN == 1'b0)
                F_FullN <= 1'b1;
        end
        else 
            F_FullN <= 1'b1;
    end
end

endmodule
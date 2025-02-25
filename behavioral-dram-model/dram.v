module DRAM(
    DATA,
    MA,
    RAS_N,
    CAS_N,
    LWE_N,
    UWE_N,
    OE_N
);
input [15:0] DATA;
input [9:0] MA;
input RAS_N;
input CAS_N;
input LWE_N;
input UWE_N;
input OE_N;

reg [15:0] memblk [0:262143]; //memory block 256k x 16
reg [9:0] rowadd; //row address upper 10 bits of MA
reg [7:0] coladd; //column address lower 8 bits of MA
reg [15:0] rd_data;
reg [15:0] temp_reg;

reg hidden_ref;
reg last_lwe;
reg last_uwe;
reg cas_bef_ras_ref;
reg end_cas_bef_ras_ref;

reg last_cas;
reg read;
reg rmw;
reg output_disable_check;
integer page_mode;

assign #5 DATA = (OE_N == 1'b0 && CAS_N === 1'b0) ? rd_data : 16'bz;

parameter infile = "ini_file";
initial begin
    $readmemh(infile, memblk);
end

always @(RAS_N)
begin
    if(RAS_N == 1'b0) begin
        if(CAS_N == 1'b1) begin
            rowadd = MA;
        end
        else hidden_ref = 1'b1;
    end
    else
        hidden_ref = 1'b0;
end

always @(CAS_N)
    #1 last_cas = CAS_N;

always @(CAS_N or LWE_N or UWE_N)
begin
    if(RAS_N === 1'b0 && CAS_N === 1'b0)
    begin
        if(last_cas == 1'b1)
            coladd = MA[7:0];
        if(LWE_N !== 1'b0 && UWE_N !== 1'b0) begin
            rd_data = memblk[{rowadd, coladd}];
            $display("READ : address = %b, Data = %b", {rowadd, coladd}, rd_data);
        end
        else if(LWE_N===1'b0 && UWE_N === 1'b0)begin
            memblk[{rowadd, coladd}] = DATA;
            $display("WRITE : address = %b, Data = %b", {rowadd, coladd}, DATA);
        end
        else if(LWE_N === 1'b0 && UWE_N === 1'b1)begin
            temp_reg = memblk[{rowadd, coladd}];
            temp_reg[7:0] = DATA[7:0];
            memblk[{rowadd, coladd}] = temp_reg;
        end
        else if(LWE_N === 1'b1 && UWE_N === 1'b0) begin
            temp_reg = memblk[{rowadd, coladd}];
            temp_reg[15:8] = DATA[15:8];
            memblk[{rowadd, coladd}] = temp_reg;
        end
    end
end

//refresh
always @(CAS_N or RAS_N) 
begin
    if(CAS_N == 1'b0 && last_cas === 1'b1 && RAS_N === 1'b1)begin
        cas_bef_ras_ref = 1'b1;
    end
    if(CAS_N === 1'b1 && RAS_N === 1'b1 && cas_bef_raf_ref == 1'b1)begin
        end_cas_bef_ras_ref = 1'b1;
        cas_bef_ras_ref = 1'b0;
    end
    if((CAS_N === 1'b0 && RAS_N === 1'b0) && end_cas_bef_ras_ref == 1'b1)
        end_cas_bef_ras_ref = 1'b0;
end
endmodule
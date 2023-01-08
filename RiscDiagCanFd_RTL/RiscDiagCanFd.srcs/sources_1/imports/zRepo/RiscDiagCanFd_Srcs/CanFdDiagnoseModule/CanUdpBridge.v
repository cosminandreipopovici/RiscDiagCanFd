`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2022 07:48:52 PM
// Design Name: 
// Module Name: CanUdpBridge
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CanUdpBridge(
    input clk,
    input reset,
    input udp_write_en,
    input [4:0] udp_write_addr,
    input [31:0] udp_write_data,
    input UDP0_Connected,
    input UDP0_OutIsEmpty,
    output reg [7:0] UDP0_TxData,
    output reg UDP0_TxValid,
    input UDP0_TxReady,
    output reg UDP0_TxLast,
    input [7:0] UDP0_RxData,
    input UDP0_RxValid,
    output /*reg*/ UDP0_RxReady,
    input UDP0_RxLast,
    output txing
    );


parameter S0  = 2'b00;   
parameter S1  = 2'b01;
parameter S2  = 2'b10;
parameter S3  = 2'b11;

integer i;

reg [1:0] cs;
reg [1:0] ns;

reg [7:0] mem [0:83];

wire      req;
reg [6:0] cnt;
reg       inc;
wire      fin;
wire      ret;
reg       nwd;

reg rescnt;

reg       rd1;
reg       rd2;

reg [31:0] tms; 

wire unused;
wire unused_array;

always @(posedge clk)
begin
    if(reset==0)
    begin
        rd1<=1;
        rd2<=0;
        tms<=0;
        for(i=0;i<84;i=i+1)
        begin
            mem[i]<=8'h0;
        end
    end
    else if(udp_write_en==0)
    begin
        rd1<=1;
        tms<=0;
        rd2<=0;
    end
    else if(udp_write_en==1)
    begin
        case(udp_write_addr)
            5'h00 : begin mem[ 0]<=udp_write_data[31:24];mem[ 1]<=udp_write_data[23:16];mem[ 2]<=udp_write_data[15:8];mem[ 3]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h01 : begin mem[ 4]<=udp_write_data[31:24];mem[ 5]<=udp_write_data[23:16];mem[ 6]<=udp_write_data[15:8];mem[ 7]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h02 : begin mem[ 8]<=udp_write_data[31:24];mem[ 9]<=udp_write_data[23:16];mem[10]<=udp_write_data[15:8];mem[11]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h03 : begin mem[12]<=udp_write_data[31:24];mem[13]<=udp_write_data[23:16];mem[14]<=udp_write_data[15:8];mem[15]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            
            /*5'h04 : begin mem[16]<=udp_write_data[31:24];mem[17]<=udp_write_data[23:16];mem[18]<=udp_write_data[15:8];mem[19]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h05 : begin mem[20]<=udp_write_data[31:24];mem[21]<=udp_write_data[23:16];mem[22]<=udp_write_data[15:8];mem[23]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h06 : begin mem[24]<=udp_write_data[31:24];mem[25]<=udp_write_data[23:16];mem[26]<=udp_write_data[15:8];mem[27]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h07 : begin mem[28]<=udp_write_data[31:24];mem[29]<=udp_write_data[23:16];mem[30]<=udp_write_data[15:8];mem[31]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h08 : begin mem[32]<=udp_write_data[31:24];mem[33]<=udp_write_data[23:16];mem[34]<=udp_write_data[15:8];mem[35]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h09 : begin mem[36]<=udp_write_data[31:24];mem[37]<=udp_write_data[23:16];mem[38]<=udp_write_data[15:8];mem[39]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h0A : begin mem[40]<=udp_write_data[31:24];mem[41]<=udp_write_data[23:16];mem[42]<=udp_write_data[15:8];mem[43]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h0B : begin mem[44]<=udp_write_data[31:24];mem[45]<=udp_write_data[23:16];mem[46]<=udp_write_data[15:8];mem[47]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h0C : begin mem[48]<=udp_write_data[31:24];mem[49]<=udp_write_data[23:16];mem[50]<=udp_write_data[15:8];mem[51]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h0D : begin mem[52]<=udp_write_data[31:24];mem[53]<=udp_write_data[23:16];mem[54]<=udp_write_data[15:8];mem[55]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h0E : begin mem[56]<=udp_write_data[31:24];mem[57]<=udp_write_data[23:16];mem[58]<=udp_write_data[15:8];mem[59]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h0F : begin mem[60]<=udp_write_data[31:24];mem[61]<=udp_write_data[23:16];mem[62]<=udp_write_data[15:8];mem[63]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h10 : begin mem[64]<=udp_write_data[31:24];mem[65]<=udp_write_data[23:16];mem[66]<=udp_write_data[15:8];mem[67]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h11 : begin mem[68]<=udp_write_data[31:24];mem[69]<=udp_write_data[23:16];mem[70]<=udp_write_data[15:8];mem[71]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h12 : begin mem[72]<=udp_write_data[31:24];mem[73]<=udp_write_data[23:16];mem[74]<=udp_write_data[15:8];mem[75]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h13 : begin mem[76]<=udp_write_data[31:24];mem[77]<=udp_write_data[23:16];mem[78]<=udp_write_data[15:8];mem[79]<=udp_write_data[7:0];rd1<=0;rd2<=0;end*/
            
            //payload bytes are inverted
            5'h04 : begin mem[19]<=udp_write_data[31:24];mem[18]<=udp_write_data[23:16];mem[17]<=udp_write_data[15:8];mem[16]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h05 : begin mem[23]<=udp_write_data[31:24];mem[22]<=udp_write_data[23:16];mem[21]<=udp_write_data[15:8];mem[20]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h06 : begin mem[27]<=udp_write_data[31:24];mem[26]<=udp_write_data[23:16];mem[25]<=udp_write_data[15:8];mem[24]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h07 : begin mem[31]<=udp_write_data[31:24];mem[30]<=udp_write_data[23:16];mem[29]<=udp_write_data[15:8];mem[28]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h08 : begin mem[35]<=udp_write_data[31:24];mem[34]<=udp_write_data[23:16];mem[33]<=udp_write_data[15:8];mem[32]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h09 : begin mem[39]<=udp_write_data[31:24];mem[38]<=udp_write_data[23:16];mem[37]<=udp_write_data[15:8];mem[36]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h0A : begin mem[43]<=udp_write_data[31:24];mem[42]<=udp_write_data[23:16];mem[41]<=udp_write_data[15:8];mem[40]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h0B : begin mem[47]<=udp_write_data[31:24];mem[46]<=udp_write_data[23:16];mem[45]<=udp_write_data[15:8];mem[44]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h0C : begin mem[51]<=udp_write_data[31:24];mem[50]<=udp_write_data[23:16];mem[49]<=udp_write_data[15:8];mem[48]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h0D : begin mem[55]<=udp_write_data[31:24];mem[54]<=udp_write_data[23:16];mem[53]<=udp_write_data[15:8];mem[52]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h0E : begin mem[59]<=udp_write_data[31:24];mem[58]<=udp_write_data[23:16];mem[57]<=udp_write_data[15:8];mem[56]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h0F : begin mem[63]<=udp_write_data[31:24];mem[62]<=udp_write_data[23:16];mem[61]<=udp_write_data[15:8];mem[60]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h10 : begin mem[67]<=udp_write_data[31:24];mem[66]<=udp_write_data[23:16];mem[65]<=udp_write_data[15:8];mem[64]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h11 : begin mem[71]<=udp_write_data[31:24];mem[70]<=udp_write_data[23:16];mem[69]<=udp_write_data[15:8];mem[68]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h12 : begin mem[75]<=udp_write_data[31:24];mem[74]<=udp_write_data[23:16];mem[73]<=udp_write_data[15:8];mem[72]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            5'h13 : begin mem[79]<=udp_write_data[31:24];mem[78]<=udp_write_data[23:16];mem[77]<=udp_write_data[15:8];mem[76]<=udp_write_data[7:0];rd1<=0;rd2<=0;end
            
            5'h14 : begin mem[80]<=udp_write_data[31:24];mem[81]<=udp_write_data[23:16];mem[82]<=udp_write_data[15:8];mem[83]<=udp_write_data[7:0];rd1<=1;rd2<=1;end //or 0?
            default: begin rd1<=1; rd2<=0;end
        endcase
    end
end

always @(posedge clk) //next state generation
begin
    if(reset==0)
    begin
        cs<=S0;
    end
    else
    begin
        cs<=ns;
    end
end

always @(posedge clk) //outputs logic
begin
    casex(cs)
        S0:
            begin
                UDP0_TxValid<=1'h0;
                UDP0_TxData<=8'h00;
                inc<=0;
            end
        S3:
            begin
                UDP0_TxValid<=1'h0;
                UDP0_TxData<=8'h00;
                inc<=0;
            end	
        S1:
            begin
                UDP0_TxValid<=1'h1;
                UDP0_TxData<=mem[cnt];
                inc<=1;
            end
        S2:
            begin
                UDP0_TxValid<=1'h0;
                UDP0_TxData<=8'h00;
                inc<=0;
            end
        default:
            begin
                UDP0_TxValid<=1'h0;
                UDP0_TxData<=8'h00;
                inc<=0;
            end
    endcase
end

always @(posedge clk)         //next state logic
begin
    /*casex({cs,req,rd1,fin,ret})
        {S0,1'b0,1'bx,1'bx,1'bx}: ns<=S0; 
        {S0,1'b1,1'bx,1'bx,1'bx}: ns<=S3;
        
        {S3,1'bx,1'b0,1'bx,1'bx}: ns<=S3;
        {S3,1'bx,1'b1,1'bx,1'bx}: ns<=S1;
        
        {S1,1'bx,1'bx,1'b0,1'bx}: ns<=S1;
        {S1,1'bx,1'bx,1'b1,1'bx}: ns<=S2;
        
        {S2,1'bx,1'bx,1'bx,1'b0}: ns<=S2;
        {S2,1'bx,1'bx,1'bx,1'b1}: ns<=S0;
        default: ns<=S0;        
    endcase */
    
    casex({cs,rd2,fin,ret})
        {S0,1'b0,1'bx,1'bx}: ns<=S0; 
        {S0,1'b1,1'bx,1'bx}: ns<=S1;
        
        {S1,1'bx,1'b0,1'bx}: ns<=S1;
        {S1,1'bx,1'b1,1'bx}: ns<=S2;
        
        {S2,1'bx,1'bx,1'b0}: ns<=S2;
        {S2,1'bx,1'bx,1'b1}: ns<=S0;
        default: ns<=S0;        
    endcase
    
    /*casex({cs,rd2,fin})
        {S0,1'b0,1'bx}: ns<=S0; 
        {S0,1'b1,1'bx}: ns<=S1;
        
        {S1,1'bx,1'b0}: ns<=S1;
        {S1,1'bx,1'b1}: ns<=S0;
        
        default: ns<=S0;        
    endcase*/
end

always @(posedge clk) //transmit counter logic
begin
    if(reset==0)
        cnt<=0;
    else if (rescnt==1)
        cnt<=0;
    else if(inc==1)
        cnt<=cnt+1;
end

always @(posedge clk) //transmit counter reset logic
begin
    casex(cs)
        S0: rescnt<=0; 
        S3: rescnt<=0;
        S1: rescnt<=0;
        S2: rescnt<=1;
        default: rescnt<=0;       
    endcase
end

always @(posedge clk)
begin
    if (reset==0)
    begin
        UDP0_TxLast<=0;
    end
    //else if((cs==S1) && (cnt==83))
    else if((cs==S1) && (cnt==81))
    begin
        UDP0_TxLast<=1;
    end
    else
    begin
        UDP0_TxLast<=0;
    end
end

//assign fin=(cnt==83)?1'b1:1'b0;
assign fin=(cnt==81)?1'b1:1'b0;
assign ret=UDP0_OutIsEmpty;

assign txing=(cs==S1);

assign UDP0_RxReady=0;
assign unused=UDP0_RxLast|UDP0_RxValid;
assign unused_array=UDP0_RxData;

endmodule
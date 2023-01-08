`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2022 08:46:33 PM
// Design Name: 
// Module Name: UWORDsender
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


module UWORDsender(
        input reset,
        input clock,
        input [31:0] word_to_send,
        input EN,

        input o_Tx_Done,
        output reg i_Tx_DV,
        output reg [7:0] i_Tx_Byte,
        output reg Tx_NotDone
    );
    
    reg [3:0] cs,ns;
       
    reg        wait_res;
    reg [12:0] wait_cnt;
    
    wire       wait_cnt_ovf;
    
    reg [31:0] byte3;
    reg [31:0] byte2;
    reg [31:0] byte1;
    reg [31:0] byte0;
    
    
    parameter S0  = 4'b0000;   //idle state
	parameter S1  = 4'b0001;
	parameter S2  = 4'b0010;
	parameter S3  = 4'b0011;
	parameter S4  = 4'b0100;
	parameter S5  = 4'b0101;
	parameter S6  = 4'b0110;
	parameter S7  = 4'b0111;
	parameter S8  = 4'b1000;
	parameter S9  = 4'b1001;
	parameter S10 = 4'b1010;
	parameter S11 = 4'b1011;
	parameter S12 = 4'b1100;
	parameter S13 = 4'b1101;
	parameter S14 = 4'b1110;
	parameter S15 = 4'b1111;
	
	
	
	assign wait_cnt_ovf=(wait_cnt==4339)?1:0;
	
	//next state update
	always @(posedge clock)
        if(reset)
            begin
                cs<=S0;
                //wait_res<=0;
            end
        else
            begin 
                cs<=ns;
            end
    always @(posedge clock)
        casex(cs)
            S0:
                begin
                    i_Tx_DV<=0;
                    i_Tx_Byte<=0;
                end
            //for Sending Byte 3    
            S1:
                begin                   
                    i_Tx_DV<=1;
                    i_Tx_Byte<=byte3[7:0];
                end
            S2:
                begin
                    i_Tx_DV<=0;
                    i_Tx_Byte<=byte3[7:0];
                end
            S3:
                begin
                    i_Tx_DV<=0;
                    i_Tx_Byte<=0;
                end
            //for Sending Byte 2    
            S4:
                begin
                    i_Tx_DV<=1;
                    i_Tx_Byte<=byte2[7:0];
                end
            S5:
                begin
                    i_Tx_DV<=0;
                    i_Tx_Byte<=byte2[7:0];
                end
            S6:
                begin
                    i_Tx_DV<=0;
                    i_Tx_Byte<=0;
                end  
            //for Sending Byte 1
            S7:
                begin
                    i_Tx_DV<=1;
                    i_Tx_Byte<=byte1[7:0];
                end
            S8:
                begin
                    i_Tx_DV<=0;
                    i_Tx_Byte<=byte1[7:0];
                end
            S9:
                begin
                    i_Tx_DV<=0;
                    i_Tx_Byte<=0;
                end
            //for Sending Byte 0
            S10:
                begin
                    i_Tx_DV<=1;
                    i_Tx_Byte<=byte0[7:0];
                end
            S11:
                begin
                    i_Tx_DV<=0;
                    i_Tx_Byte<=byte0[7:0];
                end
            S12:
                begin
                    i_Tx_DV<=0;
                    i_Tx_Byte<=0;
                end
            default:
                begin
                    i_Tx_DV<=0;
                    i_Tx_Byte<=0;
                end  
        endcase 
    
    always @(posedge clock)
        casex({cs,EN,o_Tx_Done,wait_cnt_ovf})
            7'b0000_0_x_x:
                begin
                    ns<=S0;                 
                end
            7'b0000_1_x_x:
                begin
                    byte3<=((word_to_send>>24)&32'h000000FF);
                    byte2<=((word_to_send>>16)&32'h000000FF);
                    byte1<=((word_to_send>> 8)&32'h000000FF);
                    byte0<=((word_to_send>> 0)&32'h000000FF);
                    Tx_NotDone<=1;
                    ns<=S1;
                end
            //for Sending Byte 3
            7'b0001_x_x_x:
                begin
                    ns<=S2;
                end
            7'b0010_x_0_x:
                begin
                    ns<=S2;
                end
            7'b0010_x_1_x:
                begin
                    wait_res<=1;
                    ns<=S3;
                end
            7'b0011_x_x_0:
                begin
                    wait_res<=0;
                    ns<=S3;
                end   
            7'b0011_x_x_1:
                begin
                    ns<=S4;
                end
           //for Sending Byte 2
            7'b0100_x_x_x:
                begin
                    ns<=S5;
                end
            7'b0101_x_0_x:
                begin
                    ns<=S5;
                end
            7'b0101_x_1_x:
                begin
                    wait_res<=1;
                    ns<=S6;
                end
            7'b0110_x_x_0:
                begin
                    wait_res<=0;
                    ns<=S6;
                end   
            7'b0110_x_x_1:
                begin
                    ns<=S7;
                end                
            //for Sending Byte 1
            7'b0111_x_x_x:
                begin
                    ns<=S8;
                end
            7'b1000_x_0_x:
                begin
                    ns<=S8;
                end
            7'b1000_x_1_x:
                begin
                    wait_res<=1;
                    ns<=S9;
                end
            7'b1001_x_x_0:
                begin
                    wait_res<=0;
                    ns<=S9;
                end   
            7'b1001_x_x_1:
                begin
                    ns<=S10;
                end
            //for Sending Byte 0
            7'b1010_x_x_x:
                begin
                    ns<=S11;
                end
            7'b1011_x_0_x:
                begin
                    ns<=S11;
                end
            7'b1011_x_1_x:
                begin
                    wait_res<=1;
                    ns<=S12;
                end
            7'b1100_x_x_0:
                begin
                    wait_res<=0;
                    ns<=S12;
                end   
            7'b1100_x_x_1:
                begin
                    ns<=S0;
                    Tx_NotDone<=0;
                end
            default:
                begin
                    ns<=S0;                 
                end            
        endcase
        
    always @(posedge clock)
    begin
        if(wait_res)
            wait_cnt<=0;
        else
            wait_cnt<=(wait_cnt<4339)?wait_cnt+1:0;
    end
    
endmodule

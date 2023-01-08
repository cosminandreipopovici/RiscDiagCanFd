`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2022 11:43:53 AM
// Design Name: 
// Module Name: SevenSegDisplay
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



module SevenSegDisplay(
    input clock,
    input reset,
    input [31:0] reg_in,
    output reg [7:0] sseg,
    output reg [7:0] sseg_an
    );
    
    reg [19:0] cnt;
    
    wire [7:0] segments_0,segments_1,segments_2,segments_3,segments_4,segments_5,segments_6,segments_7;
    
    function [7:0] dec_digit(input [3:0] bin_digit);
        begin
            casex(bin_digit)
                4'b0000: dec_digit = {1'b1,7'h40};
                4'b0001: dec_digit = {1'b1,7'h79};
                4'b0010: dec_digit = {1'b1,7'h24};
                4'b0011: dec_digit = {1'b1,7'h30};
               
                4'b0100: dec_digit = {1'b1,7'h19};
                4'b0101: dec_digit = {1'b1,7'h12};
                4'b0110: dec_digit = {1'b1,7'h02};
                4'b0111: dec_digit = {1'b1,7'h78};
                
                4'b1000: dec_digit = {1'b1,7'h00};
                4'b1001: dec_digit = {1'b1,7'h10};
                4'b1010: dec_digit = {1'b1,7'h08};
                4'b1011: dec_digit = {1'b1,7'h03};
                
                4'b1100: dec_digit = {1'b1,7'h46};
                4'b1101: dec_digit = {1'b1,7'h21};
                4'b1110: dec_digit = {1'b1,7'h06};
                4'b1111: dec_digit = {1'b1,7'h0E};
                
                default: dec_digit = {1'b1,7'h7F};
            endcase
        end
    endfunction
    
    assign segments_0=dec_digit(reg_in[31:28]);
    assign segments_1=dec_digit(reg_in[27:24]);
    assign segments_2=dec_digit(reg_in[23:20]);
    assign segments_3=dec_digit(reg_in[19:16]);
    assign segments_4=dec_digit(reg_in[15:12]);
    assign segments_5=dec_digit(reg_in[11:8] );
    assign segments_6=dec_digit(reg_in[7:4] );
    assign segments_7=dec_digit(reg_in[3:0] );
    
    always @(posedge clock)
    begin
        casex(cnt[19:17])
            3'b000: {sseg_an,sseg}={8'b01111111,segments_0};
            3'b001: {sseg_an,sseg}={8'b10111111,segments_1};
            3'b010: {sseg_an,sseg}={8'b11011111,segments_2};
            3'b011: {sseg_an,sseg}={8'b11101111,segments_3};
            3'b100: {sseg_an,sseg}={8'b11110111,segments_4};
            3'b101: {sseg_an,sseg}={8'b11111011,segments_5};
            3'b110: {sseg_an,sseg}={8'b11111101,segments_6};
            3'b111: {sseg_an,sseg}={8'b11111110,segments_7};
            default:{sseg_an,sseg}={8'b11111111,segments_0};
        endcase
    end
    
    always @(posedge clock)
    begin
        if(reset)
            cnt<=0;
        else
            cnt<=(cnt<20'hFFFFF)?cnt+1:0;
    end
    
endmodule

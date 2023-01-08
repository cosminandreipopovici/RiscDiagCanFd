`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2022 01:15:08 AM
// Design Name: 
// Module Name: shift_module
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


module shift_module(
    input [31:0] op1,
    input [31:0] op2,
    output reg [31:0] res_L,
    output reg [31:0] res_R
    );
    
    always @(op1 or op2)
        begin
            res_L<=(op1<<op2);
            res_R<=(op1>>op2);
        end
endmodule

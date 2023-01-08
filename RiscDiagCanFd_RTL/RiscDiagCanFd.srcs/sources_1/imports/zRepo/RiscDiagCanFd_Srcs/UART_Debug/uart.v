`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2022 11:00:48 PM
// Design Name: 
// Module Name: uart
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


module uart(
    input i_Clock,
    input i_Tx_DV,
    input [7:0] i_Tx_Byte,
    output o_Tx_Done,
    output o_Tx_Serial,
    input i_Rx_Serial,
    output o_Rx_DV,
    output [7:0] o_Rx_Byte
    );
    
    uart_tx #(.CLKS_PER_BIT(109)) UART_TX_Ctrl
    (
        .i_Clock(i_Clock),
        .i_Tx_DV(i_Tx_DV),
        .i_Tx_Byte(i_Tx_Byte),
        .o_Tx_Serial(o_Tx_Serial),
        .o_Tx_Active(),
        .o_Tx_Done(o_Tx_Done)
    );
    
    uart_rx #(.CLKS_PER_BIT(109)) UART_RX_Ctrl
    (
        .i_Clock(i_Clock),
        .i_Rx_Serial(i_Rx_Serial),
        .o_Rx_DV(o_Rx_DV),
        .o_Rx_Byte(o_Rx_Byte)   
    );
    
    
endmodule

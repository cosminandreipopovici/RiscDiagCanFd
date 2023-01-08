`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2022 08:44:34 PM
// Design Name: 
// Module Name: UartDebugger
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


module UartDebugger(
    input reset,
    input clock,
    input uart_rx,
    output uart_tx,
    
    output reset_out_riscv,
    
    output        datamem_enbl,
    output [15:0] datamem_addr,
    output [31:0] datamem_wdat,
    input  [31:0] datamem_rdat,
    
    output        progmem_enbl,
    output [15:0] progmem_addr,
    output [31:0] progmem_wdat,
    input  [31:0] progmem_rdat
    
    );
        
    parameter RD_DATA_MEM = 8'hA1;
    parameter WR_DATA_MEM = 8'hA2;
    
    parameter RD_PROG_MEM = 8'hB1;
    parameter WR_PROG_MEM = 8'hB2;
    parameter FLASH_START = 8'hB5;
    parameter FLASH_STOPP = 8'hB6;
    
    reg [4:0] cs,ns;
    
    wire i_Tx_DV;
    wire [7:0] i_Tx_Byte;
    wire o_Tx_Done;
    
    wire [7:0] o_Rx_Byte;
    wire o_Rx_DV;
    
    wire [31:0] word_to_send;
    wire send_word_on;
    
    wire [3:0] lt_cs;
    
    wire Tx_NotDone;
    
    wire [7:0]  comm_type;
    wire [15:0] comm_addr;
    wire [31:0] comm_data;
    wire        comm_comt;
    
    uart Uart_RX_TX_Ctrl(
        .i_Clock(clock),
        .i_Tx_DV(i_Tx_DV),
        .i_Tx_Byte(i_Tx_Byte),
        .o_Tx_Done(o_Tx_Done),
        .o_Tx_Serial(uart_tx),
        .i_Rx_Serial(uart_rx), 
        .o_Rx_DV(o_Rx_DV),
        .o_Rx_Byte(o_Rx_Byte)
    );
      
    CommandTranslator Command_Translator(
        .reset(reset),
        .clock(clock),
        .o_Rx_DV(o_Rx_DV),
        .o_Rx_Byte(o_Rx_Byte),
        .comm_comt(comm_comt),
        .comm_type(comm_type),
        .comm_addr(comm_addr),
        .comm_data(comm_data)
    );
    
    UWORDsender UART_Word_Sender(
        .reset(reset),
        .clock(clock),
        .word_to_send(word_to_send),
        .EN(send_word_on),
        .o_Tx_Done(o_Tx_Done),
        .i_Tx_DV(i_Tx_DV),
        .i_Tx_Byte(i_Tx_Byte),
        .Tx_NotDone(Tx_NotDone)
    );
    
    Debugger Dbgr(
        .clock(clock),
        .comm_comt(comm_comt),
        .comm_type(comm_type),
        .comm_addr(comm_addr),
        .comm_data(comm_data),
        .datamem_enbl(datamem_enbl),
        .datamem_addr(datamem_addr),
        .datamem_wdat(datamem_wdat),
        .datamem_rdat(datamem_rdat),
        .progmem_enbl(progmem_enbl),
        .progmem_addr(progmem_addr),
        .progmem_wdat(progmem_wdat),
        .progmem_rdat(progmem_rdat),
        .reset_out_riscv(reset_out_riscv),
        .send_word_on(send_word_on),
        .word_to_send(word_to_send)
    );
    
endmodule

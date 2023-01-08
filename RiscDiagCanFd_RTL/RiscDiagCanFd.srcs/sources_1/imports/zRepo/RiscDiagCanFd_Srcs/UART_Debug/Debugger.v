`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2022 01:15:28 PM
// Design Name: 
// Module Name: Debugger
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


module Debugger(
    input clock,
    input comm_comt,
    input [7:0] comm_type,
    input [15:0] comm_addr,
    input [31:0] comm_data,
    output reg datamem_enbl,
    output reg [15:0] datamem_addr,
    output reg [31:0] datamem_wdat,
    input [31:0] datamem_rdat,
    output reg progmem_enbl,
    output reg [15:0] progmem_addr,
    output reg [31:0] progmem_wdat,
    input [31:0] progmem_rdat,
    
    output reg reset_out_riscv,
    
    output reg send_word_on,
    output reg [31:0] word_to_send
    
    );
    
    parameter RD_DATA_MEM = 8'hA1;
    parameter WR_DATA_MEM = 8'hA2;
    
    parameter RD_PROG_MEM = 8'hB1;
    parameter WR_PROG_MEM = 8'hB2;
    
    parameter FLASH_START = 8'hB5;
    parameter FLASH_STOPP = 8'hB6;
    
    reg send_on;
    reg [7:0] type;
    
    /*reg reset_out_riscv_reg;*/
    
    /*always @(posedge clock)
        reset_out_riscv<=reset_out_riscv_reg;*/
    
    always @(posedge clock)
    //always @(comm_comt or comm_type)
    begin
        
        casex({comm_comt,comm_type})
            {1'b0,8'hxx}:  
                begin                    
                    datamem_enbl<=0;
                    datamem_addr<=0;
                    datamem_wdat<=0;
                    progmem_enbl<=0;
                    progmem_addr<=0;
                    progmem_wdat<=0;
                    
                    reset_out_riscv<=0;
                    send_on<=0;
                    type<=0;
                end
           {1'b1,WR_DATA_MEM}:
                begin
                    datamem_enbl<=1;
                    datamem_addr<=comm_addr;
                    datamem_wdat<=comm_data;
                    progmem_enbl<=0;
                    progmem_addr<=0;
                    progmem_wdat<=0;

                    send_on<=1;
                    type<=comm_type;
                end
            {1'b1,WR_PROG_MEM}:
                begin
                    datamem_enbl<=0;
                    datamem_addr<=0;
                    datamem_wdat<=0;
                    progmem_enbl<=1;
                    progmem_addr<=comm_addr;
                    progmem_wdat<=comm_data;

                    send_on<=1;
                    type<=comm_type;
                end
            {1'b1,RD_DATA_MEM}:
                begin
                    datamem_enbl<=0;
                    datamem_addr<=comm_addr;
                    datamem_wdat<=0;
                    progmem_enbl<=0;
                    progmem_addr<=0;
                    progmem_wdat<=0;

                    send_on<=1;
                    type<=comm_type;
                end
            {1'b1,RD_PROG_MEM}:
                begin
                    datamem_enbl<=0;
                    datamem_addr<=0;
                    datamem_wdat<=0;
                    progmem_enbl<=0;
                    progmem_addr<=comm_addr;
                    progmem_wdat<=0;

                    send_on<=1;
                    type<=comm_type;
                end
            {1'b1,FLASH_START}:
                begin
                    datamem_enbl<=0;
                    datamem_addr<=0;
                    datamem_wdat<=0;
                    progmem_enbl<=0;
                    progmem_addr<=0;
                    progmem_wdat<=0;
                    
                    reset_out_riscv<=1;
                    
                    send_on<=1;
                    type<=comm_type;
                end
            {1'b1,FLASH_STOPP}:
                begin
                    datamem_enbl<=0;
                    datamem_addr<=0;
                    datamem_wdat<=0;
                    progmem_enbl<=0;
                    progmem_addr<=0;
                    progmem_wdat<=0;
                    
                    reset_out_riscv<=0;
                    
                    send_on<=1;
                    type<=comm_type;
                end
            default:
                begin
                    datamem_enbl<=0;
                    datamem_addr<=0;
                    datamem_wdat<=0;
                    progmem_enbl<=0;
                    progmem_addr<=0;
                    progmem_wdat<=0;

                    send_on<=0;
                    type<=8'h00;
                end
        endcase
    end        
    
    always @(posedge clock)
    begin
        casex({send_on,type})
            {1'b0,8'hxx}:{send_word_on,word_to_send}={1'b0,32'h00000000};
            {1'b1,WR_DATA_MEM}:{send_word_on,word_to_send}={1'b1,WR_DATA_MEM[3:0],WR_DATA_MEM[7:4],24'hCA1196};
            {1'b1,WR_PROG_MEM}:{send_word_on,word_to_send}={1'b1,WR_PROG_MEM[3:0],WR_PROG_MEM[7:4],24'hCA1196};
            {1'b1,RD_DATA_MEM}:{send_word_on,word_to_send}={1'b1,datamem_rdat};
            {1'b1,RD_PROG_MEM}:{send_word_on,word_to_send}={1'b1,progmem_rdat};
            {1'b1,FLASH_START}:{send_word_on,word_to_send}={1'b1,FLASH_START[3:0],FLASH_START[7:4],24'hCA1196};
            {1'b1,FLASH_STOPP}:{send_word_on,word_to_send}={1'b1,FLASH_STOPP[3:0],FLASH_STOPP[7:4],24'hCA1196};
            default:{send_word_on,word_to_send}={1'b0,32'h00000000};
        endcase
    end
    
endmodule

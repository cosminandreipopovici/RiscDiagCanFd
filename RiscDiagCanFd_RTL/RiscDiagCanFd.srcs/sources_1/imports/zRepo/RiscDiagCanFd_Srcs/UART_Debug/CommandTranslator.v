`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2022 04:38:15 PM
// Design Name: 
// Module Name: CommandTranslator
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


module CommandTranslator(
    input clock,
    input reset,
    input o_Rx_DV,
    input [7:0] o_Rx_Byte,
    output reg        comm_comt,
    output reg [7:0]  comm_type,
    output reg [15:0] comm_addr,
    output reg [31:0] comm_data
    );
    
    reg       DV;
    reg [7:0] Byte;
    
    reg [7:0] BytesReceived [0:7];
    reg [4:0] BytesCounter;
    integer i;
    
    reg started;
    
    always @(o_Rx_DV or o_Rx_Byte)
    begin
        DV<=o_Rx_DV;
        Byte<=o_Rx_Byte;
    end
    
    always @(posedge clock)
    begin
        if(reset==1)
            begin
                BytesCounter<=0;
                started<=0;
                for(i=0;i<8;i=i+1)
                    begin
                        BytesReceived[i]<=8'h00;
                    end    
                comm_comt<=0;
                comm_type<=8'h00;
                comm_addr<=16'h0000;
                comm_data<=32'h00000000;
            end
        else
            begin
                if(o_Rx_DV==1 && BytesCounter<8)
                    begin
                        BytesReceived[BytesCounter]=o_Rx_Byte;
                        BytesCounter=BytesCounter+1; 
                    end               
                else if(BytesCounter==8)
                    begin
                        comm_comt<=1; 
                        comm_type<=BytesReceived[0];
                        comm_addr[15:8]<=BytesReceived[1];
                        comm_addr[7:0]<=BytesReceived[2];
                        comm_data[31:24]<=BytesReceived[3];
                        comm_data[23:16]<=BytesReceived[4];
                        comm_data[15:8]<=BytesReceived[5];
                        comm_data[7:0]<=BytesReceived[6];
                        BytesCounter<=9;
                    end
                else if(BytesCounter==9)
                    begin
                        started<=0;
                        comm_comt<=0;
                        comm_type<=8'h00;
                        comm_addr<=16'h0000;
                        comm_data<=32'h00000000;
                        BytesCounter<=0;
                        for(i=0;i<8;i=i+1)
                            begin
                                BytesReceived[i]<=8'h00;
                            end
                    end
            end
    end
    
    /*parameter S_IDLE_WAITING = 3'b000;
    parameter S_WAITING_ONEE = 3'b001;
    parameter S_WAITING_ZERO = 3'b010;
    parameter S_OVEEERFLOOOW = 3'b011;
    
    reg [3:0] cs,ns;
    
    wire ovf;
    
    assign ovf=(BytesCounter==8)?1:0;
    
    always @(posedge clock)
    begin
        if(reset) 
            cs<=S_IDLE_WAITING;
        else      
            cs<=ns;
    end
    
    always @(posedge clock)
    begin
        casex(cs)
            S_OVEEERFLOOOW:
                begin
                    comm_comt<=1;
                    comm_type<=BytesReceived[0];
                    comm_addr[15:8]<=BytesReceived[1];
                    comm_addr[7:0]<=BytesReceived[2];
                    comm_data[31:24]<=BytesReceived[3];
                    comm_data[23:16]<=BytesReceived[4];
                    comm_data[15:8]<=BytesReceived[5];
                    comm_data[7:0]<=BytesReceived[6];
                end
            default:
                begin
                    comm_comt<=0;
                    comm_type<=8'h00;
                    comm_addr<=16'h0000;
                    comm_data<=32'h00000000;
                end   
        endcase
    end
    
    always @(cs or o_Rx_DV)
    begin
        casex({cs,o_Rx_DV,ovf})
            {S_IDLE_WAITING,1'b0,1'bx}:
                begin
                    BytesCounter<=0;
                    ns<=S_IDLE_WAITING;
                end
            {S_IDLE_WAITING,1'b1,1'bx}:
                begin
                    //BytesCounter<=1;
                    BytesReceived[0]<=o_Rx_Byte;
                    ns<=S_WAITING_ZERO;
                end
            
            {S_WAITING_ZERO,1'b1,1'bx}:
                begin
                    ns<=S_WAITING_ZERO;
                end
            {S_WAITING_ZERO,1'b0,1'bx}:
                begin
                    BytesCounter<=BytesCounter+1;
                    ns<=S_WAITING_ONEE;
                end
            {S_WAITING_ONEE,1'bx,1'b1}:
                begin
                    ns<=S_OVEEERFLOOOW;
                end        
            {S_WAITING_ONEE,1'b0,1'b0}:
                begin
                    ns<=S_WAITING_ONEE;
                end
            {S_WAITING_ONEE,1'b1,1'b0}:
                begin
                    BytesReceived[BytesCounter]<=o_Rx_Byte;
                    ns<=S_WAITING_ZERO;
                end
            
            {S_OVEEERFLOOOW,1'bx,1'bx}:
                begin
                    ns<=S_IDLE_WAITING;
                end    
        endcase
    end*/
    
    
    
    
endmodule

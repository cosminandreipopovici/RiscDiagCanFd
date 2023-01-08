`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2022 09:29:54 PM
// Design Name: 
// Module Name: canfd_unit
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


module canfd_unit(
    input clock,
    input reset,
    
    input can_rx,
    output can_tx,
    
    input        cfd_enb,
    input [6:0]  cfd_fct,
    input [31:0] cfd_op1,
    input [31:0] cfd_op2,
    
    output reg        datamem_write_en,
    output reg [31:0] datamem_write_data,  
    output reg [11:0] datamem_write_address, //width will be modified after modifying Data Memory Width
    
    output reg        udpmem_write_en,
    output reg [31:0] udpmem_write_data,
    output reg [ 4:0] udpmem_write_address,
    output     [ 7:0] erc_capture_out,
    output            erc_int
    /*
    output reg [4:0] lt_cs,    //for debug
    output dat16,              //for debug
    output reg [4:0] rwcnt_out //for debug */
    );
    
    parameter S0  = 5'b00000;   //idle state
	parameter S1  = 5'b00001;
	parameter S2  = 5'b00010;
	parameter S3  = 5'b00011;
	parameter S4  = 5'b00100;
	parameter S5  = 5'b00101;
	parameter S6  = 5'b00110;
	parameter S7  = 5'b00111;
	parameter S8  = 5'b01000;
	parameter S9  = 5'b01001;
	parameter S10 = 5'b01010;
	parameter S11 = 5'b01011;
	parameter S12 = 5'b01100;
	parameter S13 = 5'b01101;
	parameter S14 = 5'b01110;
	parameter S15 = 5'b01111;
	parameter S16 = 5'b10000;
	parameter S17 = 5'b10001;
	parameter S18 = 5'b10010;
	parameter S19 = 5'b10011;
	parameter S20 = 5'b10100;
	parameter S21 = 5'b10101;
	parameter S22 = 5'b10110;
	parameter S23 = 5'b10111;
	parameter S24 = 5'b11000;
	parameter S25 = 5'b11001;
	parameter S26 = 5'b11010;
	parameter S27 = 5'b11011;
	parameter S28 = 5'b11100;
	parameter S29 = 5'b11101;
	parameter S30 = 5'b11110;
	parameter S31 = 5'b11111;
    
    wire res;
    
    wire res_n;
    wire res_n_out;
    wire scan_enable;
    
    reg [31:0] data_in;
    wire [31:0] data_out;
    reg [15:0] adress;
    reg scs;
    reg srd;
    reg swr;
    reg [3:0] sbe;
    
    wire int;
    
    wire [2:0] test_probe;
    wire [63:0] timestamp;
    
    wire data_out_16;
       
    reg [4:0] ns;
    reg [4:0] cs;
    
    wire bus_integration_started;
    reg integration_state_passed;
    
    wire rx_fr_rec;
    
    reg [31:0] reg_op1;
    reg [31:0] reg_op2;
    
    reg [31:0] NBR;
    reg [31:0] DBR;
    
    reg [31:0] mode;
    
    reg [31:0] ID;
    reg [31:0] fformat;
    
    reg [31:0] t_L;
    reg [31:0] t_U;
    
    reg [31:0] payload_addr;
    reg [31:0] payload_data;
    
    reg [31:0] tx_command;
    
    reg [63:0] tclk_cnt;
    
    //reg        waiting_rx_active;
    reg [4:0]  frame_cnt;
    reg [4:0]  frame_lim;
    
    wire frame_ovf;
    
    reg [31:0] frame_content [0:20];
    reg  [4:0] frame_content_cnt;
    
    wire [31:0] rwcnt;
    
    wire [7:0] erc_capture_val;
    
    reg [16:0] error_timer_counter;
    reg        error_timer_inc;
    reg        error_timer_res;
    wire       error_timer_ovf;
    wire       error_send_allowed;
    
    can_top_level canfdctrl(
        .clk_sys(clock),
        .res_n(res_n),
        .res_n_out(res_n_out),
        .scan_enable(scan_enable),
        .data_in(data_in),
        .data_out(data_out),
        .adress(adress),
        .scs(scs),
        .srd(srd),
        .swr(swr),
        .sbe(sbe),
        .int(int),
        //.int(erc_int),
        .can_tx(can_tx),
        .can_rx(can_rx),
        .test_probe(test_probe),
        //.timestamp(timestamp)
        .timestamp(tclk_cnt),
        .erc_capture_out(erc_capture_val)       
    );
    //reg [7:0] tclk_cnt;
    
    assign res_n=1;
    assign scan_enable=0;
    //assign timestable=0;
    assign res=(~(reset));
    assign bus_integration_started=data_out[16];
    assign dat16=bus_integration_started;
    
    assign rx_fr_rec=(data_out[0]==0)?1:0;
    
    assign rwcnt=((data_out>>11)&32'h0000001F);
    
    //assign frame_ovf=(frame_cnt==(frame_lim-1))?1:0;
    assign frame_ovf=(frame_cnt==frame_lim)?1:0;
    
    assign erc_int=int;
    
    assign erc_capture_out=erc_capture_val;
    
    assign error_timer_ovf=(error_timer_counter>=99998);
    assign error_send_allowed=((error_timer_inc==0) && (error_timer_counter==0));
    
    always @(posedge clock)
        if(res)
            begin
                cs<=S0;
            end
        else
            begin
                cs<=ns;
            end
    
    //always @(cs)
    always @(posedge clock)
        casex(cs)
            S0  :  //idle state (when none instruction is issued to the CANFD unit)
                begin
                    {swr,srd,scs}<=3'b0_0_0;
                    sbe     <= 4'b0000;
                    adress  <= 16'b0000_0000_0000_0000;
                    data_in <= 32'b0000_0000__0000_0000__0000_0000__0000_0000;
                    datamem_write_en<=0;
                    datamem_write_data<=0;
                    datamem_write_address<=0;
                    udpmem_write_en<=0;
                    udpmem_write_address<=0;
                    udpmem_write_data<=0;
                end
            //*****************************************************************************************
            S1  : //Software Reset issued to CANFD unit , fct=0000001
                begin
                    {swr,srd,scs}<=3'b1_0_1;
                    sbe     <= 4'b0001;
                    adress  <= 16'b0000_0000_0000_0100;
                    data_in <= 32'b0000_0000__0000_0000__0000_0000__0000_0001;
                end
            S23  : //Enable BEI=Bus Error Interrupt 
                begin
                    {swr,srd,scs}<=3'b1_0_1;
                    sbe     <= 4'b0001;
                    adress  <= 16'b0000_0000_0001_0100;
                    data_in <= 32'b0000_0000__0000_0000__0000_0000__0100_0000;
                end
            //*****************************************************************************************    
            S2  :  //Set NBR and issued to CANFD_UNIT, fct=0000010
                begin
                    {swr,srd,scs}<=3'b1_0_1;
                    sbe     <= 4'b1111;
                    adress  <= 16'b0000_0000_0010_0100;
                    data_in <= NBR;
                    datamem_write_en<=1;
                    datamem_write_data<=NBR;
                    datamem_write_address<=12'h040;
                    //data_in <= reg_op1; //NBR
                    //data_in <= 32'h5011451D; //NBR
                end
            S3  :  //Set DBR issued to CANFD_UNIT, fct=0000010
                begin
                    {swr,srd,scs}<=3'b1_0_1;
                    sbe     <= 4'b1111;
                    adress  <= 16'b0000_0000_0010_1000;
                    data_in <= DBR;
                    datamem_write_en<=1;
                    datamem_write_data<=DBR;
                    datamem_write_address<=12'h041;
                    //data_in <= reg_op2; //DBR
                    //data_in <= 32'h5008A28E; //DBR
                end
            //*******************************************************************************************         
            /*S4  :  //Setting modes
                begin
                    {swr,srd,scs}<=3'b1_0_1;
                    sbe     <= 4'b0001;
                    adress  <= 16'b0000_0000_0000_0100;
                    data_in <= mode;
                    //data_in <= reg_op1; //Modes
                    //data_in <= 32'b0000_0000__0000_0000__0000_0000__0001_0000; //Modes
                end*/
            S4  :  //Setting modes
                begin
                    {swr,srd,scs}<=3'b1_0_1;
                    sbe     <= 4'b0011;
                    adress  <= 16'b0000_0000_0000_0100;
                    data_in <= mode;
                    datamem_write_en<=1;
                    datamem_write_data<=mode;
                    datamem_write_address<=12'h042;
                    //data_in <= reg_op1; //Modes
                    //data_in <= 32'b0000_0000__0000_0000__0000_0000__0001_0000; //Modes
                end      
            S5  :  //Enabling settings
                begin
                    {swr,srd,scs}<=3'b1_0_1;
                    sbe     <= 4'b0100;
                    adress  <= 16'b0000_0000_0000_0100;
                    data_in <= 32'b0000_0000__0100_0000__0000_0000__0000_0000; //EnableSettings
                    
                end
            S6  :  //Check fault state - bus integration active
                begin
                    {swr,srd,scs}<=3'b0_1_1;
                    sbe     <= 4'b1111;
                    adress  <= 16'b0000_0000_0010_1100;
                    data_in <= 32'b0000_0000__0000_0000__0000_0000__0000_0000;
                end
            S7  :  //idle state for checking integration status
                begin
                    {swr,srd,scs}<=3'b0_0_0;
                    sbe     <= 4'b0000;
                    adress  <= 16'b0000_0000_0000_0000;
                    data_in <= 32'b0000_0000__0000_0000__0000_0000__0000_0000;
                end 
            S8  :  //idle state for checking integration status
                begin
                    {swr,srd,scs}<=3'b0_0_0;
                    sbe     <= 4'b0000;
                    adress  <= 16'b0000_0000_0000_0000;
                    data_in <= 32'b0000_0000__0000_0000__0000_0000__0000_0000;
                    
                    integration_state_passed<=1;
                    
                    datamem_write_en<=1;
                    datamem_write_data<=1;
                    datamem_write_address<=21;
                end
            //*********************************************************************************
            S9  :  //Set Frame Format and issued to CANFD_UNIT, fct=0000011
                begin
                    {swr,srd,scs}<=3'b1_0_1;
                    sbe     <= 4'b0011;
                    adress  <= 16'b0000_0001_0000_0000;
                    data_in <= fformat;
                    datamem_write_en<=1;
                    datamem_write_data<=fformat;
                    datamem_write_address<=12'h043; 
                end
            S10 :  //Set ID issued to CANFD_UNIT, fct=0000010
                begin
                    {swr,srd,scs}<=3'b1_0_1;
                    sbe     <= 4'b1111;
                    adress  <= 16'b0000_0001_0000_0100;
                    data_in <= ID; 
                end       
           //**********************************************************************************
            S11  :  //Set timestamp L
                begin
                    {swr,srd,scs}<=3'b1_0_1;
                    sbe     <= 4'b1111;
                    adress  <= 16'b0000_0001_0000_1000;
                    data_in <= t_L;
                    datamem_write_en<=1;
                    datamem_write_data<=t_L;
                    datamem_write_address<=12'h044; 
                end
            S12 :  //Set timestamp U
                begin
                    {swr,srd,scs}<=3'b1_0_1;
                    sbe     <= 4'b1111;
                    adress  <= 16'b0000_0001_0000_1100;
                    data_in <= t_U;
                    datamem_write_en<=1;
                    datamem_write_data<=t_U;
                    datamem_write_address<=12'h045;
                end       
           //**********************************************************************************
           S13 :  //Set bytes with offset
                begin
                    {swr,srd,scs}<=3'b1_0_1;
                    sbe     <= 4'b1111;
                    adress  <= payload_addr;
                    data_in <= payload_data; //4 bytes
                    //datamem_write_en<=1;
                    //datamem_write_data<=payload_data;
                    //datamem_write_address<=12'h046+payload_addr[11:0]-12'h110;
                end
           //**********************************************************************************
           S14 :  //Set frame ready to send
                begin
                    {swr,srd,scs}<=3'b1_0_1;
                    sbe     <= 4'b0011;
                    adress  <= 16'b0000_0000_0111_0100;
                    data_in <= 32'b0000_0000__0000_0000__0000_0001__0000_0010; //4 bytes
                end
          //***********************************************************************************
          S15 :  //Read RX status
                begin
                    {swr,srd,scs}<=3'b0_1_1;
                    sbe     <= 4'b1111;
                    adress  <= 16'b0000_0000_0110_1000;
                    data_in <= 32'b0000_0000__0000_0000__0000_0000__0000_0000;
                end
          S16 :  //Check RX status 
                begin
                    {swr,srd,scs}<=3'b0_0_0;
                    sbe     <= 4'b0000;
                    adress  <= 16'b0000_0000_0000_0000;
                    data_in <= 32'b0000_0000__0000_0000__0000_0000__0000_0000; 
                end
          S17 :  //Read RX data
                begin
                    {swr,srd,scs}<=3'b0_1_1;
                    sbe     <= 4'b1111;
                    adress  <= 16'b0000_0000_0110_1100;
                    data_in <= 32'b0000_0000__0000_0000__0000_0000__0000_0000; 
                end
          S18 :  //Reset reading registers 
                begin
                    {swr,srd,scs}<=3'b0_0_0;
                    sbe     <= 4'b0000;
                    adress  <= 16'b0000_0000_0000_0000;
                    data_in <= 32'b0000_0000__0000_0000__0000_0000__0000_0000; 
                    frame_cnt<=0;
                    frame_lim<=rwcnt[4:0];
                    frame_content[0]<=data_out;                 
                    //rwcnt_out<=rwcnt[4:0];
                    
                    datamem_write_en<=1;
                    datamem_write_address<=0;
                    datamem_write_data<=data_out;
                    
                    udpmem_write_en<=1;
                    udpmem_write_address<=0;
                    udpmem_write_data<=data_out;
                end
                
          S19 :  //Read data chunk x 
                begin
                    {swr,srd,scs}<=3'b0_1_1;
                    sbe     <= 4'b1111;
                    adress  <= 16'b0000_0000_0110_1100;
                    data_in <= 32'b0000_0000__0000_0000__0000_0000__0000_0000; 
                    frame_cnt<=frame_cnt+1;                    
                end
          S20 :  //Store data chunk x 
                begin
                    {swr,srd,scs}<=3'b0_0_0;
                    sbe     <= 4'b0000;
                    adress  <= 16'b0000_0000_0000_0000;
                    data_in <= 32'b0000_0000__0000_0000__0000_0000__0000_0000; 
                    frame_content[frame_cnt]<=data_out;
                    
                    datamem_write_en<=1;
                    datamem_write_address<=frame_cnt;
                    datamem_write_data<=data_out;
                    
                    udpmem_write_en<=1;
                    udpmem_write_address<=frame_cnt;
                    udpmem_write_data<=data_out;
                end
                
          S21 :  //Store data chunk x 
                begin
                    {swr,srd,scs}<=3'b0_0_0;
                    sbe     <= 4'b0000;
                    adress  <= 16'b0000_0000_0000_0000;
                    data_in <= 32'b0000_0000__0000_0000__0000_0000__0000_0000; 
                    
                    datamem_write_en<=1;
                    datamem_write_data<=37;
                    datamem_write_address<=20;
                    
                    udpmem_write_en<=1;
                    udpmem_write_address<=20;
                    udpmem_write_data<=32'hA0A0A0A0;
                end
          S24 :  //Send error code to UDP Server
                begin
                    {swr,srd,scs}<=3'b0_0_0;
                    sbe     <= 4'b0000;
                    adress  <= 16'b0000_0000_0000_0000;
                    data_in <= 32'b0000_0000__0000_0000__0000_0000__0000_0000; 
                    
                    datamem_write_en<=0;
                    datamem_write_data<=0;
                    datamem_write_address<=0;
                    
                    udpmem_write_en<=((error_send_allowed==1)?1:0);
                    udpmem_write_address<=((error_send_allowed==1)?20:0);
                    udpmem_write_data<=((error_send_allowed==1)?{8'hB0,erc_capture_val,16'h0000}:32'h00000000);
                    
                    /*tcpmem_write_en<=1;
                    tcpmem_write_address<=20;
                    tcpmem_write_data<={8'hB0,erc_capture_val,16'h0000};*/
                    
                end
          S25 :  //Clear Interrupt Cause (the Bus Error)
                begin
                    {swr,srd,scs}<=3'b1_0_1;
                    sbe     <= 4'b0011;
                    adress  <= 16'b0000_0000_0010_0000;
                    data_in <= 32'b0000_0000__0000_0000__0000_1111__1111_1111; 
                    
                    datamem_write_en<=0;
                    datamem_write_data<=0;
                    datamem_write_address<=0;
                    
                    udpmem_write_en<=0;
                    udpmem_write_address<=0;
                    udpmem_write_data<=0;
                end
          //******************************************************************
          S22 :  //Store data chunk x 
                begin
                    {swr,srd,scs}<=3'b1_0_1;
                    sbe     <= 4'b0100;
                    adress  <= 16'b0000_0000_0000_0100;
                    data_in <= 32'b0000_0000__0000_0000__0000_0000__0000_0000; 
                    
                    integration_state_passed<=0;
                    
                    datamem_write_en<=1;
                    datamem_write_address<=21;
                    datamem_write_data<=0;
                end  
  
          //***********************************************************************************
          default:
            begin
                {swr,srd,scs}<=3'b0_0_0;
                    sbe     <= 4'b0000;
                    adress  <= 16'b0000_0000_0000_0000;
                    data_in <= 32'b0000_0000__0000_0000__0000_0000__0000_0000;
                    datamem_write_en<=0;
                    datamem_write_data<=0;
                    datamem_write_address<=0;
                    udpmem_write_en<=0;
                    udpmem_write_address<=0;
                    udpmem_write_data<=0;                              
            end
        endcase
    
    //always caching the cfd_op1 and cfd_op2 operands
    /*always @(posedge clock)
    begin
        reg_op1<=cfd_op1;
        reg_op2<=cfd_op2;
    end*/
    
    //fct == 0000001 -> cfd_swrst
    //fct == 0000010 -> cfd_sndbr
    //fct == 0000011 -> cfd_smden
    //fct == 0000100 -> cfd_sfmid
    //fct == 0000101 -> cfd_ststp
    //fct == 0000110 -> cfd_sbyts
    //fct == 0000111 -> cfd_ssend
    
    //fct == 0001000 -> cfd_enbrx
    
    //fct == 1111111 -> cdf_disbl
        
    //always @(cs or cfd_enb or cfd_fct or bus_integration_started or integration_state_passed)
    always @(posedge clock)
        casex({cs , cfd_enb , cfd_fct , bus_integration_started , integration_state_passed , rx_fr_rec , frame_ovf, int})
            
            18'b00000_0_xxxxxxx_x_x_x_x_x: 
                begin
                    ns<=S0;
                end
            //**********************************************************************************    
            18'b00000_1_0000001_x_x_x_x_x:  //S0->S1 for SW Reseting
                begin
                    ns<=S1;
                end
            
            18'b00001_x_xxxxxxx_x_x_x_x_x:  //S1->S23
                begin
                    ns<=S23;
                end
            18'b10111_x_xxxxxxx_x_x_x_x_x:  //S23->S0
                begin
                    ns<=S0;
                end
            
            /*18'b00001_x_xxxxxxx_x_x_x_x_x:  //S1->S0
                begin
                    ns<=S0;
                end*/
           //********************************************************************************** 
           18'b00000_1_0000010_x_x_x_x_x:  //S0->S2  for configuring NBR
                begin
                    ns<=S2;
                    NBR<=cfd_op1;
                    DBR<=cfd_op2;
                end     
           18'b00010_x_xxxxxxx_x_x_x_x_x:  //S2->S3  for configuring DBR
                begin
                    ns<=S3;
                end
           18'b00011_x_xxxxxxx_x_x_x_x_x:  //S3->S0  for returning to IDLE
                begin
                    ns<=S0;
                end
           //********************************************************************************** 
           18'b00000_1_0000011_x_x_x_x_x:  //S0->S4  for configuring modes HS/FD , PEX, TTM
                begin
                    ns<=S4;
                    mode<=cfd_op1;
                    //reg_op2<=cfd_op2;
                end
           18'b00100_x_xxxxxxx_x_x_x_x_x:  //S4->S5  for returning enabling settings
                begin
                    ns<=S5;
                end
           18'b00101_x_xxxxxxx_x_x_x_x_x:  //S5->S6  for checking integration status
                begin
                    ns<=S6;
                end
           18'b00110_x_xxxxxxx_x_x_x_x_x:  //S6->S7  for reading integration status value
                begin
                    ns<=S7;
                end
           18'b00111_x_xxxxxxx_0_x_x_x_x:  
                begin
                    ns<=S6;
                end
           18'b00111_x_xxxxxxx_1_x_x_x_x:  
                begin
                    ns<=S8;
                end 
           18'b01000_x_xxxxxxx_x_x_x_x_x:  
                begin
                    ns<=S0;
                end 
           //**********************************************************************************
           18'b00000_1_0000100_x_1_x_x_x:  //S0->S9  for configuring frame format
                begin
                    ns<=S9;
                    fformat <= cfd_op1;
                    ID      <= cfd_op2;
                end
           18'b01001_x_xxxxxxx_x_1_x_x_x:  //S9->S10  for configuring frame ID
                begin
                    ns<=S10;
                end
           18'b01010_x_xxxxxxx_x_1_x_x_x:  //going back to idle
                begin
                    ns<=S0;
                end
           //************************************************************************************
           18'b00000_1_0000101_x_1_x_x_x:  //S0->S11  for configuring timestamp L
                begin
                    ns<=S11;
                    t_L<=cfd_op1;
                    t_U<=cfd_op2;
                end
           18'b01011_x_xxxxxxx_x_1_x_x_x:  //S11->S12  for configuring timestamp U
                begin
                    ns<=S12;
                end
           18'b01100_x_xxxxxxx_x_1_x_x_x:  //going back to idle
                begin
                    ns<=S0;
                end
           //***********************************************************************************
           18'b00000_1_0000110_x_1_x_x_x:  //S0->S13 for setting 4 bytes in payload with offset
                begin
                    ns<=S13;
                    payload_addr<=cfd_op1+32'h0110;
                    payload_data<=cfd_op2;
                end
           18'b01101_x_xxxxxxx_x_1_x_x_x:  //going back to idle
                begin
                    ns<=S0;
                end
           //***********************************************************************************
           18'b00000_1_0000111_x_1_x_x_x:  //S0->S14 for set TX frame ready
                begin
                    ns<=S14;
                end
           18'b01110_x_xxxxxxx_x_1_x_x_x:  //going back to idle
                begin
                    ns<=S0;
                end
            //**********************************************************************************
           18'b00000_1_0001000_x_1_x_x_x:  //S0->S15 for starting listening for frames
                begin
                    ns<=S15;
                end
           
           /*18'b01111_1_1000000_x_1_x_x_x:  
                begin
                    ns<=S0;
                end
           18'b01111_0_xxxxxxx_x_1_x_x_x:  
                begin
                    ns<=S16;
                end*/
                
           18'b01111_x_xxxxxxx_x_1_x_x_x:
                begin
                    ns<=S16;
                end     
           
           /*18'b10000_1_1000000_x_1_x_x_x:  
                begin
                    ns<=S0;
                end
           18'b10000_0_xxxxxxx_x_1_0_x_x:  
                begin
                    ns<=S15;
                end
           18'b10000_0_xxxxxxx_x_1_1_x_x:  
                begin
                    ns<=S17;
                end*/
           
           //NO Bus Error Detected
           18'b10000_x_xxxxxxx_x_1_0_x_0:  
                begin
                    ns<=S15;
                end
           18'b10000_x_xxxxxxx_x_1_1_x_0:  
                begin
                    ns<=S17;
                end
           //////////////////////////
           
           //Bus Error DETECTED
           
           18'b10000_x_xxxxxxx_x_1_x_x_1:  
                begin
                    ns<=S24;
                end
           ////////////////////////////////////////// 
           //Next for NO BUS ERROR and received frame     
           18'b10001_x_xxxxxxx_x_1_x_x_x:  
                begin
                    ns<=S18;
                end
                
           18'b10010_x_xxxxxxx_x_1_x_x_x:  
                begin
                    ns<=S19;
                end
           
           18'b10011_x_xxxxxxx_x_1_x_x_x:  
                begin
                    ns<=S20;
                end 
           
           18'b10100_x_xxxxxxx_x_1_x_0_x:  
                begin
                    ns<=S19;
                end
           18'b10100_x_xxxxxxx_x_1_x_1_x:  
                begin
                    ns<=S21;
                end
           18'b10101_x_xxxxxxx_x_1_x_x_x:  
                begin
                    ns<=S0;
                end
           //********************************************************************************
           //Next for Bus Error Detected
           18'b11000_x_xxxxxxx_x_1_x_x_x:  
                begin
                    ns<=S25;
                end
           18'b11001_x_xxxxxxx_x_1_x_x_x:  
                begin
                    ns<=S15;
                end
           //********************************************************************************
           18'b00000_1_1111111_x_x_x_x_x:  //S0->S22  for disable/deinit CAN FD Unit
                begin
                    ns<=S22;
                end
           18'b10110_x_xxxxxxx_x_x_x_x_x:  
                begin
                    ns<=S0;
                end
           //******************************************************************************** 
            default:      ns<=S0;     
        endcase
    
    //always caching the cfd_op1 and cfd_op2 operands
    /*always @(posedge clock)
    begin
        reg_op1<=cfd_op1;
        reg_op2<=cfd_op2;
    end*/
    always @(posedge clock)  //timestamp base
    begin
        if(res)
            tclk_cnt<=0;
        else
            tclk_cnt<=(tclk_cnt<((2**64)-1))?tclk_cnt+1:0;
    end
    ////////////////////////////////////////////////////////////////////
    always @(posedge clock)
    begin
        if(res)
            error_timer_counter<=0;
        else if(error_timer_res)
            error_timer_counter<=0;
        else if(error_timer_inc)
            error_timer_counter<=error_timer_counter+1;    
    end
    
    always @(posedge clock)
    begin
        if(res)
        begin
            error_timer_inc<=0;
            error_timer_res<=0;
        end
        else if(error_timer_ovf)
        begin
            error_timer_inc<=0;
            error_timer_res<=1;
        end
        else if(cs==S24)
        begin
            error_timer_inc<=1;
            error_timer_res<=0;
        end
        
        
    end
endmodule

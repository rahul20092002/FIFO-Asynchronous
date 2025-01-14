`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2024 00:21:20
// Design Name: 
// Module Name: FIFO_asyn
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


module FIFO_asyn(
    input write_clk,
    input read_clk,
    input reset,
    input write_enable,
    input read_enable,
    input [7:0] write_data,
    output reg [7:0] read_data,
    output full,
    output empty
    );
    
    reg [7:0] memory[15:0];
    
    reg [4:0] wrpt=0,rpt=0;
    
    reg [4:0]wrpt_grey=0,rpt_grey=0;
    
    reg [4:0]wrpt_sync1=0,wrpt_sync2=0;
    reg [4:0]rpt_sync1=0,rpt_sync2=0;
    
    assign full = (wrpt_grey == {~rpt_sync2[3], rpt_sync2[2:0]});
    assign empty=(wrpt_sync2==rpt_grey);
    
    //writing operatoin
    always@(posedge write_clk or posedge reset)begin
        if(reset)begin
            wrpt<=0;
            wrpt_grey<=0;
        end
        else if(write_enable && !full)begin
            memory[wrpt]<=write_data;
            wrpt<=(wrpt+1)%16;
            wrpt_grey<=wrpt^(wrpt>>1);
        end
    end
    
    //reading operation
    always@(posedge read_clk or posedge reset)
    begin
        if(reset)
            begin
                read_data<=0;
                rpt<=0;
            end
        else if(read_enable && !empty)
            begin
                read_data<=memory[rpt];
                rpt<=(rpt+1)%16;
                rpt_grey<=rpt^(rpt>>1);
            end
    end
    
    //synchroninsation of write pointer
    always@(posedge read_clk or posedge reset)begin
        if(reset)begin
            wrpt_sync1<=0;
            wrpt_sync2<=0;
        end
        else begin
           wrpt_sync1<=wrpt_grey;
           wrpt_sync2<=wrpt_sync1;
        end
    end
    
    //synchronosation of read pointer 
    always@(posedge write_clk or posedge reset)begin
        if(reset)begin
            rpt_sync1<=0;
            rpt_sync2<=0;
        end
        else begin
            rpt_sync1<=rpt_grey;
            rpt_sync2<=rpt_sync1;
        end
    end   
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2024 22:25:40
// Design Name: 
// Module Name: FIFO_asyncTB
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


module FIFO_asyncTB;
    reg write_clk;
    reg read_clk;
    reg reset;
    reg write_enable;
    reg read_enable;
    reg [7:0] write_data;  // Match FIFO data width
    wire [7:0] read_data;  // Match FIFO data width
    wire full;
    wire empty;

    // Instantiate the FIFO_async module
    FIFO_asyn uut (
        .write_clk(write_clk),
        .read_clk(read_clk),
        .reset(reset),
        .write_enable(write_enable),
        .read_enable(read_enable),
        .write_data(write_data),
        .read_data(read_data),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    initial begin
        write_clk = 0;
        read_clk = 0;
    end
    always #5 write_clk = ~write_clk;
    always #10 read_clk = ~read_clk;

    integer i;

    // Test sequence
    initial begin
        reset = 1;
        write_enable = 0;
        read_enable = 0;
        write_data = 0;

        // Reset the system
        #20 reset = 0;

        // Write 5 data values into the FIFO
        for (i = 0; i < 5; i = i + 1) begin
            @(posedge write_clk)
            if (!full) begin
                write_enable = 1;
                write_data = i;
            end else begin
                write_enable = 0; // Prevent writing when FIFO is full
            end
        end
        @(posedge write_clk)
        write_enable = 0;

        // Read 5 data values from the FIFO
        for (i = 0; i < 5; i = i + 1) begin
            @(posedge read_clk)
            if (!empty) begin
                read_enable = 1;
            end else begin
                read_enable = 0; // Prevent reading when FIFO is empty
            end
        end
        @(posedge read_clk)
        read_enable = 0;

        // Write 16 data values into the FIFO
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge write_clk)
            if (!full) begin
                write_enable = 1;
                write_data = i + 1;
            end else begin
                write_enable = 0;
            end
        end
        @(posedge write_clk)
        write_enable = 0;

        // Read 16 data values from the FIFO
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge read_clk)
            if (!empty) begin
                read_enable = 1;
            end else begin
                read_enable = 0;
            end
        end
        @(posedge read_clk)
        read_enable = 0;

        // Finish simulation
        #50 $stop;
    end
endmodule



`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/21 22:10:51
// Design Name: 
// Module Name: DM
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


module DM(DataIn, MemWr,Addr, clk, rst, DataOut);
    input [31:0]DataIn, Addr;
    input clk, rst, MemWr;
    output reg [31:0]DataOut;
    
    reg [7:0]DataMem[1023:0];   //也是1k的内存大小
    wire [9:0]pointer;
    assign pointer = Addr[9:0] - 268500992;  //Data segment的起始地址是减去的那个数，为了和前面对应从0开始
    
    //reset
    integer i;
    always @(negedge rst)begin
        for(i = 0; i < 1024; i = i+1)
            DataMem[i] = 0;
    end
    
    always@(posedge clk)begin
        //store word
        if(MemWr == 1)begin
            DataMem[pointer] <= DataIn[31:24];
            DataMem[pointer + 1] <= DataIn[23:16];
            DataMem[pointer + 2] <= DataIn[15:8];
            DataMem[pointer + 3] <= DataIn[7:0];
        end
    end
    
    always@(negedge clk)begin
        //load word
        if(MemWr == 0)begin
            DataOut <= {DataMem[pointer], DataMem[pointer + 1], DataMem[pointer + 2], DataMem[pointer + 3]};
        end
    end
endmodule

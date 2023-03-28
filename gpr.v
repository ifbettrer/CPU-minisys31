`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/22 09:41:51
// Design Name: 
// Module Name: gpr
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


module gpr(RegWr, ra, rb, rw, busW, clk, rst, busA, busB, DataIn, result);
    input clk, rst,RegWr;
    input [31:0]busW;
    input [4:0]ra, rb, rw;
    output [31:0]busA, busB, DataIn;
    output  reg [31:0]result;
    
    reg [31:0]regis[31:0];
    //wire [31:0]res;
    
    //reset register
    integer i;
    always@(posedge rst)begin
        if(rst)begin
            for(i = 0; i < 32; i = i+1)
               regis[i] = 0;
        end
    end
    
    //设置busA和busB
    assign busA = regis[ra];   //rs内容
    assign busB = regis[rb];
    assign DataIn = busB;
    //assign result = busW;
    //assign result = regis[4];
    
    //写入寄存器
    always@(posedge clk)begin
        if(RegWr)begin  //千万不要用阻塞型赋值，这样会发生时序错误，上板会受到影响
            regis[rw] = busW;
            regis[0] = 0;
        end
        result = regis[4];  //机器码上我们是直接在循环结束时将结果赋值给四号寄存器
    end
    
    /*always @(*)begin
        result <= res;
    end*/
    
endmodule
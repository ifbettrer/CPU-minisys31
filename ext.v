`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/22 09:46:13
// Design Name: 
// Module Name: ext
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


module ext(imm16, imm32, ExtOp);  //扩展成32为立即数
    input [15:0]imm16;   
    input [1:0]ExtOp;
    output reg[31:0]imm32;
    
    parameter zero = 2'b00;
    parameter sign = 2'b01;
    parameter lui = 2'b10;
    parameter shamt = 2'b11;
    
    always@(*)begin
        case(ExtOp)
          zero: imm32 = {16'b0, imm16}; //无符号数， 0扩展
          sign: imm32 = {{16{imm16[15]}},  imm16};   //符号位扩展
          lui: imm32 = {imm16, 16'b0};   //将16位立即数放在目的寄存器高16位，低十六位填0
          shamt: imm32 = {{27{imm16[10]}},imm16[10:6]};  //偏移量
        endcase
    end
endmodule
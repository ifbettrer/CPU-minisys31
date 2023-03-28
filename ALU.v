`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/21 20:19:02
// Design Name: 
// Module Name: ALU
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


module ALU(busA, busB, ALUctr, zero, ALUout, Addr);
    input [31:0]busA, busB;  //两个输入的值
    input [3:0]ALUctr;
    
    output [31:0]zero, Addr;
    output reg [31:0]ALUout;
    
    //设置运算命令
    parameter ADD = 4'b0000;
    parameter SUB = 4'b0001;
    parameter OR = 4'b0010;
    parameter AND = 4'b0011;
    parameter XOR = 4'b0100;
    parameter NOR = 4'b0101;
    parameter SLT = 4'b0110;
    parameter SL = 4'b0111;
    parameter SRL = 4'b1000;
    parameter SRA = 4'b1001;
    parameter SLV = 4'b1010;
    parameter SRLV = 4'b1011;
    parameter SRAV = 4'b1100;
    
    always @(*)begin
      case(ALUctr)
        ADD:begin
            ALUout = busA + busB;
        end
        SUB:begin
            ALUout = busA - busB;
        end
        OR:begin
            ALUout = busA | busB;
        end
        AND:begin
            ALUout = busA & busB;
        end
        XOR:begin
            ALUout = busA ^ busB;
        end
        NOR:begin
            ALUout = ~(busA | busB);
        end
        SLT:begin  //SLT指令就是要比较大小，小于结果就为1
            ALUout = busA < busB?1:0;
        end
        SL:begin
            ALUout = busA << busB;
        end
        SRL:begin
            ALUout = busA >> busB;
        end
        SRA:begin
            ALUout = busA >>> busB;
        end
        SLV:begin
            ALUout = busB << busA;
        end
        SRLV:begin
            ALUout = busB >> busA;
        end
        SRAV:begin
            ALUout = busB >>> busA;  //这里>>>是带符号位的右移，符号位是什么就补什么
        end
      endcase
    end
    
    assign zero = ALUout;
    assign Addr = ALUout;
endmodule

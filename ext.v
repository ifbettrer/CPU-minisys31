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


module ext(imm16, imm32, ExtOp);  //��չ��32Ϊ������
    input [15:0]imm16;   
    input [1:0]ExtOp;
    output reg[31:0]imm32;
    
    parameter zero = 2'b00;
    parameter sign = 2'b01;
    parameter lui = 2'b10;
    parameter shamt = 2'b11;
    
    always@(*)begin
        case(ExtOp)
          zero: imm32 = {16'b0, imm16}; //�޷������� 0��չ
          sign: imm32 = {{16{imm16[15]}},  imm16};   //����λ��չ
          lui: imm32 = {imm16, 16'b0};   //��16λ����������Ŀ�ļĴ�����16λ����ʮ��λ��0
          shamt: imm32 = {{27{imm16[10]}},imm16[10:6]};  //ƫ����
        endcase
    end
endmodule
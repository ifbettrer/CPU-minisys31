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
    
    //����busA��busB
    assign busA = regis[ra];   //rs����
    assign busB = regis[rb];
    assign DataIn = busB;
    //assign result = busW;
    //assign result = regis[4];
    
    //д��Ĵ���
    always@(posedge clk)begin
        if(RegWr)begin  //ǧ��Ҫ�������͸�ֵ�������ᷢ��ʱ������ϰ���ܵ�Ӱ��
            regis[rw] = busW;
            regis[0] = 0;
        end
        result = regis[4];  //��������������ֱ����ѭ������ʱ�������ֵ���ĺżĴ���
    end
    
    /*always @(*)begin
        result <= res;
    end*/
    
endmodule
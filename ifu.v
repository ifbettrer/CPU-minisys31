`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/21 20:50:38
// Design Name: 
// Module Name: ifu
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


module ifu(nPC_sel, zero, clk, rst, instruction,j_sel, regi);
    input clk, rst;
    input [1:0]nPC_sel;
    input [31:0]zero;
    input [1:0]j_sel;
    input [31:0]regi;
    output  [31:0]instruction;
    
    reg [31:0]pc;
    reg [7:0]im[1023:0];  //�ܹ���1k�ڴ��С
    reg [31:0]pcnew;
    wire [31:0]temp;
    wire [31:0] t0, t1;
    wire [15:0]imm16;
    reg [31:0]ExtOut;
    wire [25:0]jValue;
    
    wire [31:0]pc0;
    assign pc0 = pc - 4194304;  //ʹ�õ�ַ��0��ʼ
    
    //��instruction��ֵ
    assign instruction = {im[pc0], im[pc0 + 1], im[pc0 + 2], im[pc0 + 3]};
    assign imm16 = instruction[15:0];  //I��ָ��ʹ�õ�����ֵ
    //��jValue��ֵ
    assign jValue = instruction[25:0];
    //��extout��ֵ
    assign temp = {{16{imm16[15]}},imm16};
    
    //jָ��
    always@(*)begin
        if(j_sel == 2'b10)begin
            ExtOut = regi;
        end
        if(j_sel == 2'b01)begin  //�����ת�ź�1����ֱ�ӵ���ת�ĵط�ȥ
            ExtOut = {4'b0, jValue[25:0],2'b0};
        end
        else if(j_sel == 2'b00) begin
            ExtOut = temp[31:0]<<2;  //�����������λ
        end
    end
   // assign jValue <= instruction[25:0];
    
    //����pcnew
    assign t0 = pc + 4;  
    assign t1 = t0 + ExtOut;
    
    always@(*)begin
        if(nPC_sel == 2'b00)begin
            pcnew = t0;
        end
        else if(nPC_sel == 2'b01)begin
            pcnew = t1;
        end
        //BEQ
        else if(nPC_sel == 2'b10)begin
            if(zero == 0)begin
                pcnew = t1;
            end
            else begin
                pcnew = t0;
            end
        end
        //BNE
        else if(nPC_sel == 2'b11)begin
            if(zero != 0)begin  //zero��alu�����Ľ���������ǲ������
                pcnew = t1;
            end
            else begin
                pcnew = t0;
            end
        end
    end
    
    //reset
    always@(posedge clk, posedge rst)begin
        if(rst)
            pc = 32'h00400000;
        else if(j_sel == 2'b00)
            pc = pcnew;
        else if(j_sel == 2'b01|j_sel == 2'b10)  //jָ���jrָ���ֱ����ת��һ���ط���
            pc = ExtOut;
    end
endmodule

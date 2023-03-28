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
    reg [7:0]im[1023:0];  //总共有1k内存大小
    reg [31:0]pcnew;
    wire [31:0]temp;
    wire [31:0] t0, t1;
    wire [15:0]imm16;
    reg [31:0]ExtOut;
    wire [25:0]jValue;
    
    wire [31:0]pc0;
    assign pc0 = pc - 4194304;  //使得地址从0开始
    
    //给instruction赋值
    assign instruction = {im[pc0], im[pc0 + 1], im[pc0 + 2], im[pc0 + 3]};
    assign imm16 = instruction[15:0];  //I型指令使用的立即值
    //给jValue赋值
    assign jValue = instruction[25:0];
    //给extout赋值
    assign temp = {{16{imm16[15]}},imm16};
    
    //j指令
    always@(*)begin
        if(j_sel == 2'b10)begin
            ExtOut = regi;
        end
        if(j_sel == 2'b01)begin  //如果跳转信号1，则直接到跳转的地方去
            ExtOut = {4'b0, jValue[25:0],2'b0};
        end
        else if(j_sel == 2'b00) begin
            ExtOut = temp[31:0]<<2;  //否则就左移两位
        end
    end
   // assign jValue <= instruction[25:0];
    
    //设置pcnew
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
            if(zero != 0)begin  //zero是alu出来的结果，表明是不是相等
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
        else if(j_sel == 2'b01|j_sel == 2'b10)  //j指令或jr指令都是直接跳转到一个地方的
            pc = ExtOut;
    end
endmodule

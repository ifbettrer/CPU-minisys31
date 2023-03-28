`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/22 09:45:47
// Design Name: 
// Module Name: MuxReg
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


module MuxReg(a, b, rw, RegDst);
    input [4:0]a, b;
    input RegDst;
    output reg[4:0]rw;
    
    always@(*)begin
        if(RegDst)
          rw = b;
        else
          rw = a; 
    end
endmodule
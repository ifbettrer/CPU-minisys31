`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/25 10:16:52
// Design Name: 
// Module Name: CPU_tb
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


module CPU_tb();
    reg clk, rst;
    wire [2:0]del;
    wire [7:0]seg;
    CPU launch(.clk(clk), .rst(rst), .seg(seg), .del(del));
    
    initial begin
        rst = 0;
        clk = 1;
        #1 rst = 1;
        #2 rst = 0;
        $readmemh("fib.data", launch.MAIN.IFU.im);
      // $readmemh("F:/code.txt", launch.MAIN.IFU.im);
       // $readmemh("F:/code.txt", regi);
        //$display("%h",regi[0]);
    end
    
    always #30 clk = ~clk;
endmodule

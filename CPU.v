`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/22 09:39:39
// Design Name: 
// Module Name: CPU
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


module mips(clk,rst,RegDst,RegWr,ExtOp,nPC_sel,ALUctr,MemtoReg,MemWr,ALUsrc,j_sel,Instruction,move, result);
input clk,rst;
input [1:0]ExtOp,nPC_sel,move,j_sel;
input [3:0]ALUctr;
input ALUsrc,MemWr,MemtoReg,RegDst,RegWr;
wire [31:0]instruction, res;  //res用来接收四号寄存器内的值
wire [31:0]busA,busB,busC,busW,Mux_ALUSrc_out,imm32,ALUout,DataIn,DataOut,jValue,Addr, PC,regi;
wire [31:0]zero;
wire [4:0]rw;


output [31:0]Instruction, result;
assign Instruction[31:0]=instruction[31:0];
assign result[31:0] = res[31:0];

//connect all compoenet
ifu IFU(.nPC_sel(nPC_sel),.zero(zero),.clk(clk),.rst(rst),.instruction(instruction),.j_sel(j_sel),.regi(busA));  //这里传入了busA的值，即rs寄存器内的值给regi
ext EXT(.imm16(instruction[15:0]),.imm32(imm32),.ExtOp(ExtOp));
ALU alu(.busA(busC),.busB(Mux_ALUSrc_out),.ALUctr(ALUctr),.zero(zero),.ALUout(ALUout),.Addr(Addr));
MuxReg MUX_RegDst(.a(instruction[20:16]),.b(instruction[15:11]),.rw(rw),.RegDst(RegDst));  //选出写入哪个寄存器， RegDst为1选择rt，否则为rs
MUX MUX_ALUSrc(.a(busB),.b(imm32),.op(ALUsrc),.out(Mux_ALUSrc_out));    //是立即数操作还是寄存器里的
MUX MUX_MemtoReg(.a(ALUout),.b(DataOut),.op(MemtoReg),.out(busW));      //选择aluout还是地址内的值
MUX MUX_NeedMove(.a(busA),.b(busB),.op(move),.out(busC));   //设置shamt
gpr GPR(.RegWr(RegWr),.ra(instruction[25:21]),.rb(instruction[20:16]),.rw(rw),.busW(busW),.clk(clk),.rst(rst),.busA(busA),.busB(busB),.DataIn(DataIn), .result(res));
DM DM(.DataIn(DataIn),.MemWr(MemWr),.Addr(Addr),.clk(clk),.rst(rst),.DataOut(DataOut));  // sw指令和lw指令，DataIn就是busB，rt内的值

//assign Instruction[31:0]=instruction[31:0];

endmodule

module CPU(clk,rst, seg, del);
  input clk,rst;
  output reg [2:0]del;
  output reg [7:0]seg;   //七段数码管
  reg [3:0]   unit    ;//个位
  reg [3:0]   ten     ;//十位
  reg [3:0]   hun     ;//百位
  reg [3:0]   tho     ;//千位
  reg [3:0]   t_tho   ;//万位
  reg [3:0]   h_hun   ;//十万位
  reg [3:0]   mil     ;//百万位
  reg [3:0]   t_mil   ;//千万位
  wire [31:0]result;  //传递结果的线
  wire [1:0]ExtOp,nPC_sel,j_sel;   //分别控制扩展操作，pc变化，跳转操作
  wire [3:0]ALUctr;
  wire ALUsrc,MemWr,MemtoReg,RegDst,RegWr,move;
  wire [31:0]instruction;
  
  //将cpu组装起来
  ctrl CU(.instruction(instruction),.RegDst(RegDst),.RegWr(RegWr),.ExtOp(ExtOp),.nPC_sel(nPC_sel),.ALUctr(ALUctr),.MemtoReg(MemtoReg),.MemWr(MemWr),.ALUsrc(ALUsrc),.j_sel(j_sel),.move(move));
  mips MAIN(.clk(clk),.rst(rst),.RegDst(RegDst),.RegWr(RegWr),.ExtOp(ExtOp),.nPC_sel(nPC_sel),.ALUctr(ALUctr),.MemtoReg(MemtoReg),.MemWr(MemWr),.ALUsrc(ALUsrc),.j_sel(j_sel),.Instruction(instruction),.move(move), .result(result));
  
  always @(*)begin  //因为斐波那契数第二十个是四位数，所以我们取结果十六进制的低四位来显示
      unit = result[3:0];
      ten = result[7:4];
      hun = result[11:8];
      tho = result[15:12];
  end
        //在七段数码管上显示出来
        integer i = 0;
        always@(posedge clk)begin
            if(i % 4 == 0)begin  //显示个位
                case(unit)
                  4'b0000: seg <= 8'h3F; //0
                  4'b0001: seg <= 8'h06;//1   06777d5e
                  4'b0010: seg <= 8'h5B;//2
                  4'b0011: seg <= 8'h4F;//3
                  4'b0100: seg <= 8'h66;//4
                  4'b0101: seg <= 8'h6D;//5
                  4'b0110: seg <= 8'h7D;//6
                  4'b0111: seg <= 8'h07;//7
                  4'b1000: seg <= 8'h7F;//8
                  4'b1001: seg <= 8'h6F; //9
                  4'b1010: seg <= 8'h77;//a
                  4'b1011: seg <= 8'h7C;//b
                  4'b1100: seg <= 8'h39;//c
                  4'b1101: seg <= 8'h5E;//d
                  4'b1110: seg <= 8'h7B;//e
                  4'b1111: seg <= 8'h71;//f
                endcase
                del = 3'b011;
            end
            if(i % 4 == 1)begin  //显示十位
                case(ten)
                  4'b0000: seg <= 8'h3F;
                  4'b0001: seg <= 8'h06;
                  4'b0010: seg <= 8'h5B;
                  4'b0011: seg <= 8'h4F;
                  4'b0100: seg <= 8'h66;
                  4'b0101: seg <= 8'h6D;
                  4'b0110: seg <= 8'h7D;
                  4'b0111: seg <= 8'h07;
                  4'b1000: seg <= 8'h7F;
                  4'b1001: seg <= 8'h6F; 
                  4'b1010: seg <= 8'h77;
                  4'b1011: seg <= 8'h7C;
                  4'b1100: seg <= 8'h39;
                  4'b1101: seg <= 8'h5E;
                  4'b1110: seg <= 8'h7B;
                  4'b1111: seg <= 8'h71;
                endcase
                del = 3'b010;
            end
            if(i % 4 == 2)begin  //显示百位
                case(hun)
                  4'b0000: seg <= 8'h3F;
                  4'b0001: seg <= 8'h06;
                  4'b0010: seg <= 8'h5B;
                  4'b0011: seg <= 8'h4F;
                  4'b0100: seg <= 8'h66;
                  4'b0101: seg <= 8'h6D;
                  4'b0110: seg <= 8'h7D;
                  4'b0111: seg <= 8'h07;
                  4'b1000: seg <= 8'h7F;
                  4'b1001: seg <= 8'h6F;
                  4'b1010: seg <= 8'h77;
                  4'b1011: seg <= 8'h7C;
                  4'b1100: seg <= 8'h39;
                  4'b1101: seg <= 8'h5E;
                  4'b1110: seg <= 8'h7B;
                  4'b1111: seg <= 8'h71; 
                endcase
                del = 3'b001;
            end
            if(i % 4 == 3)begin  //显示千位
                case(tho)
                  4'b0000: seg <= 8'h3F;
                  4'b0001: seg <= 8'h06;
                  4'b0010: seg <= 8'h5B;
                  4'b0011: seg <= 8'h4F;
                  4'b0100: seg <= 8'h66;
                  4'b0101: seg <= 8'h6D;
                  4'b0110: seg <= 8'h7D;
                  4'b0111: seg <= 8'h07;
                  4'b1000: seg <= 8'h7F;
                  4'b1001: seg <= 8'h6F;
                  4'b1010: seg <= 8'h77;
                  4'b1011: seg <= 8'h7C;
                  4'b1100: seg <= 8'h39;
                  4'b1101: seg <= 8'h5E;
                  4'b1110: seg <= 8'h7B;
                  4'b1111: seg <= 8'h71; 
                endcase
                del = 3'b000;
            end
            i = i + 1;
        end
endmodule
/* 二进制转换为十进制
module  bcd_8421(
    input           sys_clk,
    input           sys_rst_n,
    input   [26:0]  data,
    
    output  reg [3:0]   unit    ,//个位
    output  reg [3:0]   ten     ,//十位
    output  reg [3:0]   hun     ,//百位
    output  reg [3:0]   tho     ,//千位
    output  reg [3:0]   t_tho   ,//万位
    output  reg [3:0]   h_hun   ,//十万位
    output  reg [3:0]   mil     ,//百万位
    output  reg [3:0]   t_mil   //千万位
);

reg [4:0]   cnt_shift;//移位判断计数器
reg [58:0]  data_shift;//移位判断数据寄存器
reg         shift_flag;//移位判断标志位

//cnt_shift:移位判断计数器，每移一位计数器加1；
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 0)
        cnt_shift <= 5'd0;
    else    if((cnt_shift == 5'd28) && (shift_flag == 1'b1))
        cnt_shift <= 5'd0;
    else    if(shift_flag == 1'b1)
        cnt_shift <= cnt_shift + 1'b1;
    else
        cnt_shift <= cnt_shift;
        
//data_shift:计数器为0时赋初值。计数器为1~27时进行移位判断操作
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 0)
        data_shift <= 58'd0;
    else    if(cnt_shift == 5'd0)
        data_shift <= {32'd0,data};
    else    if((cnt_shift <= 27) && (shift_flag == 1'b0))
        begin
            data_shift[30:27] <= (data_shift[30:27] > 4) ? (data_shift[30:27] + 2'd3) : (data_shift[30:27]);
            data_shift[34:31] <= (data_shift[34:31] > 4) ? (data_shift[34:31] + 2'd3) : (data_shift[34:31]);
            data_shift[38:35] <= (data_shift[38:35] > 4) ? (data_shift[38:35] + 2'd3) : (data_shift[38:35]);
            data_shift[42:39] <= (data_shift[42:39] > 4) ? (data_shift[42:39] + 2'd3) : (data_shift[42:39]);
            data_shift[46:43] <= (data_shift[46:43] > 4) ? (data_shift[46:43] + 2'd3) : (data_shift[46:43]);
            data_shift[50:47] <= (data_shift[50:47] > 4) ? (data_shift[50:47] + 2'd3) : (data_shift[50:47]);
            data_shift[54:51] <= (data_shift[54:51] > 4) ? (data_shift[54:51] + 2'd3) : (data_shift[54:51]);
            data_shift[58:55] <= (data_shift[58:55] > 4) ? (data_shift[58:55] + 2'd3) : (data_shift[58:55]);
        end
    else    if((cnt_shift <= 27) && (shift_flag == 1'b1))
        data_shift <= data_shift << 1;
    else
        data_shift <= data_shift;

//shift_flag：移位判断标志信号，用于控制移位判断的先后顺序
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        shift_flag <= 1'b0;
    else
        shift_flag <= ~shift_flag;
        
//当计数器等于 20 时，移位判断操作完成，对各个位数的 BCD 码进行赋值
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        begin
            unit    <= 4'd0;
            ten     <= 4'd0;
            hun     <= 4'd0;
            tho     <= 4'd0;
            t_tho   <= 4'd0;
            h_hun   <= 4'd0;
            mil     <= 4'd0;
            t_mil   <= 4'd0;
        end
    else if(cnt_shift == 5'd28)
        begin
            unit    <= data_shift[30:27];
            ten     <= data_shift[34:31];
            hun     <= data_shift[38:35];
            tho     <= data_shift[42:39];
            t_tho   <= data_shift[46:43];
            h_hun   <= data_shift[50:47];
            mil     <= data_shift[54:51];
            t_mil   <= data_shift[58:55];
        end    
endmodule
*/  

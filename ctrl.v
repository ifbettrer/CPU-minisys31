`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/21 22:31:07
// Design Name: 
// Module Name: ctrl
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


module ctrl(instruction, RegDst, RegWr, ExtOp, nPC_sel, ALUctr, MemtoReg, MemWr, ALUsrc, j_sel, move);
    input [31:0]instruction;
    output reg[1:0]ExtOp, nPC_sel,j_sel;
    output reg[3:0]ALUctr;
    output reg RegDst, RegWr, MemtoReg, MemWr, ALUsrc, move;
    
    parameter ADD = 4'b0000;
    parameter SUB = 4'b0001;
    parameter OR = 4'b0010;
    parameter AND = 4'b0011;
    parameter XOR = 4'b0100;
    parameter NOR = 4'b0101;
    parameter SLT = 4'b0110;
    parameter SLL = 4'b0111;
    parameter SRL = 4'b1000;
    parameter SRA = 4'b1001;
    parameter SLV = 4'b1010;
    parameter SRLV = 4'b1011;
    parameter SRAV = 4'b1100;
    
    initial begin
        RegDst = 0; 
        RegWr = 0; 
        ExtOp = 0;
        nPC_sel = 0;
        ALUctr = 0;
        MemtoReg = 0;
        MemWr = 0;
        ALUsrc = 0;
        j_sel = 0;
        move = 0;
    end
    
    always @(*)begin
        //R-Type
        if(instruction[31:26] == 6'b000000)begin
            //ADD
            if(instruction[5:0] == 6'b100000)begin
               /* nPC_sel = 2'b00;
                RegDst = 1'b1;
                RegWr = 1'b1;
                ExtOp = 2'b01;
                ALUsrc = 1'b0;
                ALUctr = ADD;
                MemWr = 1'b1;
                MemtoReg = 1'b1;
                j_sel = 2'b00;
                move = 1'b1;
                */
                nPC_sel = 2'b00;
                RegDst = 1'b1;
                RegWr = 1'b1;
                ExtOp = 2'b01;
                ALUsrc = 1'b0;
                ALUctr = ADD;
                MemWr = 1'b0;
                MemtoReg = 1'b0;
                j_sel = 2'b00;
                move = 1'b0;
            end
            //ADDU
            else if(instruction[5:0] == 6'b100001)begin
                nPC_sel = 2'b00;
                RegDst = 1'b1;
                RegWr = 1'b1;
                ExtOp = 2'b00;
                ALUsrc = 1'b0;
                ALUctr = ADD;
                MemWr = 1'b0;
                MemtoReg = 1'b0;
                j_sel = 2'b00;
                move = 1'b0;
            end
            //SUB
            else if(instruction[5:0] == 6'b100010)begin
                nPC_sel = 2'b00;
                RegDst = 1'b1;
                RegWr = 1'b1;
                ExtOp = 2'b01;
                ALUsrc = 1'b0;
                ALUctr = SUB;
                MemWr = 1'b0;
                MemtoReg = 1'b0;
                j_sel = 2'b00;
                move = 1'b0;
            end
            //SUBU
            else if(instruction[5:0] == 6'b100011)begin
                nPC_sel = 2'b00;
                RegDst = 1'b1;
                RegWr = 1'b1;
                ExtOp = 2'b00;
                ALUsrc = 1'b0;
                ALUctr = SUB;
                MemWr = 1'b0;
                MemtoReg = 1'b0;
                j_sel = 2'b00;
                move = 1'b0;
            end
            //AND
            else if(instruction[5:0] == 6'b100100)begin
                nPC_sel = 2'b00;
                RegDst = 1'b1;
                RegWr = 1'b1;
                ExtOp = 2'b01;
                ALUsrc = 1'b0;
                ALUctr = AND;
                MemWr = 1'b0;
                MemtoReg = 1'b0;
                j_sel = 2'b00;
                move = 1'b0;
            end
            //OR
            else if(instruction[5:0] == 6'b100101)begin
                nPC_sel = 2'b00;
                RegDst = 1'b1;
                RegWr = 1'b1;
                ExtOp = 2'b01;
                ALUsrc = 1'b0;
                ALUctr = OR;
                MemWr = 1'b0;
                MemtoReg = 1'b0;
                j_sel = 2'b00;
                move = 1'b0;
            end
            //XOR
            else if(instruction[5:0] == 6'b100110)begin
                nPC_sel = 2'b00;
                RegDst = 1'b1;
                RegWr = 1'b1;
                ExtOp = 2'b01;
                ALUsrc = 1'b0;
                ALUctr = XOR;
                MemWr = 1'b0;
                MemtoReg = 1'b0;
                j_sel = 2'b00;
                move = 1'b0;
            end
            //NOR
            else if(instruction[5:0] == 6'b100111)begin
                nPC_sel = 2'b00;
                RegDst = 1'b1;
                RegWr = 1'b1;
                ExtOp = 2'b01;
                ALUsrc = 1'b0;
                ALUctr = NOR;
                MemWr = 1'b0;
                MemtoReg = 1'b0;
                j_sel = 2'b00;
                move = 1'b0;
            end
            //SLT
            else if(instruction[5:0] == 6'b101010)begin
                nPC_sel = 2'b00;
                RegDst = 1'b1;
                RegWr = 1'b1;
                ExtOp = 2'b01;
                ALUsrc = 1'b0;
                ALUctr = SLT;
                MemWr = 1'b0;
                MemtoReg = 1'b0;
                j_sel = 2'b00;
                move = 1'b0;
            end
            //SLTU
            else if(instruction[5:0] == 6'b101011)begin
                nPC_sel = 2'b00;
                RegDst = 1'b1;
                RegWr = 1'b1;
                ExtOp = 2'b00;
                ALUsrc = 1'b0;
                ALUctr = SLT;
                MemWr = 1'b0;
                MemtoReg = 1'b0;
                j_sel = 2'b00;
                move = 1'b0;
            end
            //SLL
            else if(instruction[5:0] == 6'b000000)begin
                nPC_sel = 2'b00;
                RegDst = 1'b1;
                RegWr = 1'b1;
                ExtOp = 2'b11;
                ALUsrc = 1'b1;
                ALUctr = SLL;
                MemWr = 1'b0;
                MemtoReg = 1'b0;
                j_sel = 2'b00;
                move = 1'b1;  //设置shamt
            end
            //SRL
            else if(instruction[5:0] == 6'b000010)begin
                nPC_sel = 2'b00;
                RegDst = 1'b1;
                RegWr = 1'b1;
                ExtOp = 2'b11;
                ALUsrc = 1'b1;
                ALUctr = SRL;
                MemWr = 1'b0;
                MemtoReg = 1'b0;
                j_sel = 2'b00;
                move = 1'b1;
            end
            //SRA
            else if(instruction[5:0] == 6'b000011)begin
                nPC_sel = 2'b00;
                RegDst = 1'b1;
                RegWr = 1'b1;
                ExtOp = 2'b11;
                ALUsrc = 1'b1;
                ALUctr = SRA;
                MemWr = 1'b0;
                MemtoReg = 1'b0;
                j_sel = 2'b00;
                move = 1'b1;
            end
            //SLV
            else if(instruction[5:0] == 6'b000100)begin
                nPC_sel = 2'b00;
                RegDst = 1'b1;
                RegWr = 1'b1;
                ExtOp = 2'b01;
                ALUsrc = 1'b0;
                ALUctr = SLV;
                MemWr = 1'b0;
                MemtoReg = 1'b0;
                j_sel = 2'b00;
                move = 1'b0;
            end
            //SRLV
            else if(instruction[5:0] == 6'b000110)begin
                nPC_sel = 2'b00;
                RegDst = 1'b1;
                RegWr = 1'b1;
                ExtOp = 2'b01;
                ALUsrc = 1'b0;
                ALUctr = SRLV;
                MemWr = 1'b0;
                MemtoReg = 1'b0;
                j_sel = 2'b00;
                move = 1'b0;
            end
            //SRAV
            else if(instruction[5:0] == 6'b000111)begin
                nPC_sel = 2'b00;
                RegDst = 1'b1;
                RegWr = 1'b1;
                ExtOp = 2'b01;
                ALUsrc = 1'b0;
                ALUctr = SRAV;
                MemWr = 1'b0;
                MemtoReg = 1'b0;
                j_sel = 2'b00;
                move = 1'b0;
            end
            //jr
           else if(instruction[5:0] == 6'b001000)begin
                nPC_sel = 2'b01;
                RegDst = 1'b0;
                RegWr = 1'b0;
                ExtOp = 2'b01;
                ALUsrc = 1'b0;
                ALUctr = SUB;
                MemWr = 1'b0;
                MemtoReg = 1'b1;
                j_sel = 2'b10;
                move = 1'b0;
            end
        end
        /*
         nPC_sel = 2'b01;
            RegDst = 1'b0;
            RegWr = 1'b0;
            ExtOp = 2'b01;
            ALUsrc = 1'b0;
            ALUctr = SUB;
            MemWr = 1'b0;
            MemtoReg = 1'b1;
            j_sel = 2'b01;
            move = 1'b0;
        */
        //I-Type
        //ADDI
        else if(instruction[31:26] == 6'b001000)begin
            nPC_sel = 2'b00;
            RegDst = 1'b0;
            RegWr = 1'b1;
            ExtOp = 2'b01;
            ALUsrc = 1'b1;
            ALUctr = ADD;
            MemWr = 1'b0;
            MemtoReg = 1'b0;
            j_sel = 2'b00;
            move = 1'b0;
        end
        //ADDIU
        else if(instruction[31:26] == 6'b001001)begin
            nPC_sel = 2'b00;
            RegDst = 1'b0;
            RegWr = 1'b1;
            ExtOp = 2'b01;
            ALUsrc = 1'b1;
            ALUctr = ADD;
            MemWr = 1'b0;
            MemtoReg = 1'b0;
            j_sel =2'b00;
            move = 1'b0;
        end
        //ANDI
        else if(instruction[31:26] == 6'b001100)begin
            nPC_sel = 2'b00;
            RegDst = 1'b0;
            RegWr = 1'b1;
            ExtOp = 2'b01;
            ALUsrc = 1'b1;
            ALUctr = AND;
            MemWr = 1'b0;
            MemtoReg = 1'b0;
            j_sel = 2'b00;
            move = 1'b0;
        end
        //ORI
        else if(instruction[31:26] == 6'b001101)begin
            nPC_sel = 2'b00;
            RegDst = 1'b0;
            RegWr = 1'b1;
            ExtOp = 2'b00;
            ALUsrc = 1'b1;
            ALUctr = OR;
            MemWr = 1'b0;
            MemtoReg = 1'b0;
            j_sel = 2'b00;
            move = 1'b0;
        end
        //XORI
        else if(instruction[31:26] == 6'b001110)begin
            nPC_sel = 2'b00;
            RegDst = 1'b0;
            RegWr = 1'b1;
            ExtOp = 2'b00;
            ALUsrc = 1'b1;
            ALUctr = XOR;
            MemWr = 1'b0;
            MemtoReg = 1'b0;
            j_sel = 2'b00;
            move = 1'b0;
        end
        //LW
        else if(instruction[31:26] == 6'b100011)begin
            nPC_sel = 2'b00;
            RegDst = 1'b0;
            RegWr = 1'b1;
            ExtOp = 2'b01;
            ALUsrc = 1'b1;
            ALUctr = ADD;
            MemWr = 1'b0;
            MemtoReg = 1'b1;
            j_sel = 2'b00;
            move = 1'b0;
        end
        //SW
        else if(instruction[31:26] == 6'b101011)begin
            nPC_sel = 2'b00;
            RegDst = 1'b0;
            RegWr = 1'b0;
            ExtOp = 2'b01;
            ALUsrc = 1'b1;
            ALUctr = ADD;
            MemWr = 1'b1;
            MemtoReg = 1'b0;
            j_sel = 2'b00;
            move = 1'b0;
        end
        //BEQ
        else if(instruction[31:26] == 6'b000100)begin
            nPC_sel = 2'b10;
            RegDst = 1'b0;
            RegWr = 1'b1;
            ExtOp = 2'b01;
            ALUsrc = 1'b0;
            ALUctr = SUB;  //相减判断是否相等
            MemWr = 1'b0;
            MemtoReg = 1'b0;
            j_sel = 2'b00;
            move = 1'b0;
        end
        //BNE
        else if(instruction[31:26] == 6'b000101)begin
            nPC_sel = 2'b11;
            RegDst = 1'b0;
            RegWr = 1'b0;
            ExtOp = 2'b01;
            ALUsrc = 1'b0;
            ALUctr = SUB;
            MemWr = 1'b0;
            MemtoReg = 1'b0;
            j_sel = 2'b00;
            move = 1'b0;
        end
        //LUI
        else if(instruction[31:26] == 6'b001111)begin
            nPC_sel = 2'b00;
            RegDst = 1'b0;
            RegWr = 1'b1;
            ExtOp = 2'b10;
            ALUsrc = 1'b1;
            ALUctr = OR;
            MemWr = 1'b0;
            MemtoReg = 1'b0;
            j_sel = 2'b00;
            move = 1'b0;
        end
        //SLTI
        else if(instruction[31:26] == 6'b001010)begin
            nPC_sel = 2'b00;
            RegDst = 1'b0;
            RegWr = 1'b1;
            ExtOp = 2'b01;
            ALUsrc = 1'b1;
            ALUctr = SLT;
            MemWr = 1'b0;
            MemtoReg = 1'b0;
            j_sel = 2'b00;
            move = 1'b0;
        end
        //SLTIU   *************
        else if(instruction[31:26] == 6'b001011)begin
            nPC_sel = 2'b00;
            RegDst = 1'b0;
            RegWr = 1'b1;
            ExtOp = 2'b01;
            ALUsrc = 1'b1;
            ALUctr = SLT;
            MemWr = 1'b0;
            MemtoReg = 1'b0;
            j_sel = 2'b00;
            move = 1'b0;
        end
        //J
        else if(instruction[31:26] == 6'b000010)begin
            nPC_sel = 2'b01;
            RegDst = 1'b0;
            RegWr = 1'b0;
            ExtOp = 2'b01;
            ALUsrc = 1'b0;
            ALUctr = SUB;
            MemWr = 1'b0;
            MemtoReg = 1'b1;
            j_sel = 2'b01;
            move = 1'b0;
        end
    end
endmodule

`timescale 1ns/1ps
module tb_alu;
    reg  [31:0] a,b; reg [3:0] alu_op;
    wire [31:0] result; wire zero;
    alu dut(.a(a),.b(b),.aluop(alu_op),.result(result),.zero(zero));
    integer errors=0;
    task chk(input [31:0]r,input [31:0]er,input zf,input ezf);
        if(r!==er||zf!==ezf)begin $display("FAIL res=%0h(exp=%0h) z=%b(exp=%b)",r,er,zf,ezf);errors=errors+1;end
        else $display("ok   res=%0h z=%b",r,zf);
    endtask
    initial begin
        a=32'd15; b=32'd7;
        alu_op=4'b0000;#1;chk(result,32'd22,zero,0);           // ADD  15+7=22
        alu_op=4'b0001;#1;chk(result,32'd8, zero,0);           // SUB  15-7=8
        alu_op=4'b0010;#1;chk(result,32'h7,zero,0);            // AND  15&7=7
        alu_op=4'b0011;#1;chk(result,32'hF,zero,0);            // OR   15|7=15
        alu_op=4'b0100;#1;chk(result,32'h8,zero,0);            // XOR  15^7=8
        alu_op=4'b0101;#1;chk(result,32'd0,zero,1);            // SLT  15<7? no ->0, zero=1
        a=32'd3;b=32'd7;
        alu_op=4'b0101;#1;chk(result,32'd1,zero,0);            // SLT  3<7? yes ->1
        a=32'd1;b=32'd3;
        alu_op=4'b0111;#1;chk(result,32'd8,zero,0);            // SLL  1<<3=8
        a=32'd8;b=32'd1;
        alu_op=4'b1000;#1;chk(result,32'd4,zero,0);            // SRL  8>>1=4
        a=32'hFFFFFFFC;b=32'd2;
        alu_op=4'b1001;#1;chk(result,32'hFFFFFFFF,zero,0);     // SRA  -4>>>2=-1
        // zero flag test
        a=32'd5;b=32'd5;alu_op=4'b0001;#1;
        if(zero!==1)begin $display("FAIL zero should be 1 for 5-5");errors=errors+1;end
        else $display("ok   zero=1 for 5-5=0");
        if(errors==0) $display("ALL TESTS PASSED"); else $display("%0d FAILED",errors);
        $finish;
    end
endmodule
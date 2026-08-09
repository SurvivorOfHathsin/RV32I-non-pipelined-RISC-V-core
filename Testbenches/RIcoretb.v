`timescale 1ns/1ps
module RIcoretb;
reg clk=0,rst=1;
RI_core dut(.clk(clk),.rst(rst));
//extremely cool how the core only needs clock and reset, and all interconnections are done inside

always #5 clk=~clk;

wire [31:0] x1=dut.rf.regs[1],x2=dut.rf.regs[2],x3=dut.rf.regs[3];
wire [31:0] x4=dut.rf.regs[4],x5=dut.rf.regs[5],x6=dut.rf.regs[6];

integer errs=0;
task chk(input [31:0]got,input [31:0]exp,input [127:0]name);
        if(got!==exp)
        begin $display("FAIL %s: got=%0h exp=%0h",name,got,exp);
        errs=errs+1;
        end
        else $display("ok   %s = %0h",name,got);
endtask
always @(posedge clk) begin
    $display("PC=%h  INSTR=%h", dut.pc, dut.instr);
end
initial begin
    rst = 1;

    #12;       // keep reset active through the first clock edge
    rst = 0;   // release reset safely between clock edges

    repeat(8) @(posedge clk);
    #1;
        chk(x1,32'd5,"x1 (addi 5)");
        chk(x2,32'd10,"x2 (addi 10)");
        chk(x3,32'd15,"x3 (add)");
        chk(x4,32'hFFFFFFFB,"x4 (sub)");
        chk(x5,32'd0,"x5 (and)");
        chk(x6,32'd15,"x6 (or)");
        if(errs==0) $display("ALL TESTS PASSED"); else $display("%0d FAILED",errs);
        $finish;
end
endmodule

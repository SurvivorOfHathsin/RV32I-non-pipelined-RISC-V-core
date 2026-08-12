// tb_core_rim.v — Testbench for core_rils (loads + stores)
// Program: addi x1,x0,42  → sw x1,0(x0)  → lw x2,0(x0)
// Expected: x2 == 42 after lw executes
`timescale 1ns/1ps
module tb_core_rils;
    reg clk = 0, rst = 1;
    always #5 clk = ~clk;

    RILS_core dut (.clk(clk), .rst(rst));

   initial begin
        
        $dumpfile("tb_core_rils.vcd");
        $dumpvars(0, tb_core_rils);

        #10;
        rst = 0;

        repeat(6) @(posedge clk); // run 6 cycles
        #1;

        // Inspect x2
        if (dut.rf.regs[2] === 32'd42)
            $display("PASS: x2 = %0d (expected 42)", dut.rf.regs[2]);
        else
            $display("FAIL: x2 = %0d (expected 42)", dut.rf.regs[2]);

        $finish;
    end
endmodule
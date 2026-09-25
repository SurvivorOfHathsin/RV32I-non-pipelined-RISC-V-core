// tb_riscv_core.v — Converted for RISCVCORE
`timescale 1ns/1ps

module tb_riscv_core;
    reg clk = 0, rst = 1;
    always #5 clk = ~clk; // 100 MHz

    // Instantiation using your module name RISCVCORE
    RISCVCORE dut (
        .clk(clk),
        .rst(rst)
    );

    integer i;
    reg [31:0] result;

    initial begin
        // Path matches instfetch -> imemconnect -> mem
        $readmemh("program.hex", dut.if0.imemconnect.mem);

        $dumpfile("tb_riscv_core.vcd");
        $dumpvars(0, tb_riscv_core);

        // Release reset after 2 cycles
        repeat(2) @(posedge clk);
        rst = 0;

        // Run for 50 cycles to allow loop completion
        repeat(50) @(posedge clk);
        #1;

        // Check: memory address 0 should contain 15 (sum 1..5)
        result = {dut.dmem0.mem[3], dut.dmem0.mem[2],
                  dut.dmem0.mem[1], dut.dmem0.mem[0]};

        if (result === 32'd15)
            $display("PASS: sum(1..5) = %0d stored at mem[0]", result);
        else
            $display("FAIL: mem[0] = %0d (expected 15)", result);

        // Dump first 8 registers
        $display("--- Register File Snapshot ---");
        for (i = 0; i < 8; i = i + 1)
            $display("  x%0d = %0d", i, dut.rf.regs[i]);

        $finish;
    end
endmodule
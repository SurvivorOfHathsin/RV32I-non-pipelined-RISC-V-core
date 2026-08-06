`timescale 1ns/1ps
module tb_pc;
reg clk,rst;
reg [31:0] pc_next;
wire [31:0]pc;
program_counter dut(clk,rst,pc_next,pc);
//clock of 5 nanoseconds pulse width & 50% duty cycle
initial clk=0;
always #5 clk=~clk;

initial begin
    rst=1;
    pc_next=32'h4; // to check if reset works
    @(posedge clk);
    #1 ;
    if (pc!==32'h0) $display("Fail");
     $display("pc=%h", pc);

    rst=0;//now to check if program counter works
    pc_next=32'h4; @(posedge clk);#1;
    if (pc!==32'h4) $display("Fail");
     $display("pc=%h", pc);

    pc_next=32'h8; @(posedge clk);#1;
    if (pc!==32'h8) $display("Fail");
     $display("pc=%h", pc);

    pc_next=32'hC; @(posedge clk);#1;
    if (pc!==32'hC) $display("Fail");ṇ
     $display("pc=%h", pc);

    rst=1;
    pc_next=32'h4; @(posedge clk);#1;
    if (pc!==32'h0) $display("Fail");
     $display("pc=%h", pc);
    $finish;
end
endmodule





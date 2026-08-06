`timescale 1ns/1ps
module ifetchtb;
reg clk=0,rst=1;
reg [31:0]pc_next;
wire [31:0]pc,instr;

instfetch dut(clk,rst,pc_next,pc,instr);
always #5 clk=~clk;
integer errors=0;
task check(input [31:0]exppc, input [31:0]expinst);
    if (pc!==exppc || instr!==expinst)begin
         $display("Failed pc=%0h, instr=%0h from expected pc=%0h instr=%0h",pc,instr,exppc,expinst);
        errors= errors+1;
    end
    else $display("ok pc=%0h, instr=%0h.",pc,instr);
endtask

initial begin

      rst=1; @(posedge clk); #1; 
      check(32'h0,32'h00500093); 
        rst=0;
        pc_next=32'h4; @(posedge clk); #1; 
        check(32'h4,32'h00A00113);
        pc_next=32'h8; @(posedge clk); #1; 
        check(32'h8,32'h002081B3);
        pc_next=32'hC; @(posedge clk); #1; 
        check(32'hC,32'h00000013);
        if (errors==0) $display("All good");
        $finish;
end
endmodule

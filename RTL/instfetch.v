module instfetch(clk,rst,pc_next,pc,instr);
input clk,rst;
input [31:0]pc_next;
output [31:0]instr;
output [31:0] pc;//only for tb purpose this is output,otherwire internally used by imem 
program_counter pcconnect(clk,rst,pc_next,pc);
imem imemconnect(pc,instr);
endmodule
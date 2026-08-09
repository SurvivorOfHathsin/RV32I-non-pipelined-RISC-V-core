module program_counter(clk,rst,pc_next,pc);
input clk,rst;
input wire [31:0]pc_next;
output reg [31:0]pc;
always @(posedge clk) begin
    if (rst) pc=32'h00000000;
    else pc<=pc_next;
end
endmodule
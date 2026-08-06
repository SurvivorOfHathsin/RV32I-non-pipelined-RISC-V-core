`timescale 1ns/1ps
module regfiletb;
reg clk=0;
reg we;
reg [4:0]waddr,raddr1,raddr2;
reg [31:0] wdata;
wire [31:0]rdata1,rdata2;
regfile DUT (.wen(we),.clk(clk),.waddr(waddr),.raddr1(raddr1),.raddr2(raddr2),.rdata1(rdata1),.rdata2(rdata2),.wdata(wdata));
always #5 clk=~clk;
integer errors=0;
task chk(input [31:0] a, input[31:0] e);
     if(a!=e) begin $display("result %0h doesnt match expected %0h",a,e); errors=errors+1; end
     else $display ("ok %0h",a);
endtask

initial begin
    //magna carta into x7 and x11 (my birthday)
    we=1; waddr=5'd7; wdata=32'd12;raddr1=5'd7;
    @(posedge clk);#1;chk(rdata1,32'd12);

    waddr=5'd11; wdata=32'd15; raddr1=5'd11;
    @(posedge clk);#1;chk(rdata1,32'd15);

    //testing read only-ability of x0
    waddr=5'd0; wdata=32'd1215; raddr1=5'd0;
    @(posedge clk);#1;chk(rdata1,32'd0);
 
    //testing write enable
    we=0; waddr=5'd11;wdata=32'd1984;raddr1=5'd11;
    @(posedge clk);#1;chk(rdata1,32'd15);

    //reading both data lines
    raddr1=5'd7;raddr2=5'd11; 
    @(posedge clk);#1;
    chk(rdata1,32'd12);chk(rdata2,32'd15);
    $finish;

end
endmodule


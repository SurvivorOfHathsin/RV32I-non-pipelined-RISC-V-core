`timescale 1ns/1ps
module control_tb;
reg [6:0]op; reg [2:0]f3; reg [6:0]f7;
wire rw,as,mr,mw,br,jp;
wire [1:0]wbs; wire [3:0]ao; wire [2:0]is;

control dut(
    .opcode(op),
    .funct3(f3),
    .funct7(f7),
    .reg_write(rw),
    .alu_src(as),
    .mem_read(mr),
    .mem_write(mw),
    .branch(br),
    .jump(jp),
    .wb_sel(wbs),
    .alu_op(ao),
    .imm_sel(is)
);

integer err=0;
task chk(input e_rw,e_as,e_mr,e_mw,e_br,e_jp);
        if({rw,as,mr,mw,br,jp}!=={e_rw,e_as,e_mr,e_mw,e_br,e_jp})
            begin 
                $display("FAIL op=%b signals=%b%b%b%b%b%b",op,rw,as,mr,mw,br,jp);
                err=err+1;
            end
        else $display("ok   op=%b rw=%b as=%b mr=%b mw=%b br=%b jp=%b",op,rw,as,mr,mw,br,jp);
    endtask
initial 
    begin 
    f3=0; f7=0;

    
        op=7'b0110011;#1;chk(1,0,0,0,0,0); // R-type
        op=7'b0010011;#1;chk(1,1,0,0,0,0); // I-type ALU
        op=7'b0000011;#1;chk(1,1,1,0,0,0); // LOAD
        op=7'b0100011;#1;chk(0,1,0,1,0,0); // STORE
        op=7'b1100011;#1;chk(0,0,0,0,1,0); // BRANCH
        op=7'b1101111;#1;chk(1,0,0,0,0,1); // JAL
        if(err==0) $display("all passed"); 
        else $display("%0d failed",err);
        $finish;
end
endmodule

module RI_core(
    input clk,rst
);
wire [31:0] pc, pc_next, instr;
assign pc_next=pc+32'd4;
instfetch if0(clk,rst,pc_next,pc,instr);

//decoding
wire[6:0] opcode =instr[6:0];
wire [4:0] rd =instr[11:7];
wire [2:0] funct3 =instr[14:12];
wire [4:0] rs1 = instr[19:15];
wire [4:0] rs2= instr[24:20];
wire [6:0] funct7=instr[31:25];

//control unit
wire reg_write, alu_src;
wire [3:0] alu_op;
wire [2:0] imm_sel;
wire mem_read, mem_write, branch, jump;
wire [1:0] wb_sel;
control ctrl(
     .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .reg_write(reg_write),
    .alu_src(alu_src),
    .mem_read(mem_read),
   .mem_write(mem_write),
   .branch(branch),
    .jump(jump),
    .wb_sel(wb_sel),
    .alu_op(alu_op),
   .imm_sel(imm_sel)
);

//regfile
wire [31:0] rdata1,rdata2,wb_data;
regfile rf (
    .clk(clk),
    .wen(reg_write),
    .waddr(rd),
    .wdata(wb_data),
    .raddr1(rs1),
    .raddr2(rs2),
    .rdata1(rdata1),
    .rdata2(rdata2)
);

//immediate gen
wire [31:0] imm;
immgen ig0(
    .instr(instr),
    .imm_sel(imm_sel),
    .immediate(imm)
);

//ALU source mux
wire [31:0] alu_b=alu_src?imm:rdata2;

//ALU
wire [31:0]alu_result;
wire zero;
alu alu0(
    .a(rdata1),
    .b(alu_b),
    .aluop(alu_op),
    .result(alu_result),
    .zero(zero)
);

//write back from only alu
assign wb_data=alu_result;
endmodule

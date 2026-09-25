module RISCVCORE(
    input clk,rst
);
wire [31:0] pc, pc_next, instr;

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
wire [31:0] alu_b   = alu_src ? imm : rdata2;
wire alu_src_a = (opcode == 7'b0010111);
wire [31:0] alu_a = alu_src_a ? pc : rdata1;
wire [31:0]alu_result;
wire zero,alu_lt, alu_ltu;
alu alu0(
    .a(alu_a),
    .b(alu_b),
    .aluop(alu_op),
    .result(alu_result),
    .zero(zero),
    .alu_lt(alu_lt),
    .alu_ltu(alu_ltu)
);

//Data Memory
wire [31:0]dmem_rdata;
dmem dmem0(
    .clk(clk),
    .we(mem_write),
    .addr(alu_result),
    .wdata(rdata2),
    .funct3(funct3),
    .rdata(dmem_rdata)
);
//Branch unit
wire branch_taken;
wire [31:0] branch_target;

branch_unit bu0 (
    .funct3(funct3),
    .zero(zero),
    .alu_lt(alu_lt),
    .alu_ltu(alu_ltu),
    .pc(pc),
    .b_imm(imm),
    .branch_taken(branch_taken),
    .branch_target(branch_target)
);
// PC Update Logic
wire pc_sel_branch = branch & branch_taken;
wire [31:0] jal_target  = pc + imm;
wire [31:0] jalr_target = {alu_result[31:1], 1'b0};

assign pc_next = (opcode == 7'b1100111) ? jalr_target :      // JALR
                 (jump)                 ? jal_target :       // JAL
                 (pc_sel_branch)        ? branch_target :    // Taken Branch
                                          (pc + 32'd4);      // Default PC + 4
//write back 
assign wb_data = (wb_sel == 2'b00) ? alu_result :
                 (wb_sel == 2'b01) ? dmem_rdata :
                 (wb_sel == 2'b10) ? (pc + 32'd4) :
                 (wb_sel == 2'b11) ? imm :
                                     32'b0;
endmodule

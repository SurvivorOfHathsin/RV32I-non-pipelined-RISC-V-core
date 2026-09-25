
module branch_unit (
    input  [ 2:0] funct3,
    input         zero,        // ALU: rs1 == rs2
    input         alu_lt,      // ALU: rs1 < rs2 (signed)
    input         alu_ltu,     // ALU: rs1 < rs2 (unsigned)
    input  [31:0] pc,
    input  [31:0] b_imm,       // sign-extended B-immediate
    output reg    branch_taken,
    output [31:0] branch_target
);
assign branch_target = pc + b_imm;

always @(*) begin
    case (funct3)
        3'b000: branch_taken =  zero;         // BEQ
        3'b001: branch_taken = ~zero;         // BNE
        3'b100: branch_taken =  alu_lt;       // BLT
        3'b101: branch_taken = ~alu_lt;       // BGE
        3'b110: branch_taken =  alu_ltu;      // BLTU
         3'b111: branch_taken = ~alu_ltu;      // BGEU
        default: branch_taken = 1'b0;
        endcase
end
endmodule
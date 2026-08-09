module immgen(
    input [31:0] instr,
    input [2:0] imm_sel,
    output reg [31:0] immediate
);

always @(*) begin
    case (imm_sel)
       3'b000: immediate= {{20{instr[31]}},instr[31:20]};
       3'b001: immediate= {{20{instr[31]}},instr[31:25],instr[11:7]};
       3'b010: immediate= {{19{instr[31]}}, instr[31], instr[7],instr[30:25], instr[11:8], 1'b0};
       3'b011: immediate = {instr[31:12], 12'b0};
       3'b100: immediate = {{11{instr[31]}}, instr[31], instr[19:12],instr[20], instr[30:21], 1'b0};
    endcase
end
endmodule

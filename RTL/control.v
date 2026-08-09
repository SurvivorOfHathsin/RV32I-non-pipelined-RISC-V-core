module control(
    input  [6:0]opcode,
    input  [2:0]funct3,
    input  [6:0]funct7,
    output reg reg_write,
    output reg alu_src,
    output reg mem_read,
    output reg mem_write,
    output reg branch,
    output reg jump,
    output reg [1:0]wb_sel,
    output reg [3:0]alu_op,
    output reg [2:0]imm_sel
);

localparam R = 7'b0110011;
localparam I = 7'b0010011;
localparam LOAD = 7'b0000011;
localparam STORE = 7'b0100011;
localparam BR = 7'b1100011;
localparam JAL = 7'b1101111;
localparam JALR= 7'b1100111;  
localparam LUI = 7'b0110111;  
localparam AUIP= 7'b0010111;  


always @(*) begin
    {reg_write,alu_src,mem_read,mem_write,branch,jump}=6'b0;
    wb_sel=2'b00; alu_op=4'b0000; imm_sel=3'b000;
    //safe assignment
    case (opcode)
        R: begin
            reg_write=1; alu_src=0; wb_sel=2'b00;
            case({funct7[5],funct3})
                4'b0000: alu_op=4'b0000; // ADD
                4'b1000: alu_op=4'b0001; // SUB
                4'b0111: alu_op=4'b0010; // AND
                4'b0110: alu_op=4'b0011; // OR
                4'b0100: alu_op=4'b0100; // XOR
                4'b0010: alu_op=4'b0101; // SLT
                4'b0011: alu_op=4'b0110; // SLTU
                4'b0001: alu_op=4'b0111; // SLL
                4'b0101: alu_op=4'b1000; // SRL
                4'b1101: alu_op=4'b1001; // SRA
                default: alu_op=4'b0000;
            endcase
        end

        I:  begin 
            reg_write=1; alu_src=1; wb_sel=2'b00; imm_sel=3'b000;
            case(funct3)
                3'h0: alu_op=4'b0000; // ADDI
                3'h7: alu_op=4'b0010; // ANDI
                3'h6: alu_op=4'b0011; // ORI
                3'h4: alu_op=4'b0100; // XORI
                3'h2: alu_op=4'b0101; // SLTI
                3'h3: alu_op=4'b0110; // SLTIU
                3'h1: alu_op=4'b0111; // SLLI
                3'h5: alu_op=(funct7[5])?4'b1001:4'b1000; // SRAI/SRLI
                default: alu_op=4'b0000;
            endcase
        end

        LOAD: begin 
            reg_write=1; alu_src=1; mem_read=1; wb_sel=2'b01; imm_sel=3'b000; alu_op=4'b0000;
        end

        STORE: begin 
            alu_src=1; mem_write=1; imm_sel=3'b001; alu_op=4'b0000;
        end

        BR:  begin
             branch=1; imm_sel=3'b010;alu_op=(funct3==3'h4||funct3==3'h5)?4'b0101:4'b0001; 
        end
        JAL:  begin 
            reg_write=1; jump=1; wb_sel=2'b10; imm_sel=3'b100;
        end
            
        JALR: begin 
                reg_write=1; alu_src=1; jump=1; wb_sel=2'b10; imm_sel=3'b000; alu_op=4'b0000; 
        end
                
        LUI:  begin
                 reg_write=1; wb_sel=2'b11; imm_sel=3'b011; 
        end
                 
        AUIP: begin
                 reg_write=1; alu_src=1; wb_sel=2'b00; imm_sel=3'b011; alu_op=4'b0000; 
        end

        default: ;
    endcase
end
endmodule

            




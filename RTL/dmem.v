module dmem#(parameter depth=256)(
    input clk,
    input we,
    input [31:0]addr,
    input [31:0]wdata,
    input [2:0]funct3,
    output reg [31:0]rdata
);

reg [7:0] mem[0:(depth*4)-1];

always @(posedge clk)
begin
    if (we)begin
        case(funct3)
        3'b000:begin
            mem[addr]<=wdata[7:0];
        end
        3'b001:begin
            mem[addr]<=wdata[7:0];
            mem[addr+1]<=wdata[15:8];
        end
        3'b010:begin
            mem[addr]<=wdata[7:0];
            mem[addr+1]<=wdata[15:8];
            mem[addr+2]<=wdata[23:16];
            mem[addr+3]<=wdata[31:24];
        end
        default: ;
        endcase
    end
end
always @(*)
begin
    case(funct3)
    3'b000:begin
        rdata={{24{mem[addr][7]}},mem[addr]};
    end
    3'b001:begin
        rdata={{16{mem[addr+1][7]}},mem[addr+1],mem[addr]};
    end
    3'b010:begin
        rdata={mem[addr+3],mem[addr+2],mem[addr+1],mem[addr]};
    end
    3'b100:begin
        rdata={24'b0,mem[addr]};
    end
    3'b101:begin
        rdata={16'b0,mem[addr+1],mem[addr]};
    end
    default:rdata=32'b0;
    endcase
end
endmodule
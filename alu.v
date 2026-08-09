module alu (
    input  [31:0] a,
    input  [31:0] b,
    input  [3:0] aluop,
    output reg [31:0] result,
    output wire zero
);
wire [4:0]shiftamt =b[4:0];

always@(*)begin
    case (aluop)
    4'b0000: result =a+b;
    4'b0001: result =a-b;
    4'b0010: result =a&b;
    4'b0011: result =a|b;
    4'b0100: result =a^b;
    4'b0101: result =($signed(a)<$signed(b))?32'd1:32'd0;
    4'b0110: result =(a<b);
    4'b0111: result =a<<shiftamt;
    4'b1000: result =a>>shiftamt;
    4'b1001: result =$signed(a)>>>shiftamt;
    default: result= 32'b0;
    endcase
end

assign zero =(result==32'd0);
endmodule

    
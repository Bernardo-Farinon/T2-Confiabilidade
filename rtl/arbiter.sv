module arbiter(
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [31:0] C,

    output reg [31:0] result
);

always @(*) begin
    if (A == B || A == C) result = A;
    else if (B == C) result = B;
    else result = A;
end

endmodule

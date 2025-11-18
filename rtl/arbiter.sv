module arbiter(
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [31:0] C,

    input  wire        we_A,
    input  wire        we_B,
    input  wire        we_C,

    input  wire [4:0]  rd_A,
    input  wire [4:0]  rd_B,
    input  wire [4:0]  rd_C,

    output reg  [31:0] result,
    output reg         write_enable,
    output reg  [4:0]  rd,

    output reg         fault_A,
    output reg         fault_B,
    output reg         fault_C,

    output reg         system_fault
);

always @(*) begin
    fault_A      = 0;
    fault_B      = 0;
    fault_C      = 0;
    system_fault = 0;

    // - A == B == C 
    if ((A == B) && (A == C)) begin
        result       = A;
        write_enable = we_A;
        rd           = rd_A;
    end

    // A o divergente 
    else if ((A != B) && (B == C)) begin
        result       = B;
        write_enable = we_B;
        rd           = rd_B;
        fault_A      = 1;
    end

    // B o divergente
    else if ((B != A) && (A == C)) begin
        result       = A;
        write_enable = we_A;
        rd           = rd_A;
        fault_B      = 1;
    end

    // C o divergente
    else if ((C != A) && (A == B)) begin
        result       = A;
        write_enable = we_A;
        rd           = rd_A;
        fault_C      = 1;
    end

    // todos diferentes 
    else begin
        result       = A;
        write_enable = we_A;
        rd           = rd_A;
        fault_A      = 1;
        fault_B      = 1;
        fault_C      = 1;
        system_fault = 1;
    end
end

endmodule

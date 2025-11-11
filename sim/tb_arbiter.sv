`include "../rtl/RS5_pkg.sv"

module tb_redundancia
    import RS5_pkg::*;
();

    timeunit 1ns; timeprecision 1ns;

    //////////////////////////////////////
    // CLOCK
    //////////////////////////////////////
    logic clk = 1;
    always #5 clk = ~clk;

    //////////////////////////////////////
    // RESET
    //////////////////////////////////////
    logic reset_n;
    initial begin
        reset_n = 0;
        #100;
        reset_n = 1;
    end

    //////////////////////////////////////
    // CONSTANTES
    //////////////////////////////////////
    localparam int MEM_WIDTH = 65536;
    localparam string BIN_FILE = "../app/berkeley_suite/test.bin"; 
`ifndef SYNTH
    localparam bit DEBUG = 1'b0;
`endif

    //////////////////////////////////////
    // SIGNALS
    //////////////////////////////////////
    logic [31:0] instruction;
    logic [31:0] mem_data_read;
    logic [31:0] mem_address, mem_data_write;

    logic mem_operation_enable;
    logic [3:0] mem_write_enable;

    logic [31:0] outA, outB, outC;
    logic [31:0] arb_result;

    //////////////////////////////////////
    // RS5 INSTANCE
    //////////////////////////////////////
    RS5 dut (
        .clk                    (clk),
        .reset_n                (reset_n),
        .sys_reset_i            (1'b0),
        .stall                  (1'b0),

        .instruction_i          (instruction),
        .mem_data_i             (mem_data_read),
        .mtime_i                (64'h0),
        .irq_i                  (32'h0),

        .instruction_address_o  (instruction_address),
        .mem_operation_enable_o (mem_operation_enable),
        .mem_write_enable_o     (mem_write_enable),
        .mem_address_o          (mem_address),
        .mem_data_o             (mem_data_write),
        .interrupt_ack_o        (),

        .result_A_o             (outA),
        .result_B_o             (outB),
        .result_C_o             (outC)
    );

    //////////////////////////////////////
    // ARBITER
    //////////////////////////////////////
    arbiter arb (
        .A(outA),
        .B(outB),
        .C(outC),
        .result(arb_result)
    );

    //////////////////////////////////////
    // RAM (PORTA A = INSTRUÇÕES) (PORTA B = DADOS)
    //////////////////////////////////////
    RAM_mem #(
    `ifndef SYNTH
        .DEBUG     (DEBUG),
        .DEBUG_PATH("./debug/"),
    `endif
        .MEM_WIDTH (MEM_WIDTH),
        .BIN_FILE  (BIN_FILE)
    ) RAM (
        .clk        (clk),

        .enA_i      (1'b1),
        .weA_i      (4'h0),
        .addrA_i    (instruction_address[($clog2(MEM_WIDTH)-1):0]),
        .dataA_i    (32'h00000000),
        .dataA_o    (instruction),

        .enB_i      (mem_operation_enable),
        .weB_i      (mem_write_enable),
        .addrB_i    (mem_address[($clog2(MEM_WIDTH)-1):0]),
        .dataB_i    (mem_data_write),
        .dataB_o    (mem_data_read)
    );

    //////////////////////////////////////
    // DEBUG OUTPUT
    //////////////////////////////////////
    always @(posedge clk) begin
        if (reset_n)
            $display("T=%0t | A=%h  B=%h  C=%h  => Votado=%h",
                     $time, outA, outB, outC, arb_result);
    end

    //////////////////////////////////////
    // STOP
    //////////////////////////////////////
    initial begin
        #4000;
        $display("\n--- FIM DA SIMULACAO ---");
        $finish;
    end

endmodule

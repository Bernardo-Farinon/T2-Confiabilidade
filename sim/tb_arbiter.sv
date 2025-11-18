`include "../rtl/RS5_pkg.sv"

module tb_arbiter
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
        #100 reset_n = 1;
    end

    //////////////////////////////////////
    // CONSTANTES
    //////////////////////////////////////
    localparam int MEM_WIDTH = 65536;
    localparam string BIN_FILE = "../app/riscv-tests/test.bin"; 

    //////////////////////////////////////
    // SINAIS
    //////////////////////////////////////
    logic [31:0] instruction;
    logic [31:0] mem_data_read;
    logic [31:0] mem_address, mem_data_write;
    logic [3:0]  mem_write_enable;
    logic        mem_operation_enable;

    logic [31:0] outA, outB, outC;
    logic [31:0] voted_result;

    logic [31:0] instruction_address;

    integer fail_A = 0;
    integer fail_B = 0;
    integer fail_C = 0;
    integer fail_system = 0;

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
        .result_C_o             (outC),
        .result_voted_o         (voted_result),

        .fault_A_o              (), 
        .fault_B_o              (),
        .fault_C_o              (),
        .system_fault_o         ()
    );


    //////////////////////////////////////
    // RAM_mem
    //////////////////////////////////////
    RAM_mem #(
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
    // DEBUG TMR
    //////////////////////////////////////
    always @(posedge clk) begin
        if (reset_n) begin
            if (dut.fault_A_o) fail_A++;
            if (dut.fault_B_o) fail_B++;
            if (dut.fault_C_o) fail_C++;
            if (dut.system_fault_o) fail_system++;

            $display("T=%0t | A=%h | B=%h | C=%h | Votado=%h | FA=%b FB=%b FC=%b",
                    $time, outA, outB, outC, voted_result,
                    dut.fault_A_o, dut.fault_B_o, dut.fault_C_o);
        end
    end

    //////////////////////////////////////
    // STOP
    //////////////////////////////////////
    initial begin
        #100000;
        $display("\n--- FIM ---");
        $display("Falhas A = %0d, B = %0d, C = %0d, system = %0d",
                fail_A, fail_B, fail_C, fail_system);
        $finish;
    end


endmodule

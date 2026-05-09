`timescale 1ns / 1ps

module uart_rx_tb;

    // Parameters
    parameter CLK_FREQ     = 10_000_000; // 10 MHz
    parameter BAUD_RATE    = 115200;
    parameter CLKS_PER_BIT = CLK_FREQ / BAUD_RATE; // 86
    parameter CLK_PERIOD   = 100;        // 100 ns for 10 MHz
    
    // UART RX Parameters
    parameter DWIDTH = 8;
    parameter PWIDTH = 7; // Needs 7 bits to hold 86

    // Signals
    reg  clk;
    reg  rst;
    reg  s_data;
    reg  parity_type;
    reg  parity_en;
    reg  [PWIDTH-1:0] prescale;
    
    wire [DWIDTH-1:0] p_data;
    wire data_valid;

    // Verification Variables
    reg [7:0] expected_data;
    integer i;

    // Instantiate the DUT (Device Under Test)
    uart_rx #(
        .DWIDTH(DWIDTH),
        .PWIDTH(PWIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .s_data(s_data),
        .parity_type(parity_type),
        .parity_en(parity_en),
        .prescale(prescale),
        .p_data(p_data),
        .data_valid(data_valid)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    // Task to send a UART frame (Parallel to Serial)
    task send_uart_frame;
        input [7:0] data_to_send;
        input p_type; // 0 for even, 1 for odd
        input p_en;   // 1 to enable parity
        reg parity_bit;
        begin
            expected_data = data_to_send;
            
            // Calculate parity
            if (p_type == 0) // Even parity
                parity_bit = ^data_to_send;
            else             // Odd parity
                parity_bit = ~(^data_to_send);

            // Start Bit (LOW)
            s_data = 0;
            #(CLK_PERIOD * CLKS_PER_BIT);

            // Data Bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                s_data = data_to_send[i];
                #(CLK_PERIOD * CLKS_PER_BIT);
            end

            // Parity Bit
            if (p_en) begin
                s_data = parity_bit;
                #(CLK_PERIOD * CLKS_PER_BIT);
            end

            // Stop Bit (HIGH)
            s_data = 1;
            #(CLK_PERIOD * CLKS_PER_BIT);
            
            // Wait some extra idle time before next frame
            #(CLK_PERIOD * CLKS_PER_BIT * 2);
        end
    endtask

    // Monitor and Verification Process
    initial begin
        forever begin
            // Wait for data_valid from the receiver
            @(posedge data_valid);
            
            $display("--------------------------------------------------");
            $display("FRAME RECEIVED at %0t ns", $time);
            if (p_data === expected_data) begin
                $display("SUCCESS: Data MATCH! Expected: %h, Received: %h", expected_data, p_data);
            end else begin
                $display("ERROR: Data MISMATCH! Expected: %h, Received: %h", expected_data, p_data);
            end
            $display("--------------------------------------------------\n");
        end
    end

    // Stimulus Generation
    initial begin
        // Dump waves for debugging
        $dumpfile("uart_rx_tb.vcd");
        $dumpvars(0, uart_rx_tb);

        // Initialize Inputs
        rst         = 0; // Active low reset
        s_data      = 1; // Idle state of serial line is HIGH
        parity_type = 0;
        parity_en   = 0;
        prescale    = CLKS_PER_BIT;

        // Reset system
        #(CLK_PERIOD * 5);
        rst = 1;
        #(CLK_PERIOD * 5);

        // ----------------------------------------------------
        // Test Case 1: Send 0x5D (Matches Transmitter Image)
        // ----------------------------------------------------
        $display("\n--- Test Case 1: Send 0x5D (No Parity) ---");
        parity_en   = 0;
        parity_type = 0; 
        send_uart_frame(8'h5D, parity_type, parity_en);

        // ----------------------------------------------------
        // Test Case 2: Send 0x70 (Matches Transmitter Image)
        // ----------------------------------------------------
        $display("\n--- Test Case 2: Send 0x70 (No Parity) ---");
        parity_en   = 0;
        parity_type = 0; 
        send_uart_frame(8'h70, parity_type, parity_en);

        // ----------------------------------------------------
        // Test Case 3: Send 0x0F (Matches Transmitter Image)
        // ----------------------------------------------------
        $display("\n--- Test Case 3: Send 0x0F (No Parity) ---");
        parity_en   = 0;
        parity_type = 0;
        send_uart_frame(8'h0F, parity_type, parity_en);
        
        // Let simulation finish
        #(CLK_PERIOD * CLKS_PER_BIT * 5);

        $display("\nAll tests completed.");
        $finish;
    end

endmodule

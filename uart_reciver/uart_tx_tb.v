`timescale 1ns / 1ps

module uart_tx_tb;

    // Parameters
    parameter CLK_FREQ     = 10_000_000; // 10 MHz
    parameter BAUD_RATE    = 115200;
    parameter CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;
    parameter CLK_PERIOD   = 100;        // 100 ns for 10 MHz

    // Signals
    reg        clk;
    reg        rst_n;
    reg        tx_start;
    reg [7:0]  data_in;
    reg        parity_type;
    wire       tx;
    wire       tx_busy;

    // Verification Variables
    reg [7:0]  rx_data;
    reg        rx_parity;
    reg        rx_stop;
    reg        expected_parity;
    reg        frame_valid;
    integer    i;

    // Instantiate the DUT (Device Under Test)
    uart_tx #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .tx_start(tx_start),
        .data_in(data_in),
        .parity_type(parity_type),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    // Frame Verification Process
    initial begin
        frame_valid = 0;
        forever begin
            // Wait for start bit (falling edge on tx line)
            @(negedge tx);
            
            // Wait to the middle of the start bit to sample safely
            #(CLK_PERIOD * CLKS_PER_BIT / 2);
            if (tx !== 1'b0) begin
                $display("ERROR at %0t: Invalid Start Bit", $time);
            end

            // Sample 8 Data Bits
            for (i = 0; i < 8; i = i + 1) begin
                #(CLK_PERIOD * CLKS_PER_BIT);
                rx_data[i] = tx;
            end

            // Sample Parity Bit
            #(CLK_PERIOD * CLKS_PER_BIT);
            rx_parity = tx;

            // Sample Stop Bit
            #(CLK_PERIOD * CLKS_PER_BIT);
            rx_stop = tx;

            // Verify Frame Properties
            expected_parity = parity_type ? ~(^rx_data) : (^rx_data);
            
            frame_valid = 1;
            
            if (rx_data !== data_in) begin
                $display("ERROR at %0t: Data mismatch! Expected: %h, Received: %h", $time, data_in, rx_data);
                frame_valid = 0;
            end
            
            if (rx_parity !== expected_parity) begin
                $display("ERROR at %0t: Parity mismatch! Expected: %b, Received: %b", $time, expected_parity, rx_parity);
                frame_valid = 0;
            end
            
            if (rx_stop !== 1'b1) begin
                $display("ERROR at %0t: Invalid Stop Bit. Line should be HIGH.", $time);
                frame_valid = 0;
            end

            if (frame_valid) begin
                $display("SUCCESS at %0t: Frame perfectly valid. Data: %h, Parity: %b (Type: %s)", 
                         $time, rx_data, rx_parity, parity_type ? "Odd" : "Even");
            end else begin
                $display("FAILURE at %0t: Frame invalid.", $time);
            end
        end
    end

    // Stimulus Generation
    initial begin
        // Dump waves for debugging if using an external tool
        $dumpfile("uart_tx_tb.vcd");
        $dumpvars(0, uart_tx_tb);

        // Initialize Inputs
        rst_n       = 0;
        tx_start    = 0;
        data_in     = 0;
        parity_type = 0;

        // Reset system
        #(CLK_PERIOD * 5);
        rst_n = 1;
        #(CLK_PERIOD * 5);

        // ----------------------------------------------------
        // Test Case 1: Send 0xA5 with Even Parity
        // ----------------------------------------------------
        $display("\n--- Test Case 1: Send 0xA5 with Even Parity ---");
        data_in     = 8'hA5;
        parity_type = 0; // Even
        tx_start    = 1;
        #(CLK_PERIOD);
        tx_start    = 0;
        
        wait(tx_busy == 1);
        wait(tx_busy == 0);
        #(CLK_PERIOD * CLKS_PER_BIT * 2);

        // ----------------------------------------------------
        // Test Case 2: Send 0x3C with Odd Parity
        // ----------------------------------------------------
        $display("\n--- Test Case 2: Send 0x3C with Odd Parity ---");
        data_in     = 8'h3C;
        parity_type = 1; // Odd
        tx_start    = 1;
        #(CLK_PERIOD);
        tx_start    = 0;
        
        wait(tx_busy == 1);
        wait(tx_busy == 0);
        #(CLK_PERIOD * CLKS_PER_BIT * 2);
        
        // ----------------------------------------------------
        // Test Case 3: Send 0xFF with Even Parity
        // ----------------------------------------------------
        $display("\n--- Test Case 3: Send 0xFF with Even Parity ---");
        data_in     = 8'hFF;
        parity_type = 0; // Even
        tx_start    = 1;
        #(CLK_PERIOD);
        tx_start    = 0;
        
        wait(tx_busy == 1);
        wait(tx_busy == 0);
        #(CLK_PERIOD * CLKS_PER_BIT * 2);

        $display("\nAll tests completed.");
        $finish;
    end

endmodule

`timescale 1ns / 1ps

module uart_tx #(
    parameter CLKS_PER_BIT = 87 // Example: 115200 baud with 10MHz clock
) (
    input wire       clk,
    input wire       rst_n,
    input wire       tx_start,    // Pulse high to start transmission
    input wire [7:0] data_in,     // 8-bit parallel data
    input wire       parity_type, // 0 for Even Parity, 1 for Odd Parity
    output reg       tx,          // Serial out
    output reg       tx_busy      // High while transmitting
);

    // FSM States
    localparam IDLE       = 3'b000;
    localparam START_BIT  = 3'b001;
    localparam DATA_BITS  = 3'b010;
    localparam PARITY_BIT = 3'b011;
    localparam STOP_BIT   = 3'b100;

    reg [2:0]  state;
    
    // Internal counters and registers
    reg [15:0] clk_count;
    reg [2:0]  bit_index;
    reg [7:0]  tx_data;
    reg        parity_calc;

    // FSM State and Datapath Update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            clk_count   <= 16'd0;
            bit_index   <= 3'd0;
            tx_data     <= 8'd0;
            parity_calc <= 1'b0;
            tx          <= 1'b1; // Idle state is high
            tx_busy     <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    tx        <= 1'b1;
                    tx_busy   <= 1'b0;
                    clk_count <= 16'd0;
                    bit_index <= 3'd0;
                    
                    if (tx_start) begin
                        tx_busy     <= 1'b1;
                        tx_data     <= data_in;
                        // Calculate Parity: XOR of data bits
                        // If parity_type == 0 (Even), parity = ^data_in
                        // If parity_type == 1 (Odd),  parity = ~(^data_in)
                        parity_calc <= parity_type ? ~(^data_in) : (^data_in);
                        state       <= START_BIT;
                    end
                end

                START_BIT: begin
                    tx <= 1'b0; // Start bit is LOW
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 16'd1;
                    end else begin
                        clk_count <= 16'd0;
                        state     <= DATA_BITS;
                    end
                end

                DATA_BITS: begin
                    tx <= tx_data[bit_index]; // Transmit LSB first
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 16'd1;
                    end else begin
                        clk_count <= 16'd0;
                        if (bit_index < 7) begin
                            bit_index <= bit_index + 3'd1;
                        end else begin
                            bit_index <= 3'd0;
                            state     <= PARITY_BIT;
                        end
                    end
                end

                PARITY_BIT: begin
                    tx <= parity_calc; // Transmit Parity bit
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 16'd1;
                    end else begin
                        clk_count <= 16'd0;
                        state     <= STOP_BIT;
                    end
                end

                STOP_BIT: begin
                    tx <= 1'b1; // Stop bit is HIGH
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 16'd1;
                    end else begin
                        clk_count <= 16'd0;
                        state     <= IDLE;
                        // Keep tx_busy high until we are fully back in IDLE
                    end
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule

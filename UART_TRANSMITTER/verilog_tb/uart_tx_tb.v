module uart_tx_tb;
// Testbench signals
reg clk;
reg rst;
reg [7:0] p_data;
reg data_valid;
reg parity_en;
reg parity_type;
wire s_data;
wire busy;
// Instantiate UART transmitter
uart_tx #(8) uut (
    .clk(clk),
    .rst(rst),
    .p_data(p_data),
    .data_valid(data_valid),
    .parity_en(parity_en),
    .parity_type(parity_type),
    .s_data(s_data),
    .busy(busy)
);
// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end
// Test sequence
initial begin
    // Initialize inputs
    rst        = 0;
    p_data     = 8'b00000000;
    data_valid = 0;
    parity_en  = 0;
    parity_type = 0;
    // Apply reset
    #10 rst = 1;
    // Test case 1: Transmit data with no parity
    #20;
    p_data     = 8'b01010101;
    data_valid = 1;
    parity_en  = 0;
    parity_type = 0;
    #150;
    p_data     = 8'b10101010;
    data_valid = 1;
    parity_en  = 0;
    parity_type = 1;
    #150;
    p_data     = 8'b01010101;
    data_valid = 1;
    parity_en  = 1;
    parity_type = 0;
    #150;
    p_data     = 8'b10101010;
    data_valid = 1;
    parity_en  = 1;
    parity_type = 1;
    #150;
    $finish;
end
// Display the values
initial begin
    $monitor("p_data : %0b , parity_enable : %0b , s_data : %0b , busy : %0b ",
             p_data, parity_en, s_data, busy);
end
initial begin
    $dumpfile("uart_tx_tb.vcd");
    $dumpvars;
end
endmodule

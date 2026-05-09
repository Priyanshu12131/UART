`define TIMEPERIOD 8
module uart_rx_tb;
reg clk, rst, s_data, parity_type, parity_en;
reg [5:0] prescale;
wire [7:0] p_data;
wire data_valid;

uart_rx #(8, 6) uut (
    .clk(clk), .rst(rst), .s_data(s_data), .parity_type(parity_type),
    .parity_en(parity_en), .prescale(prescale), .p_data(p_data), .data_valid(data_valid)
);

initial begin clk = 0; forever #(`TIMEPERIOD/2) clk = ~clk; end

initial begin
    rst=0; s_data=1; parity_type=0; parity_en=0; prescale=8;
    #10 rst=1;
    #(prescale*2);
    parity_en=0; parity_type=0; send_uart_frame(8'b10101010, 0, 0, 1);
    #(prescale*20);
    parity_en=0; parity_type=1; send_uart_frame(8'b01010101, 0, 1, 1);
    #(prescale*20);
    parity_en=1; parity_type=1; send_uart_frame(8'b10101010, 1, 1, 1);
    #(prescale*20);
    parity_en=1; parity_type=0; send_uart_frame(8'b01010101, 1, 0, 1);
    #(prescale*30);
    $finish;
end

task send_uart_frame;
    input [7:0] data;
    input parity_en_t;
    input parity_type_t;
    input stop_bit;
    integer i;
    begin
        s_data = 0; #(prescale * `TIMEPERIOD);
        for (i = 0; i < 8; i = i+1) begin
            s_data = data[i]; #(prescale * `TIMEPERIOD);
        end
        if (parity_en_t) begin
            if(parity_type_t) s_data = ~^(data);
            else               s_data =  ^(data);
            #(prescale * `TIMEPERIOD);
        end
        s_data = stop_bit; #(prescale * `TIMEPERIOD);
    end
endtask

initial begin $dumpfile("uart_rx_tb.vcd"); $dumpvars; end
endmodule

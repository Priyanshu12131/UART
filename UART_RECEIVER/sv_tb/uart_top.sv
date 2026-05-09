`timescale 1ns/1ps
module top;
    bit clk, rst;
    uart_env env;
    event e;

    uart_rx #(`D_WIDTH, `P_WIDTH) dut (
        .clk(pif.clk),
        .rst(pif.rst),
        .s_data(pif.s_data),
        .parity_type(pif.parity_type),
        .parity_en(pif.parity_en),
        .prescale(pif.prescale),
        .p_data(pif.p_data),
        .data_valid(pif.valid_data)
    );
    uart_intf #(`D_WIDTH, `P_WIDTH) pif(clk, rst);

    initial begin clk=0; forever #(`TIME_PERIOD/2) clk=~clk; end
    initial begin 
        $display("[%0t] Top: Reset starting", $time);
        rst=0; repeat(2) @(posedge clk); 
        rst=1; 
        $display("[%0t] Top: Reset released, starting environment", $time);
        env=new(); 
        env.run(); 
    end
    initial begin
        #(3000 * `TIME_PERIOD); // wait enough time for all 7 frames to process (each takes ~200 clocks)
        $finish;
    end
endmodule

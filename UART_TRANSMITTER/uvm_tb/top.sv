module top;
    bit clk, rst;
    uart_tx #(`D_WIDTH) dut (
        .clk(clk), .rst(rst),
        .p_data(pif.p_data), .data_valid(pif.valid_data),
        .parity_en(pif.parity_en), .parity_type(pif.parity_type),
        .s_data(pif.s_data), .busy(pif.busy)
    );
    uart_intf pif(clk, rst);
    always #5 clk = ~clk;
    initial begin rst=0; repeat(2) @(posedge clk); rst=1; end
    initial begin
        uvm_config_db#(virtual uart_intf)::set(null,"*","VIF",pif);
        run_test("uart_odd_parity_test");
    end
endmodule

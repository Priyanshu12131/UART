module top;
    bit clk;
    bit rst;
    uart_env env;
    event e;

    uart_tx #(`D_WIDTH) dut (
        .clk(clk),
        .rst(rst),
        .p_data(pif.p_data),
        .data_valid(pif.valid_data),
        .parity_en(pif.parity_en),
        .parity_type(pif.parity_type),
        .s_data(pif.s_data),
        .busy(pif.busy)
    );

    uart_intf pif(clk, rst);

    initial begin
        clk = 1'b0;
        forever #(`TIME_PERIOD/2) clk = ~clk;
    end

    initial begin
        rst = 1'b0;
        repeat(2) @(posedge clk);
        rst = 1'b1;
        ->e;
    end

    initial begin
        wait(e.triggered);
        env = new();
        env.run();
    end

    initial begin
        uart_common::testname = "no_parity1";  #140;
        uart_common::testname = "no_parity2";  #140;
        uart_common::testname = "even_parity"; #140;
        uart_common::testname = "odd_parity";  #140;
        $finish;
    end
endmodule

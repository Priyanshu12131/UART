class uart_agent;
    uart_gen gen;
    uart_bfm bfm;
    uart_mon mon;
    uart_cov cov;
    task run();
        gen = new();
        bfm = new();
        mon = new();
        cov = new();
        fork
            gen.run();
            bfm.run();
            mon.run();
            cov.run();
        join
    endtask
endclass

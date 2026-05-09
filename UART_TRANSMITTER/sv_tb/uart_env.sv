class uart_env;
    uart_agent agent;
    uart_sbd   sbd;
    task run();
        agent = new();
        sbd   = new();
        fork
            agent.run();
            sbd.run();
        join
    endtask
endclass

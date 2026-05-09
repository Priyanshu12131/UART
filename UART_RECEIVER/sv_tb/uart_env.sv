`ifndef UART_ENV_SV
`define UART_ENV_SV
class uart_env;
    uart_agent agent;
    uart_sbd   sbd;
    task run();
        agent = new(); sbd = new();
        fork agent.run(); sbd.run(); join
    endtask
endclass
`endif

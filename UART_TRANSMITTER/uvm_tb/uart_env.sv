class uart_env extends uvm_env;
    `uvm_component_utils(uart_env)
    uart_agent uart_agent_h;
    uart_sbd   uart_sbd_h;
    function new(string name="",uvm_component parent);
        super.new(name,parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_name,"BUILD_PHASE",UVM_NONE)
        uart_agent_h = uart_agent::type_id::create("uart_agent_h",this);
        uart_sbd_h   = uart_sbd::type_id::create("uart_sbd_h",this);
    endfunction
    function void connect_phase(uvm_phase phase);
        uart_agent_h.uart_mon_h.mon_ap.connect(uart_sbd_h.uart_imp_port);
    endfunction
endclass

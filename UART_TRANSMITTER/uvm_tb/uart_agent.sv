class uart_agent extends uvm_agent;
    `uvm_component_utils(uart_agent)
    uart_sqr     uart_sqr_h;
    uart_driver  uart_drv_h;
    uart_monitor uart_mon_h;
    uart_cov     uart_cov_h;
    function new(string name="",uvm_component parent);
        super.new(name,parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_name,"BUILD_PHASE",UVM_NONE)
        uart_sqr_h = uart_sqr::type_id::create("uart_sqr_h",this);
        uart_drv_h = uart_driver::type_id::create("uart_drv_h",this);
        uart_mon_h = uart_monitor::type_id::create("uart_mon_h",this);
        uart_cov_h = uart_cov::type_id::create("uart_cov_h",this);
    endfunction
    function void connect_phase(uvm_phase phase);
        `uvm_info(get_name,"CONNECT_PHASE",UVM_NONE)
        uart_drv_h.seq_item_port.connect(uart_sqr_h.seq_item_export);
        uart_mon_h.mon_ap.connect(uart_cov_h.analysis_export);
    endfunction
endclass

class uart_monitor extends uvm_monitor;
    `uvm_component_utils(uart_monitor)
    `NEW_COMP
    virtual uart_intf vif;
    uvm_analysis_port#(uart_tx) mon_ap;
    uart_tx tx;
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_name(),"BUILD_PHASE",UVM_NONE)
        tx     = uart_tx::type_id::create("tx");
        mon_ap = new("mon_ap",this);
        if(!(uvm_config_db#(virtual uart_intf)::get(this,"","VIF",vif)))
            `uvm_error(get_name(),"FAILED TO RETRIEVE INTERFACE HANDLE FROM CONFIG DB")
        else
            `uvm_info(get_name(),"RETRIEVED INTERFACE HANDLE FROM CONFIG DB",UVM_NONE)
    endfunction
    task run_phase(uvm_phase phase);
        `uvm_info(get_name(),"RUN_PHASE",UVM_NONE)
        forever begin
            @(vif.mon_cb) begin
                tx             = new();
                tx.valid_data  = vif.mon_cb.valid_data;
                tx.parity_en   = vif.mon_cb.parity_en;
                tx.parity_type = vif.mon_cb.parity_type;
                tx.p_data      = vif.mon_cb.p_data;
                tx.s_data      = vif.mon_cb.s_data;
                tx.busy        = vif.mon_cb.busy;
            end
            mon_ap.write(tx);
        end
    endtask
endclass

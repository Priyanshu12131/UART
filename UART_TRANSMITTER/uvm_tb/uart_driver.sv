class uart_driver extends uvm_driver#(uart_tx);
    `uvm_component_utils(uart_driver)
    virtual uart_intf vif;
    `NEW_COMP
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_name,"BUILD_PHASE",UVM_NONE)
        if(!(uvm_config_db#(virtual uart_intf)::get(this,"","VIF",vif)))
            `uvm_error(get_name(),"FAILED TO RETRIEVE INTERFACE HANDLE FROM CONFIG DB")
        else
            `uvm_info(get_name(),"RETRIEVED INTERFACE HANDLE FROM CONFIG DB",UVM_NONE)
    endfunction
    task run_phase(uvm_phase phase);
        `uvm_info(get_name,"RUN_PHASE",UVM_NONE)
        wait(vif.rst == 1);
        forever begin
            seq_item_port.get_next_item(req);
            drive_tx(req);
            seq_item_port.item_done();
        end
    endtask
    task drive_tx(uart_tx tx);
        if(!vif.bfm_cb.busy) begin
            repeat(2) begin
                @(vif.bfm_cb);
                vif.bfm_cb.p_data      <= tx.p_data;
                vif.bfm_cb.parity_en   <= tx.parity_en;
                vif.bfm_cb.parity_type <= tx.parity_type;
            end
        end
        @(vif.bfm_cb);
        vif.bfm_cb.valid_data <= 1'b1;
        @(vif.bfm_cb) begin
            tx.s_data = vif.bfm_cb.s_data;
            tx.busy   = vif.bfm_cb.busy;
        end
        wait(vif.bfm_cb.busy == 1);
        @(vif.bfm_cb);
        vif.bfm_cb.valid_data <= 1'b0;
    endtask
endclass

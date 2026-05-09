class uart_mon;
    uart_tx_item tx;
    virtual uart_intf #(`D_WIDTH) vif;
    function new();
        vif = top.pif;
    endfunction
    task run();
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
            uart_common::mon2sbd.put(tx);
            uart_common::mon2cov.put(tx);
        end
    endtask
endclass

class uart_bfm;
    uart_tx_item tx;
    virtual uart_intf #(`D_WIDTH) vif;
    function new();
        vif = top.pif;
    endfunction
    task run();
        forever begin
            uart_common::gen2bfm.get(tx);
            uart_drive(tx);
        end
    endtask
    task uart_drive(uart_tx_item tx);
        repeat(2) begin
            @(vif.bfm_cb);
            vif.bfm_cb.p_data      <= tx.p_data;
            vif.bfm_cb.parity_en   <= tx.parity_en;
            vif.bfm_cb.parity_type <= tx.parity_type;
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

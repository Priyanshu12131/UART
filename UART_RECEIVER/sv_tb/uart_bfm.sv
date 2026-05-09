`timescale 1ns/1ps
`ifndef UART_BFM_SV
`define UART_BFM_SV
class uart_bfm;
    uart_tx_item tx;
    virtual uart_intf #(`D_WIDTH, `P_WIDTH) vif;
    function new();
        vif = top.pif;
    endfunction
    task run();
        $display("[%0t] BFM: Starting", $time);
        forever begin
            uart_common::gen2bfm.get(tx);
            $display("[%0t] BFM: Got transaction, driving...", $time);
            uart_drive(tx);
        end
    endtask
    task uart_drive(uart_tx_item tx);
        // Set the configuration inputs before driving the frame
        vif.bfm_cb.parity_type <= tx.parity_type;
        vif.bfm_cb.parity_en   <= tx.parity_en;
        vif.bfm_cb.prescale    <= tx.prescale;
        vif.pd_in              = tx.unique_trans_data_q;

        // Drive IDLE for some cycles before frame
        repeat(50) @(vif.bfm_cb) vif.bfm_cb.s_data <= 1'b1;
        
        foreach(tx.unique_trans_data_q[i]) begin
            @(vif.bfm_cb) begin
                vif.bfm_cb.s_data <= tx.unique_trans_data_q[i];
            end
            repeat(`PRESCALE-1) @(vif.bfm_cb);
        end
        
        // Drive IDLE for some cycles after frame
        repeat(50) @(vif.bfm_cb) vif.bfm_cb.s_data <= 1'b1;
    endtask
endclass
`endif

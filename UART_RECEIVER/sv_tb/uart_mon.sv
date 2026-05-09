`timescale 1ns/1ps
`ifndef UART_MON_SV
`define UART_MON_SV
class uart_mon;
    uart_tx_item tx;
    virtual uart_intf #(`D_WIDTH, `P_WIDTH) vif;
    function new();
        vif = top.pif;
    endfunction
    task run();
        $display("[%0t] Monitor: Starting", $time);
        forever begin
            @(vif.mon_cb);
            if (vif.mon_cb.valid_data == 1'b1) begin
                tx             = new();
                tx.s_data      = vif.mon_cb.s_data;
                tx.prescale    = vif.mon_cb.prescale;
                tx.parity_en   = vif.mon_cb.parity_en;
                tx.parity_type = vif.mon_cb.parity_type;
                tx.unique_trans_data_q   = vif.pd_in;
                tx.p_data      = vif.mon_cb.p_data;
                tx.valid_data  = vif.mon_cb.valid_data;
                
                // Extract expected parallel data from the serial frame
                for(int i=0; i<`D_WIDTH; i++) begin
                    tx.expected_p_data[i] = tx.unique_trans_data_q[i+1];
                end
                
                uart_common::mon2sbd.put(tx);
                uart_common::mon2cov.put(tx);
            end
        end
    endtask
endclass
`endif

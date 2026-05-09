`timescale 1ns/1ps
`ifndef UART_SBD_SV
`define UART_SBD_SV
class uart_sbd;
    uart_tx_item tx;
    task run();
        $display("[%0t] Scoreboard: Starting", $time);
        forever begin
            uart_common::mon2sbd.get(tx);
            $display("[%0t] Scoreboard: Got transaction", $time);
            if(tx.valid_data==1) begin
                if(tx.expected_p_data == tx.p_data) begin
                    tx.actual_p_data = tx.p_data; // Keep it consistent for printing if needed
                    tx.data_print("ScoreBoard");
                    $display("[%0t] SCOREBOARD: MATCH! Sent:%8b Received:%8b", $time, tx.expected_p_data, tx.actual_p_data);
                    $display("Success: Received Data correctly from testname : %0s\n", uart_common::testname);
                end else begin
                    tx.actual_p_data = tx.p_data;
                    tx.data_print("ScoreBoard");
                    $display("[%0t] SCOREBOARD: MISMATCH! Sent:%8b Received:%8b", $time, tx.expected_p_data, tx.actual_p_data);
                    $display("Error: Received Data wrong from testname : %0s\n", uart_common::testname);
                end
            end
        end
    endtask
endclass
`endif

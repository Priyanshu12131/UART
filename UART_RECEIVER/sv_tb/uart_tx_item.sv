`timescale 1ns/1ps
`ifndef UART_TX_ITEM_SV
`define UART_TX_ITEM_SV
class uart_tx_item;
    bit unique_trans_data_q[$];
    rand bit [10:0] raw_data; // Using bit array for easier randomization
    bit s_data;
    rand bit parity_type;
    rand bit parity_en;
    rand bit [`P_WIDTH-1:0] prescale;
    bit [`D_WIDTH-1:0] p_data;
    bit valid_data;
    bit [`D_WIDTH-1:0] actual_p_data;
    bit [`D_WIDTH-1:0] expected_p_data;

    constraint start_stop_bit {
        soft raw_data[0] == 0; // Start bit
        soft (parity_en == 0) -> (raw_data[9] == 1); // Stop bit if no parity
        soft (parity_en == 1) -> (raw_data[10] == 1); // Stop bit if parity
    }

    constraint parity_generator {
        if(parity_en == 1) {
            (parity_type == 0) -> (raw_data[9] == (^raw_data[8:1])); // Even parity
            (parity_type == 1) -> (raw_data[9] == ~(^raw_data[8:1])); // Odd parity
        }
    }

    function void post_randomize();
        expected_p_data = raw_data[8:1];
        unique_trans_data_q.delete();
        unique_trans_data_q.push_back(raw_data[0]); // Start
        for (int i=1; i<=8; i++) unique_trans_data_q.push_back(raw_data[i]); // Data
        if (parity_en) unique_trans_data_q.push_back(raw_data[9]); // Parity
        unique_trans_data_q.push_back(parity_en ? raw_data[10] : raw_data[9]); // Stop
    endfunction

    function void print(input string name="tx");
        actual_p_data = {<<{p_data}};
        $display("###%s### Valid=%0b Parity_en=%0s Parity_type=%0s Expected=%8b Received=%8b",
                  name, valid_data, parity_en?"YES":"NO", parity_type?"ODD":"EVEN",
                  expected_p_data, actual_p_data);
    endfunction

    function void data_print(input string name="tx");
        $display("--------------------------------------------------");
        $display("[%0t] %s: UART FRAME BREAKDOWN", $time, name);
        $write("  Serial Stream: [START:0] ");
        for(int i=1; i<=8; i++) $write("D%0d:%b ", i-1, unique_trans_data_q[i]);
        if(parity_en) $write("[PARITY:%b] ", unique_trans_data_q[9]);
        $display("[STOP:1]");
        $display("  Expected Parallel Data: %8b", expected_p_data);
        if (name == "ScoreBoard") begin
            $display("  Received Parallel Data: %8b", actual_p_data);
            if (expected_p_data == actual_p_data) 
                $display("  STATUS: MATCH!");
            else
                $display("  STATUS: MISMATCH!");
        end
        $display("--------------------------------------------------");
    endfunction
endclass
`endif

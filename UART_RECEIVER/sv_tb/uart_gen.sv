`timescale 1ns/1ps
`ifndef UART_GEN_SV
`define UART_GEN_SV
class uart_gen;
    task run();
        $display("[%0t] Generator: Starting", $time);
        
        // Let system reset first
        #200;
        
        // High toggling patterns to verify s_data transitions
        send_frame(8'hAA); // 10101010
        #(`PRESCALE * 8 * 10); 
        
        send_frame(8'h55); // 01010101
        #(`PRESCALE * 8 * 10); 
        
        // Additional diverse patterns
        send_frame(8'hCC); // 11001100
        #(`PRESCALE * 8 * 10); 
        
        send_frame(8'h33); // 00110011
        #(`PRESCALE * 8 * 10); 
        
        // Some standard frames
        send_frame(8'h5D);
        #(`PRESCALE * 8 * 10); 
        
        send_frame(8'h0F);
        #(`PRESCALE * 8 * 10); 
        
        send_frame(8'hD7);
        #(`PRESCALE * 8 * 10); 
        
        #1000;
    endtask

    task send_frame(bit [7:0] data_val);
        uart_tx_item tx = new();
        $display("[%0t] Generator: Creating transaction for %h", $time, data_val);
        
        assert(tx.randomize() with {
            tx.raw_data[8:1] == data_val;
            tx.parity_en == 0;
            tx.parity_type == 0;
            tx.prescale == `PRESCALE;
            tx.raw_data[0] == 0; // Start bit
            tx.raw_data[9] == 1; // Stop bit
        });
        
        uart_common::gen2bfm.put(tx);
        $display("[%0t] Generator: Transaction put in mailbox", $time);
    endtask
endclass
`endif

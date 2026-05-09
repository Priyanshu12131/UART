class uart_gen;
    task run();
        repeat (4) begin
            uart_tx_item tx = new();
            case(uart_common::testname)
                "no_parity1": begin
                    assert(tx.randomize() with {tx.parity_en==0; tx.parity_type==0;});
                    uart_common::gen2bfm.put(tx);
                end
                "no_parity2": begin
                    assert(tx.randomize() with {tx.parity_en==0; tx.parity_type==1;});
                    uart_common::gen2bfm.put(tx);
                end
                "even_parity": begin
                    assert(tx.randomize() with {tx.parity_en==1; tx.parity_type==0;});
                    uart_common::gen2bfm.put(tx);
                end
                "odd_parity": begin
                    assert(tx.randomize() with {tx.parity_en==1; tx.parity_type==1;});
                    uart_common::gen2bfm.put(tx);
                end
            endcase
            #100;
            wait((top.pif.bfm_cb.busy==0) && (top.pif.bfm_cb.valid_data==0));
        end
    endtask
endclass

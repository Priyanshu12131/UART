class uart_cov extends uvm_subscriber#(uart_tx);
    `uvm_component_utils(uart_cov)
    uart_tx tx;
    covergroup cg;
        cov_valid_data : coverpoint tx.valid_data {
            bins valid_data_1_0[] = (1'b1=>1'b0);
            bins valid_data_0_1[] = (1'b0=>1'b1);
        }
        cov_busy_check : coverpoint tx.busy {
            bins busy_1_0[] = (1'b1=>1'b0);
            bins busy_0_1[] = (1'b0=>1'b1);
        }
        cov_parity_en : coverpoint tx.parity_en {
            bins parity_en_yes[] = {1'b1};
            bins parity_en_no[]  = {1'b0};
        }
        cov_parity_type : coverpoint tx.parity_type {
            bins parity_type_odd[]  = {1'b1};
            bins parity_type_even[] = {1'b0};
        }
    endgroup
    function new(string name="",uvm_component parent);
        super.new(name,parent);
        cg = new();
    endfunction
    virtual function void write(uart_tx t);
        $cast(tx,t); cg.sample();
    endfunction
endclass

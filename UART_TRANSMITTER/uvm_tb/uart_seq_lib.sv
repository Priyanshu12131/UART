class uart_base_seq extends uvm_sequence#(uart_tx);
    `uvm_object_utils(uart_base_seq)
    `NEW_OBJ
    uvm_phase phase;
    task pre_body();
        phase = get_starting_phase();
        if(phase != null) begin
            `uvm_info(get_name(),"PREBODY PHASE IS NOT NULL",UVM_NONE)
            phase.raise_objection(this);
        end
    endtask
    task body();
        `uvm_info(get_name(),"BODY With nothing",UVM_NONE)
    endtask
    task post_body();
        phase = get_starting_phase();
        if(phase != null) begin
            `uvm_info(get_name(),"POSTBODY PHASE IS NOT NULL",UVM_NONE)
            phase.phase_done.set_drain_time(this,50);
            phase.drop_objection(this);
        end
    endtask
endclass

class uart_no_parity1 extends uart_base_seq;
    `uvm_object_utils(uart_no_parity1) `NEW_OBJ
    task body(); `uvm_do_with(req,{req.parity_en==0; req.parity_type==0;}) endtask
endclass

class uart_no_parity2 extends uart_base_seq;
    `uvm_object_utils(uart_no_parity2) `NEW_OBJ
    task body(); `uvm_do_with(req,{req.parity_en==0; req.parity_type==1;}) endtask
endclass

class uart_even_parity extends uart_base_seq;
    `uvm_object_utils(uart_even_parity) `NEW_OBJ
    task body(); `uvm_do_with(req,{req.parity_en==1; req.parity_type==0;}) endtask
endclass

class uart_odd_parity extends uart_base_seq;
    `uvm_object_utils(uart_odd_parity) `NEW_OBJ
    task body(); `uvm_do_with(req,{req.parity_en==1; req.parity_type==1;}) endtask
endclass

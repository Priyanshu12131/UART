class uart_base_test extends uvm_test;
    `uvm_component_utils(uart_base_test)
    `NEW_COMP
    uart_env uart_env_h;
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_name,"BUILD_PHASE",UVM_NONE)
        uart_env_h = uart_env::type_id::create("uart_env_h",this);
    endfunction
    function void end_of_elaboration_phase(uvm_phase phase);
        `uvm_info(get_name,"END_OF_ELABORATION_PHASE",UVM_NONE)
        uvm_top.print_topology();
    endfunction
    task run_phase(uvm_phase phase);
        `uvm_info(get_name(),"running uart_base_test - No transactions driven",UVM_NONE)
    endtask
    function void report_phase(uvm_phase phase);
        `uvm_info(get_name(),"REPORT_PHASE",UVM_NONE)
    endfunction
endclass

class uart_no_parity1_test extends uart_base_test;
    `uvm_component_utils(uart_no_parity1_test) `NEW_COMP
    function void build_phase(uvm_phase phase); super.build_phase(phase); endfunction
    task run_phase(uvm_phase phase);
        uart_no_parity1 no_parity1 = uart_no_parity1::type_id::create("no_parity1");
        `uvm_info(get_name(),"RUN_PHASE START",UVM_NONE)
        phase.raise_objection(this);
        no_parity1.start(uart_env_h.uart_agent_h.uart_sqr_h);
        phase.phase_done.set_drain_time(this,200);
        phase.drop_objection(this);
        `uvm_info(get_name(),"RUN_PHASE END",UVM_NONE)
    endtask
endclass

class uart_no_parity2_test extends uart_base_test;
    `uvm_component_utils(uart_no_parity2_test) `NEW_COMP
    function void build_phase(uvm_phase phase); super.build_phase(phase); endfunction
    task run_phase(uvm_phase phase);
        uart_no_parity2 no_parity2 = uart_no_parity2::type_id::create("no_parity2");
        `uvm_info(get_name(),"RUN_PHASE START",UVM_NONE)
        phase.raise_objection(this);
        no_parity2.start(uart_env_h.uart_agent_h.uart_sqr_h);
        phase.phase_done.set_drain_time(this,200);
        phase.drop_objection(this);
        `uvm_info(get_name(),"RUN_PHASE END",UVM_NONE)
    endtask
endclass

class uart_even_parity_test extends uart_base_test;
    `uvm_component_utils(uart_even_parity_test) `NEW_COMP
    function void build_phase(uvm_phase phase); super.build_phase(phase); endfunction
    task run_phase(uvm_phase phase);
        uart_even_parity even_parity = uart_even_parity::type_id::create("even_parity");
        `uvm_info(get_name(),"RUN_PHASE START",UVM_NONE)
        phase.raise_objection(this);
        fork even_parity.start(uart_env_h.uart_agent_h.uart_sqr_h); join
        phase.phase_done.set_drain_time(this,200);
        phase.drop_objection(this);
        `uvm_info(get_name(),"RUN_PHASE END",UVM_NONE)
    endtask
endclass

class uart_odd_parity_test extends uart_base_test;
    `uvm_component_utils(uart_odd_parity_test) `NEW_COMP
    function void build_phase(uvm_phase phase); super.build_phase(phase); endfunction
    task run_phase(uvm_phase phase);
        uart_odd_parity odd_parity = uart_odd_parity::type_id::create("odd_parity");
        `uvm_info(get_name(),"RUN_PHASE START",UVM_NONE)
        phase.raise_objection(this);
        fork odd_parity.start(uart_env_h.uart_agent_h.uart_sqr_h); join
        phase.phase_done.set_drain_time(this,200);
        phase.drop_objection(this);
        `uvm_info(get_name(),"RUN_PHASE END",UVM_NONE)
    endtask
endclass

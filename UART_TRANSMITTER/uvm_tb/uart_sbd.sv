class uart_sbd extends uvm_scoreboard;
    `uvm_component_utils(uart_sbd)
    uvm_analysis_imp#(uart_tx,uart_sbd) uart_imp_port;
    uart_tx tx;
    bit start_bit, parity_bit, parity_bit_expected, stop_bit;
    bit data_q[`D_WIDTH];
    bit [`D_WIDTH-1:0] data;
    uart_tx data_queue[$];
    bit s_data_queue[$:`D_WIDTH+3];

    function new(string name="",uvm_component parent);
        super.new(name,parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uart_imp_port = new("uart_imp_port",this);
    endfunction
    function void write(uart_tx tx);
        if (tx.busy) data_queue.push_front(tx);
        if (data_queue.size() != 0) begin
            tx = data_queue.pop_back();
            s_data_queue.push_front(tx.s_data);
            if (tx.parity_en) begin
                if (s_data_queue.size() == `D_WIDTH+3) begin
                    start_bit = s_data_queue.pop_back();
                    foreach (data_q[i]) data_q[`D_WIDTH-(i+1)] = s_data_queue.pop_back();
                    parity_bit = s_data_queue.pop_back();
                    stop_bit   = s_data_queue.pop_back();
                    data = {>>{data_q}};
                    `uvm_info(get_name(),$sformatf("start=%b data=%b parity=%b stop=%b",start_bit,data,parity_bit,stop_bit),UVM_NONE)
                    if (start_bit==0) `uvm_info(get_name(),$sformatf("PASSED START: %b",start_bit),UVM_NONE)
                    else              `uvm_error(get_name(),$sformatf("FAILED START: %b",start_bit))
                    if (tx.p_data==data) `uvm_info(get_name(),$sformatf("PASSED DATA: %b==%b",data,tx.p_data),UVM_NONE)
                    else                 `uvm_error(get_name(),$sformatf("FAILED DATA: %b!=%b",data,tx.p_data))
                    parity_bit_expected = (tx.parity_type==0) ? ^tx.p_data : ~(^tx.p_data);
                    if (parity_bit==parity_bit_expected) `uvm_info(get_name(),$sformatf("PASSED PARITY: %b==%b",parity_bit,parity_bit_expected),UVM_NONE)
                    else                                 `uvm_error(get_name(),$sformatf("FAILED PARITY: %b!=%b",parity_bit,parity_bit_expected))
                    if (stop_bit==1) `uvm_info(get_name(),$sformatf("PASSED STOP: %b",stop_bit),UVM_NONE)
                    else             `uvm_error(get_name(),$sformatf("FAILED STOP: %b",stop_bit))
                end
            end else begin
                if (s_data_queue.size() == `D_WIDTH+2) begin
                    start_bit = s_data_queue.pop_back();
                    foreach (data_q[i]) data_q[`D_WIDTH-(i+1)] = s_data_queue.pop_back();
                    stop_bit = s_data_queue.pop_back();
                    data = {>>{data_q}};
                    `uvm_info(get_name(),$sformatf("start=%b data=%b stop=%b",start_bit,data,stop_bit),UVM_NONE)
                    if (start_bit==0) `uvm_info(get_name(),$sformatf("PASSED START: %b",start_bit),UVM_NONE)
                    else              `uvm_error(get_name(),$sformatf("FAILED START: %b",start_bit))
                    if (tx.p_data==data) `uvm_info(get_name(),$sformatf("PASSED DATA: %b==%b",data,tx.p_data),UVM_NONE)
                    else                 `uvm_error(get_name(),$sformatf("FAILED DATA: %b!=%b",data,tx.p_data))
                    if (stop_bit==1) `uvm_info(get_name(),$sformatf("PASSED STOP: %b",stop_bit),UVM_NONE)
                    else             `uvm_error(get_name(),$sformatf("FAILED STOP: %b",stop_bit))
                end
            end
        end
    endfunction
endclass

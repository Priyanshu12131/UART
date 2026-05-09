class uart_tx extends uvm_sequence_item;
    bit valid_data;
    rand bit parity_en;
    rand bit parity_type;
    rand bit [`D_WIDTH-1:0] p_data;
    bit s_data;
    bit busy;
    `uvm_object_utils_begin(uart_tx)
        `uvm_field_int(valid_data,  UVM_ALL_ON)
        `uvm_field_int(parity_en,   UVM_ALL_ON)
        `uvm_field_int(parity_type, UVM_ALL_ON)
        `uvm_field_int(p_data,      UVM_ALL_ON)
        `uvm_field_int(s_data,      UVM_ALL_ON)
        `uvm_field_int(busy,        UVM_ALL_ON)
    `uvm_object_utils_end
    function new(string name=""); super.new(name); endfunction
endclass

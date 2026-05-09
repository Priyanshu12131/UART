class uart_tx_item;
    bit valid_data;
    rand bit parity_en;
    rand bit parity_type;
    rand bit [`D_WIDTH-1:0] p_data;
    bit s_data;
    bit busy;
    function void print(input string name="tx");
        $display("The Print Statement is from ###%s###", name);
        $display("Valid_data=%0b",           valid_data);
        $display("Parity_enabled=%0s",       parity_en  ? "YES"  : "NO");
        $display("Parity_type=%0s",          parity_type? "ODD"  : "EVEN");
        $display("Given_Parallel_data=%8b",  p_data);
        $display("Serial_Data=%0b",          s_data);
        $display("Busy=%0b",                 busy);
    endfunction
endclass

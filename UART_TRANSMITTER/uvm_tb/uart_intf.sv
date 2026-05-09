interface uart_intf #(parameter DWIDTH = 8)(input clk, rst);
    logic valid_data;
    logic parity_en;
    logic parity_type;
    logic [`D_WIDTH-1:0] p_data;
    logic s_data;
    logic busy;
    clocking bfm_cb @(posedge clk);
        default input #0 output #1;
        output valid_data; output parity_en; output parity_type; output p_data;
        input s_data; input busy;
    endclocking
    clocking mon_cb @(posedge clk);
        default input #0 output #1;
        input valid_data; input parity_en; input parity_type; input p_data;
        input s_data; input busy;
    endclocking
endinterface

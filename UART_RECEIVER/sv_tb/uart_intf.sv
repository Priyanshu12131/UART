`ifndef UART_INTF_SV
`define UART_INTF_SV
interface uart_intf #(parameter DWIDTH=8, parameter PWIDTH=6)(input clk, rst);
    logic s_data = 1'b1;
    logic parity_type;
    logic parity_en;
    logic [PWIDTH-1:0] prescale;
    logic [DWIDTH-1:0] p_data;
    logic valid_data;
    bit pd_in[$];
    clocking bfm_cb @(posedge clk);
        default input #0 output #1;
        input  valid_data;
        input  p_data;
        output prescale;
        output parity_en;
        output parity_type;
        output s_data;
    endclocking
    clocking mon_cb @(posedge clk);
        default input #0 output #1;
        input valid_data;
        input p_data;
        input prescale;
        input parity_en;
        input parity_type;
        input s_data;
    endclocking
endinterface
`endif

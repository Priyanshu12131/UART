`timescale 1ns/1ps
`ifndef UART_COMMON_SV
`define UART_COMMON_SV
`define D_WIDTH 8
`define P_WIDTH 6
`define TIME_PERIOD 100
`define PRESCALE 8
class uart_common;
    static int count;
    static mailbox gen2bfm = new();
    static mailbox mon2sbd = new();
    static mailbox mon2cov = new();
    static string testname;
endclass
`endif

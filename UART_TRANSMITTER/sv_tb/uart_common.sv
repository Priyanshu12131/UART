`define D_WIDTH 8
`define TIME_PERIOD 8
class uart_common;
    static mailbox gen2bfm = new();
    static mailbox mon2sbd = new();
    static mailbox mon2cov = new();
    static string testname;
endclass

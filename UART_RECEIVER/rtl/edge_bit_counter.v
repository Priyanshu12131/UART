`timescale 1ns/1ps
module edge_bit_counter #(parameter PWIDTH = 6)(clk, rst, enable, prescale, bit_counter, edge_counter);
input clk, rst, enable;
input [PWIDTH-1:0] prescale;
output reg [PWIDTH-2:0] bit_counter;
output reg [PWIDTH-1:0] edge_counter;
wire edge_counter_done;
assign edge_counter_done = (edge_counter == prescale-1) ? 1'b1 : 1'b0;
always @(posedge clk, negedge rst) begin
    if(!rst)
        edge_counter <= 0;
    else if(enable) begin
        if(!edge_counter_done)
            edge_counter <= edge_counter + 1;
        else
            edge_counter <= 0;
    end
    else
        edge_counter <= 0;
end
always @(posedge clk, negedge rst) begin
    if(!rst)
        bit_counter <= 0;
    else if(enable) begin
        if(edge_counter_done)
            bit_counter <= bit_counter + 1;
        else
            bit_counter <= bit_counter;
    end
    else
        bit_counter <= 0;
end
endmodule

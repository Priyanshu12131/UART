`timescale 1ns/1ps
module data_sampling #(parameter PWIDTH =6)(clk, rst, prescale, edge_counter, data_sampling_en, rx_in, sampled_bit);
input clk, rst;
input [PWIDTH-1:0] prescale, edge_counter;
input data_sampling_en;
input rx_in;
output reg sampled_bit;
reg [2:0] samples;

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        samples     <= 3'b0;
        sampled_bit <= 1'b1; // Default to idle state (high)
    end
    else if(data_sampling_en) begin
        if(edge_counter == (prescale >> 1) - 1)
            samples[0] <= rx_in;
        else if(edge_counter == (prescale >> 1))
            samples[1] <= rx_in;
        else if(edge_counter == (prescale >> 1) + 1)
            samples[2] <= rx_in;
        else if(edge_counter == (prescale >> 1) + 2)
            sampled_bit <= (samples[0] & samples[1]) | (samples[1] & samples[2]) | (samples[0] & samples[2]);
    end
    else begin
        samples <= 3'b0;
    end
end
endmodule

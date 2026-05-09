`timescale 1ns/1ps
module deserializer #(parameter DWIDTH =8, PWIDTH =6)(clk, rst, deser_en, sampled_bit, prescale, edge_counter, p_data);
input clk, rst;
input deser_en, sampled_bit;
input [PWIDTH-1:0] prescale, edge_counter;
output reg [DWIDTH-1:0] p_data;
    integer bit_index;
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        p_data    <= 0;
        bit_index <= 0;
    end
    else if (deser_en) begin
        if ((bit_index < DWIDTH) && (edge_counter == ((prescale >> 1) + 3))) begin
            p_data[bit_index] <= sampled_bit;
            bit_index         <= bit_index + 1;
        end
    end
    else begin
        bit_index <= 0;
    end
end
endmodule

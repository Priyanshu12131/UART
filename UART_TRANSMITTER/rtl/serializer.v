module serializer #(parameter DWIDTH =8)(clk, rst, p_data, ser_en, s_data, ser_done);
input clk, rst;
input [DWIDTH-1:0]p_data;
input ser_en;
output reg s_data, ser_done;
integer check_done;
always @(posedge clk, negedge rst) begin
    if(!rst) begin
        s_data     <= 1'b1;
        ser_done   <= 1'b0;
        check_done <= 0;
    end
    else begin
        if (ser_en) begin
            if (check_done == DWIDTH-1) begin
                s_data     <= p_data[check_done];
                ser_done   <= 1'b1;
                check_done <= 0;
            end
            else begin
                s_data     <= p_data[check_done];
                ser_done   <= 1'b0;
                check_done <= check_done+1;
            end
        end
        else begin
            s_data   <= 1'b1;
            ser_done <= 1'b0;
        end
    end
end
endmodule

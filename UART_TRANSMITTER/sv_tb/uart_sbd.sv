class uart_sbd;
    uart_tx_item tx;
    bit start_bit, parity_bit, parity_bit_expected, stop_bit;
    bit data_q[`D_WIDTH];
    bit [`D_WIDTH-1:0] data;
    uart_tx_item data_queue[$];
    bit s_data_queue[$:`D_WIDTH+3];

    task run();
        forever begin
            uart_common::mon2sbd.get(tx);
            if (tx.busy) begin
                data_queue.push_front(tx);
            end
            if (data_queue.size() != 0) begin
                tx = data_queue.pop_back();
                s_data_queue.push_front(tx.s_data);
                if (tx.parity_en) begin
                    if (s_data_queue.size() == `D_WIDTH+3) begin
                        start_bit  = s_data_queue.pop_back();
                        foreach (data_q[i]) data_q[`D_WIDTH-(i+1)] = s_data_queue.pop_back();
                        parity_bit = s_data_queue.pop_back();
                        stop_bit   = s_data_queue.pop_back();
                        data = {>>{data_q}};
                        $display("start = %0b", start_bit);
                        $display("data  = %8b", data);
                        $display("parity= %0b", parity_bit);
                        $display("stop  = %0b", stop_bit);
                        if (start_bit == 0) $display("PASSED START: start bit = %0b", start_bit);
                        else                $error  ("FAILED START: start bit = %0b", start_bit);
                        if (tx.p_data == data) $display("PASSED DATA: data = %8b, p_data = %8b", data, tx.p_data);
                        else                   $error  ("FAILED DATA: data = %8b, p_data = %8b", data, tx.p_data);
                        parity_bit_expected = (tx.parity_type == 0) ? ^tx.p_data : ~(^tx.p_data);
                        if (parity_bit == parity_bit_expected) $display("PASSED PARITY: parity = %0b, expected = %0b", parity_bit, parity_bit_expected);
                        else                                   $error  ("FAILED PARITY: parity = %0b, expected = %0b", parity_bit, parity_bit_expected);
                        if (stop_bit == 1) $display("PASSED STOP: stop bit = %0b", stop_bit);
                        else               $error  ("FAILED STOP: stop bit = %0b", stop_bit);
                    end
                end else begin
                    if (s_data_queue.size() == `D_WIDTH+2) begin
                        start_bit = s_data_queue.pop_back();
                        foreach (data_q[i]) data_q[`D_WIDTH-(i+1)] = s_data_queue.pop_back();
                        stop_bit  = s_data_queue.pop_back();
                        data = {>>{data_q}};
                        $display("start = %0b", start_bit);
                        $display("data  = %8b", data);
                        $display("stop  = %0b", stop_bit);
                        if (start_bit == 0) $display("PASSED START: start bit = %0b", start_bit);
                        else                $error  ("FAILED START: start bit = %0b", start_bit);
                        if (tx.p_data == data) $display("PASSED DATA: data = %8b, p_data = %8b", data, tx.p_data);
                        else                   $error  ("FAILED DATA: data = %8b, p_data = %8b", data, tx.p_data);
                        if (stop_bit == 1) $display("PASSED STOP: stop bit = %0b", stop_bit);
                        else               $error  ("FAILED STOP: stop bit = %0b", stop_bit);
                    end
                end
            end
        end
    endtask
endclass

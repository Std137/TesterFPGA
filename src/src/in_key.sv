module key_press(
input in_clk,
input in_rst,
input in_phiz_key,
input in_mem_keyled,
output led_bit,
output key_en
);

logic key_stat, key_press, key_led;


always @(posedge in_clk)
    begin
        if (in_rst) 
            begin
                key_led <= 0;
                key_press <= 0;
                key_stat <=0;
            end
        else
            begin
                if (in_phiz_key) 
                    begin
                        if (!key_press)
                            begin
                                key_led <= ~in_mem_keyled;
                                key_press <= 1;
                                key_stat <= 1;
                            end
                        else
                            begin
                                key_stat <= 0;
                            end
                    end
                else
                    begin
                        key_press <= 0;
                        key_stat <= 0;
                    end
            end
    end

assign led_bit = key_led;
assign key_en = key_stat;

endmodule
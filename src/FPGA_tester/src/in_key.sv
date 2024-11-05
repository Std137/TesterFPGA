module key_drv(
input in_clk,
input in_rst,
input in_key_switch,
input in_key_reset,
output o_key_switch,
output o_key_reset
);

logic key_swt_stat, key_swt_ps;
logic key_rst_stat, key_rst_ps;

assign o_key_switch = key_swt_stat;
assign o_key_reset = key_rst_stat;

always @(posedge in_clk)
    begin
        if (in_rst) 
            begin
                key_swt_ps <= 0;
                key_swt_stat <= 0;
            end
        else
            begin
                if (in_key_switch) 
                    begin
                        if (!key_swt_ps)
                            begin
                                key_swt_stat <= 1;
                                key_swt_ps <= 1;
                            end
                        else
                            begin
                                key_swt_stat <= 0;
                            end
                    end
                else
                    begin
                        key_swt_ps <= 0;
                        key_swt_stat <= 0;
                    end
            end
    end

always @(posedge in_clk)
    begin
        if (in_rst) 
            begin
                key_rst_ps <= 0;
                key_rst_stat <= 0;
            end
        else
            begin
                if (in_key_switch) 
                    begin
                        if (!key_rst_ps)
                            begin
                                key_rst_stat <= 1;
                                key_rst_ps <= 1;
                            end
                        else
                            begin
                                key_rst_stat <= 0;
                            end
                    end
                else
                    begin
                        key_rst_ps <= 0;
                        key_rst_stat <= 0;
                    end
            end
    end

endmodule
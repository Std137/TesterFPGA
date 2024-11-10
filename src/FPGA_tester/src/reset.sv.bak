module reset(
input in_clk,
input in_fsm_rst,
output rst
);

logic [1:0] start_count = 0;


always @(posedge in_clk)
    begin
        if ((in_fsm_rst)) start_count <= 0;
        else
        if (start_count< 2) start_count ++;
    end

assign rst = (start_count < 2)?1:0;

endmodule
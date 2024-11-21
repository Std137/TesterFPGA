module led_drv(
input logic in_clk,
input logic in_rst,
input logic [5:0] in_mem,
output logic [5:0] led_out
);

reg [5:0] led_stat;

always_ff @(posedge in_clk)
  begin
    if (!in_rst) led_stat <= '1;
    else led_stat <= in_mem;
  end

assign led_out = led_stat;
 
endmodule
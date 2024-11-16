module key_drv(
input logic in_clk,
input logic in_rst,
input logic in_key_switch,
input logic in_key_reset,
output logic o_key_switch,
output logic o_key_reset
);

logic stat_reset, stat_switch;

assign o_key_switch = !stat_switch & in_key_switch;
assign o_key_reset = !stat_reset & in_key_reset;

always_ff @(posedge in_clk)
  if (!in_rst) stat_switch <= '0;
  else stat_switch <= in_key_switch;

always_ff @(posedge in_clk)
  if (!in_rst) stat_reset <= '0;
  else stat_reset <= in_key_reset;

endmodule
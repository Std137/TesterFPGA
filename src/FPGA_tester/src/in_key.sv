module key_drv(
input logic in_clk,
input logic in_rst,
input logic in_key_switch,
input logic in_key_reset,
output logic o_key_switch,
output logic o_key_reset
);

logic stat_reset, stat_switch;

//  Р вЂњР ВµР Р…Р ВµРЎР‚Р В°РЎвЂљР С•РЎР‚ Р В·Р В°Р Т‘Р ВµР В¶Р С”Р С‘
always_ff @(posedge in_clk)
  if (stat_switch)
    if  (in_key_switch) begin
                     stat_switch <= '0;
                     o_key_switch <= '1;
                     end
    else             begin
                     stat_switch <= '1;
                     o_key_switch <= '1;
                     end
  else
    if  (in_key_switch) begin
                     stat_switch <= '0;
                     o_key_switch <= '1;
                     end
    else             begin
                     stat_switch <= '1;
                     o_key_switch <= '0;
                     end

always_ff @(posedge in_clk)
  if (stat_reset)
    if  (in_key_reset) begin
                     stat_reset <= '0;
                     o_key_reset <= '1;
                     end
    else             begin
                     stat_reset <= '1;
                     o_key_reset <= '1;
                     end
  else
    if  (in_key_reset) begin
                     stat_reset <= '0;
                     o_key_reset <= '1;
                     end
    else             begin
                     stat_reset <= '1;
                     o_key_reset <= '0;
                     end

endmodule
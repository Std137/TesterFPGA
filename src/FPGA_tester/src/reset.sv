module reset
(
  input  logic in_clk,
  input  logic in_fsm_rst,
  output logic rst
);

logic start, stat;
logic [2:0] count;

//  Генератор задежки
always_ff @(posedge in_clk)
  if (stat)
    if  (in_fsm_rst) begin
                     stat <= '0;
                     start <= '1;
                     end
    else             begin
                     stat <= '1;
                     start <= '1;
                     end
  else
    if  (in_fsm_rst) begin
                     stat <= '0;
                     start <= '1;
                     end
    else             begin
                     stat <= '1;
                     start <= '0;
                     end
 
always_ff @(posedge in_clk) begin
  if (!start) count <= '0;
  else 
    if (count < 3'd4) count <= count + 3'd1;
    else count <= count;
  end

  assign rst = (count < 3'd4)?'0:'1;
endmodule 
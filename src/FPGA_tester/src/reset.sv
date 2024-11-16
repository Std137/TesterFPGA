module reset
(
  input  logic in_clk,
  input  logic in_fsm_rst,
  output logic out_rst
);

logic stat, ovf_b, start;
logic [2:0] count_bit;

assign ovf_b = (count_bit[2]);
assign out_rst = !stat;
assign start =(count_bit[2] === 1'bx);


always_ff @(posedge in_clk) begin
    if (ovf_b||start) count_bit <='0;
    else if (stat) count_bit <= count_bit + 1'b1;
  end
  
//  Генератор задежки

always_ff @(posedge in_clk) begin
    if (!in_fsm_rst||start) stat <= '1;
    else if (ovf_b) stat <= '0;
  end

endmodule 

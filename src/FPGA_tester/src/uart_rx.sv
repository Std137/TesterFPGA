module uart_rx(
  input  logic in_clk,
  input  logic in_rst,
  input  logic in_rx,
  output logic out_rx_ready,
  output logic [7:0] out_rx_data
);


logic [19:0] data_lth; 
logic [6:0]  count_wait;
logic [5:0]  count_bit;
logic ovf_w, ovf_b, stat;

assign out_rx_data = {data_lth[17],data_lth[15],data_lth[13],data_lth[11],data_lth[9],data_lth[7],data_lth[5],data_lth[3]};
assign ovf_b = (count_bit == 20);
assign ovf_w = (count_wait == 121);
assign out_rx_ready = (ovf_b&&stat)?'1:'0;

//State mode

always_ff @(posedge in_clk) begin
    if (!in_rst||ovf_b) stat <= '0;
    else if (~in_rx) stat <= '1;
  end
  
//Shift registr
  
always_ff @(posedge in_clk) 
  begin
    if (!in_rst||~stat) data_lth <= '0;
    else 
       if (ovf_w) data_lth <= {data_lth[18:0], in_rx};
  end

//Wait timer  

always_ff @(posedge in_clk) begin
    if (!in_rst||ovf_w) count_wait <='0;
    else if (stat) count_wait <= count_wait + 1'b1;
  end
  
//Bite counter

always_ff @(posedge in_clk) begin
    if (!in_rst||ovf_b) count_bit <='0;
    else if (ovf_w) count_bit <= count_bit + 1'b1;
  end

endmodule

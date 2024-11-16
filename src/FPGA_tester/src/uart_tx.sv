module uart_tx(
  input logic [5:0] in_mem,
  input logic in_clk,
  input logic in_rst,
  input logic in_utx_st,
  output logic out_rx,
  output logic out_utx_bs,
  output logic out_utx_rd
);


logic [10:0] data_reg; 
logic [7:0] count_wait;
logic [3:0] count_bit;
logic ovf_w, ovf_b, stat;

assign out_rx = data_reg[10];
assign ovf_b = (count_bit == 10);
assign ovf_w = (count_wait == 243);
assign out_utx_bs = stat;
assign out_utx_rd = (ovf_b&&stat)?'1:'0;

//State mode

always_ff @(posedge in_clk) begin
    if (~in_rst||ovf_b) stat <= '0;
    else if (in_utx_st) stat <= '1;
  end
  
//Shift registr
  
always_ff @(posedge in_clk) 
  begin
    if (~in_rst||~stat) data_reg <= {4'b1000, in_mem, 1'b1};
    else 
       if (ovf_w) data_reg <= {data_reg[9:0], data_reg[10]};
  end

//Wait timer  

always_ff @(posedge in_clk) begin
    if (~in_rst||ovf_w) count_wait <='0;
    else if (stat) count_wait <= count_wait + 1'b1;
  end
  
//Bite counter

always_ff @(posedge in_clk) begin
    if (~in_rst||ovf_b) count_bit <='0;
    else if (ovf_w) count_bit <= count_bit + 1'b1;
  end

endmodule
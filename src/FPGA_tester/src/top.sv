module tester_top
(
  input logic clk,
  input logic uart_rx,
  input logic key_rst,
  input logic key_switch,
  output logic uart_tx, 
  output logic [5:0] led
);

wire rst;
wire push_sw;
wire push_rst;
wire mem_w_rd;
wire utx_s_rd;
wire utx_s_bs;
wire [5:0] mem_rd;
wire [7:0] urx;
wire [5:0] mem_wr;
wire mem_w_en;
wire utx_s_en;
wire urx_rc_rd;
wire rst_en;



uart_rx u_rx(
  .in_clk(clk),
  .in_rst(rst),
  .in_rx(uart_rx),
  .out_rx_ready(urx_rc_rd),
  .out_rx_data(urx)
);

  
uart_tx u_tx(
  .in_clk(clk),
  .in_rst(rst),
  .in_mem(mem_rd),
  .in_utx_st(utx_s_en),
  .out_rx(uart_tx),
  .out_utx_bs(utx_s_bs),
  .out_utx_rd(utx_s_rd)
);


mem mem(
.in_clk(clk),
.in_rst(rst),
.in_mem(mem_wr),
.mem_wrt_en(mem_w_en),
.out_mem(mem_rd),
.mem_wrt_rd(mem_w_rd)
);
  
key_drv key_drv(
.in_clk(clk),
.in_rst(rst),
.in_key_switch(key_switch),
.in_key_reset(key_rst),
.o_key_switch(push_sw),
.o_key_reset(push_rst)
);
  
  
  led_drv led_drv(
  .in_clk(clk),
  .in_rst(rst),
  .in_mem(mem_rd),
  .led_out(led)
);

reset reset(
  .in_clk(clk),
  .in_fsm_rst(rst_en),
  .out_rst(rst)
);
  
  
fsm fsm(
  .in_clk(clk),
  .in_rst(rst),
  .in_push_sw(push_sw),
  .in_push_rst(push_rst),
  .in_mem_w_rd(mem_w_rd),
  .in_utx_s_rd(utx_s_rd),
  .in_utx_s_bs(utx_s_bs),
  .in_mem(mem_rd),
  .in_urx(urx),
  .out_mem(mem_wr),
  .out_mem_w_en(mem_w_en),
  .out_utx_s_en(utx_s_en),
  .out_rst(rst_en)
);

endmodule
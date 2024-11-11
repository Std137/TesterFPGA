module tester_top
(
  input clk,               // Р В Р Р‹Р В РЎвЂР РЋР С“Р РЋРІР‚С™Р В Р’ВµР В РЎВР В Р вЂ¦Р РЋРІР‚в„–Р В РІвЂћвЂ“ Р РЋРІР‚С™Р В Р’В°Р В РЎвЂќР РЋРІР‚С™Р В РЎвЂўР В Р вЂ Р РЋРІР‚в„–Р В РІвЂћвЂ“ Р РЋР С“Р В РЎвЂР В РЎвЂ“Р В Р вЂ¦Р В Р’В°Р В Р’В»
  input uart_rx,
  input key_rst,
  input key_switch,
  output uart_tx, 
  output [5:0] led
);

//uart_tx, uart_tx, mem


wire rst;                  // Р В Р Р‹Р В Р’В±Р РЋР вЂљР В РЎвЂўР РЋР С“ (Р В Р’В°Р В РЎвЂќР РЋРІР‚С™Р В РЎвЂР В Р вЂ Р В Р вЂ¦Р РЋРІР‚в„–Р В РІвЂћвЂ“ Р В Р вЂ Р РЋРІР‚в„–Р РЋР С“Р В РЎвЂўР В РЎвЂќР В РЎвЂР В РІвЂћвЂ“)
wire push_sw;              // Р В РЎСљР В Р’В°Р В Р’В¶Р В Р’В°Р РЋРІР‚С™Р В Р’В° Р В РЎвЂќР В Р вЂ¦Р В РЎвЂўР В РЎвЂ”Р В РЎвЂќР В Р’В° switch
wire push_rst;             // Р В РЎСљР В Р’В°Р В Р’В¶Р В Р’В°Р РЋРІР‚С™Р В Р’В° Р В РЎвЂќР В Р вЂ¦Р В РЎвЂўР В РЎвЂ”Р В РЎвЂќР В Р’В° reset
wire mem_w_rd;             // Р В Р’В¤Р В Р’В»Р В Р’В°Р В РЎвЂ“, Р В Р’В·Р В Р’В°Р В РЎвЂ”Р В РЎвЂР РЋР С“Р РЋР Р‰ Р В Р вЂ  Р В РЎвЂ”Р В Р’В°Р В РЎВР РЋР РЏР РЋРІР‚С™Р РЋР Р‰ Р В РЎвЂўР В РЎвЂќР В РЎвЂўР В Р вЂ¦Р РЋРІР‚РЋР В Р’ВµР В Р вЂ¦Р В Р’В°
wire utx_s_rd;             // Р В Р’В¤Р В Р’В»Р В Р’В°Р В РЎвЂ“, uart_tx Р В РЎвЂўР РЋРІР‚С™Р В РЎвЂ”Р РЋР вЂљР В Р’В°Р В Р вЂ Р В РЎвЂќР В Р’В° Р В РўвЂР В Р’В°Р В Р вЂ¦Р В Р вЂ¦Р РЋРІР‚в„–Р РЋРІР‚В¦ Р В РЎвЂўР В РЎвЂќР В РЎвЂўР В Р вЂ¦Р РЋРІР‚РЋР В Р’ВµР В Р вЂ¦Р В Р’В°
wire utx_s_bs;             // Р В Р’В¤Р В Р’В»Р В Р’В°Р В РЎвЂ“, uart_tx Р В Р’В·Р В Р’В°Р В Р вЂ¦Р РЋР РЏР РЋРІР‚С™
wire [5:0] mem_rd;         // Р В Р РѓР В РЎвЂР В Р вЂ¦Р В Р’В° Р В РўвЂР В Р’В°Р В Р вЂ¦Р В Р вЂ¦Р РЋРІР‚в„–Р РЋРІР‚В¦ Р РЋРІР‚РЋР РЋРІР‚С™Р В Р’ВµР В Р вЂ¦Р В РЎвЂР РЋР РЏ Р В РЎвЂ”Р В Р’В°Р В РЎВР РЋР РЏР РЋРІР‚С™Р В РЎвЂ
wire [7:0] urx;            // Р В Р РѓР В РЎвЂР В Р вЂ¦Р В Р’В° Р В РўвЂР В Р’В°Р В Р вЂ¦Р В Р вЂ¦Р РЋРІР‚в„–Р РЋРІР‚В¦ Р РЋРІР‚РЋР РЋРІР‚С™Р В Р’ВµР В Р вЂ¦Р В РЎвЂР РЋР РЏ uart_rx
wire [5:0] mem_wr;         // Р В Р РѓР В РЎвЂР В Р вЂ¦Р В Р’В° Р В РўвЂР В Р’В°Р В Р вЂ¦Р В Р вЂ¦Р РЋРІР‚в„–Р РЋРІР‚В¦ Р В Р’В·Р В Р’В°Р В РЎвЂ”Р В РЎвЂР РЋР С“Р В РЎвЂ Р В Р вЂ  Р В РЎвЂ”Р В Р’В°Р В РЎВР РЋР РЏР РЋРІР‚С™Р РЋР Р‰
wire mem_w_en;             // Р В Р’В¤Р В Р’В»Р В Р’В°Р В РЎвЂ“, Р В Р’В·Р В Р’В°Р В РЎвЂ”Р В РЎвЂР РЋР С“Р РЋР Р‰ Р В Р вЂ  Р В РЎвЂ”Р В Р’В°Р В РЎВР РЋР РЏР РЋРІР‚С™Р РЋР Р‰ Р РЋР вЂљР В Р’В°Р В Р’В·Р РЋР вЂљР В Р’ВµР РЋРІвЂљВ¬Р В Р’ВµР В Р вЂ¦Р В Р’В°
wire utx_s_en;             // Р В Р’В¤Р В Р’В»Р В Р’В°Р В РЎвЂ“, Р В РЎвЂўР РЋРІР‚С™Р В РЎвЂ”Р РЋР вЂљР В Р’В°Р В Р вЂ Р В РЎвЂќР В Р’В° Р В РўвЂР В Р’В°Р В Р вЂ¦Р В Р вЂ¦Р РЋРІР‚в„–Р РЋРІР‚В¦ Р РЋР вЂљР В Р’В°Р В Р’В·Р РЋР вЂљР В Р’ВµР РЋРІвЂљВ¬Р В Р’ВµР В Р вЂ¦Р В Р’В°
wire rst_en;               // Р В Р’В¤Р В Р’В»Р В Р’В°Р В РЎвЂ“, Р В РЎвЂ”Р РЋР вЂљР В РЎвЂўР В РЎвЂР В Р’В·Р В Р вЂ Р В Р’ВµР РЋР С“Р РЋРІР‚С™Р В РЎвЂ Р РЋР С“Р В Р’В±Р РЋР вЂљР В РЎвЂўР РЋР С“
  
mem(
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
  .in_mem(mem_rd),          //Р В РЎСџР В Р’В°Р В РЎВР РЋР РЏР РЋРІР‚С™Р РЋР Р‰ Р РЋР С“Р В РЎвЂўР РЋР С“Р РЋРІР‚С™Р В РЎвЂўР РЋР РЏР В Р вЂ¦Р В РЎвЂР В Р’Вµ Р РЋР С“Р В Р вЂ Р РЋРІР‚С™Р В РЎвЂўР В РўвЂР В РЎвЂР В РЎвЂўР В РўвЂР В РЎвЂўР В Р вЂ  
  .led_out(led)             //Р В Р’В¤Р В РЎвЂР В Р’В·Р В РЎвЂР РЋРІР‚РЋР В Р’ВµР РЋР С“Р В РЎвЂР В Р’Вµ Р В Р вЂ Р РЋРІР‚в„–Р РЋРІР‚В¦Р В РЎвЂўР В РўвЂР РЋРІР‚в„– Р РЋР С“Р В Р вЂ Р В Р’ВµР РЋРІР‚С™Р В РЎвЂўР В РўвЂР В РЎвЂР В РЎвЂўР В РўвЂР В РЎвЂўР В Р вЂ 
);

reset reset(
  .in_clk(clk),
  .in_fsm_rst(rst_en),
  .rst(rst)
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
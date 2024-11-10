module tester_top
(
  input clk,               // Системный тактовый сигнал
  input uart_rx,
  input key_rst,
  input key_switch,
  output uart_tx, 
  output [5:0] led
);

wire rst;                  // Сброс (активный высокий)
wire push_sw;              // Нажата кнопка switch
wire push_rst;             // Нажата кнопка reset
wire mem_w_rd;             // Флаг, запись в память окончена
wire utx_s_rd;             // Флаг, uart_tx отправка данных окончена
wire utx_s_bs;             // Флаг, uart_tx занят
wire [5:0] mem_rd;         // Шина данных чтения памяти
wire [7:0] urx;            // Шина данных чтения uart_rx
wire [5:0] mem_wr;         // Шина данных записи в память
wire mem_w_en;             // Флаг, запись в память разрешена
wire utx_s_en;             // Флаг, отправка данных разрешена
wire rst_en;               // Флаг, произвести сброс
  
led_drv led_drv(
  .in_clk(clk),
  .in_rst(rst),
  .in_mem(mem_rd),          //Память состояние свтодиодов 
  .led_out(led)             //Физичесие выходы светодиодов
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
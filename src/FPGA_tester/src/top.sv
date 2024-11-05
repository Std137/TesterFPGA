module tester_top
(
input clk,
input uart_rx,
input key_rst,
input key_led,
output uart_tx, 
output reg [5:0] led
);

wire [5:0] led_stat;    //проброс регистра состояния светодиодов от памяти...
wire led_bit, key_en;   //проброс данные/готовность дроайвер клавиатуры = память
wire [7:0] uart_data;   //проброс линии данных от выход уарт до памяти
wire rst;               //проброс сброса до всех устройств
wire [5:0] led_reg;     //проброс заданного состояния светодиодов от драйвера, до выхода.
wire fsm_rst;           //проброс программного сброса от fsm к драйверу сброса.


/*
Драйвер сброса.
*/

reset reset(
.in_clk(clk),
.in_key_rst(key_rst),
.in_fsm_rst(fsm_rst),
.rst(rst)
);


/*
Драйвер светодиодов.
*/

led_port lpt(
.in_clk(clk), 
.in_rst(rst),
.in_mem(led_stat), 
.led_out(led_reg)
);

assign led = led_reg;

/*
Драйвер Клавиатуры.  
*/

key_press key_press(
.in_clk(clk),
.in_rst(rst),
.in_phiz_key(key_led),
.in_mem_keyled(led_stat[5]),
.led_bit(led_bit),
.key_en(key_en)
);

/*
Драйвер памяти.  
*/

mem memory(
.in_clk(clk),
.in_rst(rst),
.in_uart(uart_data),
.in_uart_en(u_data_en),
.in_key(led_bit),
.in_key_en(key_en),
.out_mem(led_stat)
);


endmodule
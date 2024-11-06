module tester_top
(
input clk,
input uart_rx,
input key_rst,
input key_switch,
output uart_tx, 
output reg [5:0] led
);

wire uart_rx_rdy;       //Флаг готовности данных в уарт (uart_rx->fsm)
wire key_push;          //Флаг нажатия клавишы вкл/выкл (key_press->fsm)
wire reset_push;        //Флаг нажатой кнопки сброс (key_press->fsm)
wire mem_wrt_rd;        //Флаг завершения записи в память (mem->fsm)
wire uart_tx_done;      //Флаг окончания передачи (uart_tx->fsm)
wire [5:0] mem_out;     //Выход ячейки памяти (mem->fsm, mem->led_port)
wire uart_rx_data;      //Полученные данные из уарт (uart_rx->fsm)
wire uart_tx_bs;        //Флаг уарт tx занят (uart_tx->fsm)
wire mem_wrt_en;        //Флаг разрешения памяти сохранить данные (fsm->mem)
wire rst_fsm;           //Флаг сброса по линии ФСМ (fsm->rst)
wire uart_tx_en;        //флаг разрешения передачи (fsm_uart_tx)
wire mem_in;            //Линия данных записи в память (fsm->mem)
wire rst;               //Линия сброса для всех устройств
wire [5:0] led_reg;     //Линия заданного состояния светодиодов от драйвера, до выхода.

wire [5:0] led_stat;    //проброс регистра состояния светодиодов от памяти...
wire led_bit, key_en;   //проброс данные/готовность дроайвер клавиатуры = память
wire [7:0] uart_data;   //проброс линии данных от выход уарт до памяти

wire fsm_rst;           //проброс программного сброса от fsm к драйверу сброса.

wire uart_tx_busy;
wire uart_tx_start; 

assign led = led_reg;

/*
Драйвер сброса.
*/

reset reset(
.in_clk(clk),
.in_fsm_rst(rst_fsm),
.rst(rst)
);


/*
Драйвер светодиодов.
*/

led_drv led_drv(
.in_clk(clk), 
.in_rst(rst),
.in_mem(mem_out), 
.led_out(led_reg)
);



/*
Драйвер Клавиатуры.  
*/

key_drv key_drv(
.in_clk(clk),
.in_rst(rst),
.in_key_switch(key_switch),
.in_key_reset(key_rst),
.o_key_switch(key_push),
.o_key_reset(reset_push)
);

/*
Драйвер памяти.  
*/

mem memory(
.in_clk(clk),
.in_rst(rst),
.in_mem(mem_in),
.mem_wrt_en(mem_wrt_en),
.out_mem(mem_out),
.mem_wrt_rd(mem_wrt_rd)
);

/*
Драйвер передачи  
*/

uart_tx uarttx(
.i_clk(clk),
.i_start(uart_rx_en),
.i_data(mem_out),
.o_done(uart_tx_done),
.o_busy(uart_tx_bs),
.o_dout(uart_tx)
);

/*
Драйвер fsm
*/

fsm fsm(
.in_clk(clk),
.uart_push(uart_rx_rdy),                
.key_push(key_push),
.reset_push(reset_push),
.mem_wrt_rd(mem_wrt_rd),
.tx_done(uart_tx_done),
.mem(mem_out),
.i_uart_data(uart_rx_data),
.rx_busy(uart_rx_bs),
.mem_wrt_en(mem_wrt_en),
.rst_fsm(rst_fsm),
.rx_start(uart_rx_en),
.mem_out(mem_in)           
);

endmodule
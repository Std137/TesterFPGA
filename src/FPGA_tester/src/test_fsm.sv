module test_fsm();

/*
input in_clk,
input in_rst,
input uart_push,                //Флаг загрузки данных в уарт
input key_push,                 //Флаг нажата клавиша вкл/выкл
input reset_push,               //Флаг нажатой кнопки сброс
input mem_wrt_rd,               //Флаг окончания записи в память
input rx_done,                  //Флаг окончания передачи
input [5:0] mem,                //Состояние памяти
input key_data,                 //Состояние клавиатуры
input [7:0] i_uart_data,        //Данные из уарт
input rx_busy,                  //Флаг готовности передатчика
output mem_wrt_en,              //Флаг разрешения записи в память
output rx_start,                //флаг разрешенпия передачи
output [5:0] mem_out            //Данные для памяти
*/


logic in_clk = 0;
logic in_rst = 0;
logic uart_push = 0;
logic reset_push = 0;
logic [5:0] mem = 21;
logic [7:0] i_uart_data = 0;
logic key_data = 1;
logic mem_wrt_rd = 0;
logic rx_done = 0;
logic rx_busy = 1;
logic key_push = 0;

wire mem_wrt_en;
wire [5:0] mem_out;
wire rx_start;

fsm fsm(.*);

  always
    #1  in_clk = ~in_clk;

initial 
    begin
// Нажата вкл/выкл светодиод
    #4 key_push = 1;
    #4 key_push = 0;
    #1 mem_wrt_rd = 1;
    #4 mem_wrt_rd = 0;
    #1 rx_done = 1;
    #4 rx_done = 0;
// Получено считать данные
    #1 i_uart_data = 85;
    #1 uart_push = 1;
    #4 uart_push = 0;
    #1 rx_done = 1;
    #4 rx_done = 0;
// Получено записать данные
    #1 i_uart_data = 149;
    #1 uart_push = 1;
    #4 uart_push = 0;
    #1 mem_wrt_rd = 1;
    #4 mem_wrt_rd = 0;
    #1 rx_done = 1;
    #4 rx_done = 0;
    #20 $finish;
    end

 initial begin
    $dumpfile("qqq.vcd");
    $dumpvars(0,test_fsm);
 end

endmodule

                          
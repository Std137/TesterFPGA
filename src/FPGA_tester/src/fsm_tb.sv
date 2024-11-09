`include "fsm1_pkg_b.sv"
import fsm1_pkg::*;

module fsm_tb();
logic in_clk = 0;                // Системный тактовый сигнал
logic in_rst = 1;                // Сброс (активный низкий)
logic in_push_sw = 0;            // Нажата кнопка switch
logic in_push_rst = 0;           // Нажата кнопка reset
logic in_mem_w_rd = 0;           // Флаг, запись в память окончена
logic in_utx_s_rd = 0;           // Флаг, uart_tx отправка данных окончена
logic in_utx_s_bs = 1;           // Флаг, uart_tx занят
logic [5:0] in_mem = 6'b110101;  // Шина данных чтения памяти
logic [7:0] in_urx = '0;         // Шина данных чтения uart_rx
wire [5:0] out_mem;              // Шина данных записи в память
wire out_mem_w_en;               // Флаг, запись в память разрешена
wire out_utx_s_en;               // Флаг, отправка данных разрешена
wire out_rst;                    // Флаг, произвести сброс


fsm fsm(.*);

  always
    #1  in_clk = ~in_clk;

  initial begin
    #3 in_rst = 0;
    #4 in_rst = 1;
    #4 in_urx = 8'b01110101;
    #4 in_utx_s_bs = 0;
    #4 in_utx_s_rd = 1;
       in_utx_s_bs = 1;
       in_urx = '0;
    #4 in_utx_s_rd = 0;
    #4 in_push_sw=1;
    #4 in_mem_w_rd=1;
    #4 in_push_sw=0;
       in_mem_w_rd=1;
    #10 $finish;
  end

  initial begin
    $dumpfile("fsm_tb.vcd");
    $dumpvars();
  end

endmodule
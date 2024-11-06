module fsm(
input in_clk,
input in_rst,
input uart_push,                //Флаг загрузки данных в уарт
input key_push,                 //Флаг нажата клавиша вкл/выкл
input reset_push,               //Флаг нажатой кнопки сброс
input mem_wrt_rd,               //Флаг окончания записи в память
input tx_done,                  //Флаг окончания передачи
input [5:0] mem,                //Состояние памяти
input [7:0] i_uart_data,        //Данные из уарт
input tx_busy,                  //Флаг готовности передатчика
output mem_wrt_en,              //Флаг разрешения записи в память
output rst_fsm,                 //Флаг сброса по линии ФСМ
output tx_start,                //флаг разрешенпия передачи
output [5:0] mem_out            //Данные для памяти
);


localparam	STATE_WAIT          = 2'b00,
 			STATE_WRITE			= 2'b01,
            STATE_SEND          = 2'b10;

logic out_start_send = 0;
logic wrt_en_mem = 0;
logic fsm_reset = 0;
logic [5:0] fsm_mem = 0;
logic [2:0] currentState, nextState;

wire  [1:0] uart_comand;

assign mem_out = fsm_mem;
assign rx_start = out_start_send;           
assign mem_wrt_en = wrt_en_mem;
assign uart_comand = i_uart_data[7:6];
assign rst_fsm = fsm_reset;


always @(posedge in_clk) 
    begin
        currentState = nextState;
        case(currentState)
                default: 
                    begin
                        wrt_en_mem <= 0;
                        out_start_send <= 0;
                        fsm_reset <= 0;
                        nextState = STATE_WAIT;
                    end
                STATE_WAIT:
                    begin
                        wrt_en_mem <= 0;
                        out_start_send <= 0;
                        if (key_push)                               //Нажата кнопка вкл/выкл
                            begin
                                fsm_mem <= {~mem[5],mem[4:0]};
                                nextState = STATE_WRITE;
                            end
                        if (uart_push)                              //Получена данные уарт
                            begin 
                                if (uart_comand == 2'b01)           //Получена команда уарт отправить данные
                                    begin
                                        nextState = STATE_SEND;
                                    end
                                if (uart_comand == 2)               //Получена команда уарт сохранить данные
                                    begin
                                        fsm_mem <= {i_uart_data[5:0]};
                                        nextState = STATE_WRITE;
                                    end
                                if (uart_comand == 3)               //Получена команда уарт сброс            
                                    begin
                                        fsm_reset = 1;
                                        nextState = STATE_WAIT;
                                    end
                            end
                         if (reset_push)                            //Нажата кнопка сброс
                            begin
                                fsm_reset = 1;
                                nextState = STATE_WAIT;
                            end
                    end
                
                STATE_WRITE:
                    begin
                        wrt_en_mem <= 1;
                        if (mem_wrt_rd) nextState = STATE_SEND;
                    end

                STATE_SEND:
                    begin
                        wrt_en_mem <= 0;
                        if (!tx_busy) out_start_send <= 1;
                        if (tx_done) nextState = STATE_WAIT;
                    end
        endcase
    end

endmodule
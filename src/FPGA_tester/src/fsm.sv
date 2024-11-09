module fsm(
    input logic in_clk,                // Системный тактовый сигнал
    input logic in_rst,              	// Сброс (активный низкий)
    input logic in_push_sw,            // Нажата кнопка switch
    input logic in_push_rst,           // Нажата кнопка reset
	 input logic in_mem_w_rd,				// Флаг, запись в память окончена
	 input logic in_utx_s_rd,				// Флаг, uart_tx отправка данных окончена
	 input logic in_utx_s_bs,				// Флаг, uart_tx занят
	 input logic [5:0] in_mem,				// Шина данных чтения памяти
	 input logic [7:0] in_urx,				// Шина данных чтения uart_rx
	 output wire [5:0] out_mem,			// Шина данных записи в память
	 output logic out_mem_w_en,			// Флаг, запись в память разрешена
	 output logic out_utx_s_en,			// Флаг, отправка данных разрешена
	 output logic out_rst					// Флаг, произвести сброс
);

typedef enum logic [2:0]
    { 
        STATE_IDLE  	 = 3'b000,
        STATE_WRITE_C = 3'b001,
		  STATE_WRITE_S =	3'b010,
        STATE_RESET 	 = 3'b011,
		  STATE_WAIT 	 = 3'b100,
		  STATE_SEND  	 = 3'b101,
		  XXX 			 = 'x
	 } state_e;

state_e current_state, next_state;

logic in_cmd_setup, in_cmd_reset, in_cmd_send, in_key_tr, in_rx_tr; 	

assign in_cmd_setup = (in_urx[7:6] == 2'b10)?'1:'0; // Получена команда записать значения
assign in_cmd_reset = (in_urx[7:6] == 2'b11)?'1:'0; // Получена команда сброса
assign in_cmd_send  = (in_urx[7:6] == 2'b01)?'1:'0; // Получена команда отправить состояние
assign out_mem = (in_key_tr)?{~in_mem[5],in_mem[4:0]}:(in_rx_tr)?in_urx[5:0]:in_mem[5:0];

    always_ff @(posedge in_clk, negedge in_rst) begin
        if (!in_rst)
            current_state <= STATE_IDLE;
        else 
            current_state <= next_state; 
    end
	 
	 always_comb begin
		  next_state = XXX;
        case (current_state)
				STATE_IDLE: 	if  		(in_push_sw) 	next_state = STATE_WRITE_S;
									else if 	(in_cmd_send) 	next_state = STATE_SEND;
									else if 	(in_cmd_setup) next_state = STATE_WRITE_C;
									else if 	(in_cmd_reset) next_state = STATE_RESET;
									else if 	(in_push_rst)	next_state = STATE_RESET;
									else 							next_state = STATE_IDLE;
				
            STATE_WRITE_C: if 		(in_mem_w_rd)	next_state = STATE_WAIT;
									else							next_state = STATE_WRITE_C;
				STATE_WRITE_S: if 		(in_mem_w_rd) 	next_state = STATE_WAIT;
									else 			 				next_state = STATE_WRITE_S;
            STATE_RESET:  									next_state = STATE_IDLE;
				STATE_WAIT: 	if 		(!in_utx_s_bs)	next_state = STATE_SEND;
									else							next_state = STATE_WAIT;
				STATE_SEND: 	if 		(in_utx_s_rd)	next_state = STATE_IDLE;
									else							next_state = STATE_SEND;
				default:											next_state = XXX;
			endcase
		end
	
	 always_comb begin
			case(current_state)
					STATE_IDLE: 	begin	
											out_mem_w_en = 0;
											out_utx_s_en = 0;
											out_rst 		 = 0;
											in_key_tr = 0;
											in_rx_tr = 0;
										end
					STATE_WRITE_C: begin
											out_utx_s_en = 0;
											out_rst 		 = 0;
											out_mem_w_en = 1;
											in_key_tr = 0;
											in_rx_tr = 1;
										end
					STATE_WRITE_S: begin
											out_utx_s_en = 0;
											out_rst 		 = 0;
											out_mem_w_en = 1;
											in_key_tr = 1;
											in_rx_tr = 0;
										end
					STATE_RESET: 	begin
											out_mem_w_en = 0;
											out_utx_s_en = 0;
											out_rst 		 = 1;
											in_key_tr = 0;
											in_rx_tr = 0;
										end
					STATE_WAIT: 	begin
											out_mem_w_en = 0;
											out_rst 		 = 0;
											out_utx_s_en = 1;
											in_key_tr = 0;
											in_rx_tr = 0;
										end
					STATE_SEND: 	begin
											out_mem_w_en = 0;
											out_rst 		 = 0;
											out_utx_s_en = 1;
											in_key_tr = 0;
											in_rx_tr = 0;
										end
					default: 		  {in_rx_tr, in_key_tr, out_mem_w_en, out_utx_s_en, out_rst} = 'x;
			endcase
		end
endmodule
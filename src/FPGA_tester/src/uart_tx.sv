module uart_tx
#(
  parameter TICKS_PER_BIT = 243,
  parameter TICKS_PER_BIT_SIZE = 8
)
(
  input i_clk,
  input i_start,
  input [7:0] i_data,
  output wire o_done,
  output wire o_busy,
  output wire o_dout
);

typedef enum logic [1:0]
    { 
        STATE_IDLE       = 2'b00,
        STATE_SEND_BITS  = 2'b01,
        STATE_SEND_WAIT  = 2'b10,
        STATE_DONE       = 2'b11,
        XXX              = 'x
  } state_e;

state_e currentState, nextState;

logic done_flag;
logic busy_flag;
logic tx_output;
 
assign o_dout = tx_output;
assign o_done = done_flag;
assign o_busy = busy_flag;

logic [7:0] tx_reg;
logic [3:0] tx_bit_counter;
logic [TICKS_PER_BIT_SIZE-1:0] ticks_counter;

wire ticks_counter_ovf   = (ticks_counter == TICKS_PER_BIT-1);
wire tx_bit_counter_ovf  = (tx_bit_counter == 4'b1010);

always_ff @(posedge in_clk, negedge in_rst) begin
    if (!in_rst)
      current_state <= STATE_IDLE;
    else 
      current_state <= next_state; 
  end

always_comb begin
  next_State = XXX;
  case(currentState)
    STATE_IDLE:       if    (i_start)            nextState = STATE_SEND_START;
                      else                       nextState = STATE_IDLE;
    STATE_SEND_BITS:  if    (tx_bit_counter_ovf) nextState = STATE_SEND_DONE;
                      else                       nextState = STATE_SEND_WAIT;
    STATE_SEND_WAIT:  if    (ticks_counter_ovf)  nextState = STATE_SEND_BITS;
                      else                       nextState = STATE_SEND_WAIT;
    STATE_DONE:                                  nextState = STATE_IDLE;
    default:                                     nextState = XXX;
 endcase
end


always_ff @(posedge in_clk) begin
  if (currentState == STATE_SEND_WAIT)
    if (ticks_counter_ovf) ticks_counter <= 0;
    else ticks_counter <= ticks_counter + 1;
  end

always_ff @(posedge in_clk) begin
  if (currentState == STATE_SEND_BITS)
    if (tx_bit_counter_ovf) tx_bit_counter <= 0;
    else tx_bit_counter <= tx_bit_counter + 1;
  end

always_comb begin
    if (!in_rst) begin 
          done_flag = '0;
          busy_flag = '0;
          tx_output = '0;
          tx_reg    = '0;
    end
    else begin
    case(current_state)
        STATE_IDLE:  begin 
          done_flag = '0;
          busy_flag = '0;
          tx_output = '0;
          tx_reg    = {0,i_data,1};
        end
        STATE_SEND_BITS: begin
          done_flag = '0;
          busy_flag = '0;
          tx_output = tx_reg[0];
          tx_reg    = tx_reg;
        end
        STATE_SEND_WAIT: begin
          done_flag = '0;
          busy_flag = '0;
          tx_output = tx_reg[0];;
          tx_reg    = tx_reg;
        end
        STATE_RESET:  begin
          done_flag = '0;
          busy_flag = '0;
          tx_output = '0;
          tx_reg    = i_data;
        end
        STATE_WAIT:  begin
          done_flag = '0;
          busy_flag = '0;
          tx_output = '0;
          tx_reg    = i_data;
        end
        STATE_DONE:  begin
          done_flag = '1;
          busy_flag = '0;
          tx_output = '1;
          tx_reg    = '0;
        end
        default:{in_rx_tr, in_key_tr, out_mem_w_en, out_utx_s_en, out_rst} = 'x;
      endcase
    end

endmodule 
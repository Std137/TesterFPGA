module uart_tx
#(
  parameter TICKS_PER_BIT = 243,
  parameter TICKS_PER_BIT_SIZE = 8
)
(
  input in_clk,
  input in_rst,
  input in_start,
  input [5:0] in_data,
  output wire out_done,
  output wire out_busy,
  output wire out_tx
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
 
assign out_tx = tx_output;
assign out_done = done_flag;
assign out_busy = busy_flag;

logic [10:0] tx_reg;
logic [3:0] tx_bit_counter;
logic [TICKS_PER_BIT_SIZE-1:0] ticks_counter;

wire ticks_counter_ovf   = (ticks_counter == TICKS_PER_BIT-1);
wire tx_bit_counter_ovf  = (!tx_bit_counter);

always_ff @(posedge in_clk) begin
    if (!in_rst)
      currentState <= STATE_IDLE;
    else 
      currentState <= nextState; 
  end

always_comb begin
  nextState = XXX;
  case(currentState)
    STATE_IDLE:       if    (in_start)           nextState = STATE_SEND_BITS;
                      else                       nextState = STATE_IDLE;
    STATE_SEND_BITS:  if    (tx_bit_counter_ovf) nextState = STATE_DONE;
                      else                       nextState = STATE_SEND_WAIT;
    STATE_SEND_WAIT:  if    (ticks_counter_ovf)  nextState = STATE_SEND_BITS;
                      else                       nextState = STATE_SEND_WAIT;
    STATE_DONE:                                  nextState = STATE_IDLE;
    default:                                     nextState = XXX;
 endcase
end


always_ff @(posedge in_clk) begin
   if (!in_rst) ticks_counter <= '0;
	else 
     if (currentState == STATE_SEND_WAIT)
       if (ticks_counter_ovf) ticks_counter <= 0;
       else ticks_counter <= ticks_counter + 1;
  end

always_ff @(posedge in_clk) begin
   if (!in_rst) tx_bit_counter <= 4'b1010;
   else 
    if (currentState == STATE_SEND_BITS)
      if (tx_bit_counter_ovf) tx_bit_counter <= 4'b1010;
      else tx_bit_counter <= tx_bit_counter - 1'b1;
  end

always_ff @(posedge in_clk) begin
  if (currentState == STATE_IDLE)
    tx_reg <= {4'b1000,in_data,1'b1};
  else tx_reg <= tx_reg;
  end

always_comb begin
    if (!in_rst) begin 
          done_flag = '0;
          busy_flag = '0;
          tx_output = '1;
    end
    else begin
    case(currentState)
        STATE_IDLE:  begin 
          done_flag = '0;
          busy_flag = '0;
          tx_output = '1;
        end
        STATE_SEND_BITS: begin
          done_flag = '0;
          busy_flag = '1;
          tx_output = tx_reg[tx_bit_counter];
        end
        STATE_SEND_WAIT: begin
          done_flag = '0;
          busy_flag = '1;
          tx_output = tx_reg[tx_bit_counter];
        end
        STATE_DONE:  begin
          done_flag = '1;
          busy_flag = '0;
          tx_output = '1;
        end
        default:{done_flag, busy_flag, tx_output} = 'x;
      endcase
    end
  end
endmodule 
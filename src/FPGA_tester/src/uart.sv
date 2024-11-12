module uart_rx
#(
    parameter DELAY_FRAMES = 234 // 27,000,000 (27Mhz) / 115200 Baud rate
)
(
    input in_clk,
    input in_rst,
    input in_rx,
    output out_rx_ready,
    output out_rx_data
);

localparam HALF_DELAY_WAIT = (DELAY_FRAMES / 2);

logic [3:0] rxState = 0;
logic [12:0] rxCounter = 0;
logic [7:0] dataIn = 0;
logic [2:0] rxBitNumber = 0;
logic byteReady = 0;

localparam RX_STATE_IDLE = 1'd0;
localparam RX_STATE_START_BIT = 1'd1;
localparam RX_STATE_READ_WAIT = 1'd2;
localparam RX_STATE_READ = 1'd3;
localparam RX_STATE_STOP_BIT = 1'd5;

always @(posedge in_clk) begin
    case (rxState)
        RX_STATE_IDLE: begin
                rxCounter <= 1;
                rxBitNumber <= 0;
                byteReady <= 0;
            if (in_rx == 0) rxState <= RX_STATE_START_BIT;
            else rxState <= RX_STATE_IDLE;
          end
        RX_STATE_START_BIT: begin
            if (rxCounter == HALF_DELAY_WAIT) begin
                rxState <= RX_STATE_READ_WAIT;
                rxCounter <= 1;
            end 
            else begin
                rxCounter <= rxCounter + 1;
                rxState <= RX_STATE_START_BIT;
            end
          end
        RX_STATE_READ_WAIT: begin
            rxCounter <= rxCounter + 1;
            if ((rxCounter + 1) == DELAY_FRAMES)
              rxState <= RX_STATE_READ;
            else 
              rxState <= RX_STATE_READ;
          end
        RX_STATE_READ: begin
            rxCounter <= 1;
            dataIn <= {in_rx, dataIn[7:1]};
            rxBitNumber <= rxBitNumber + 1;
            if (rxBitNumber == 3'b111)
                rxState <= RX_STATE_STOP_BIT;
            else
                rxState <= RX_STATE_READ_WAIT;
          end
        RX_STATE_STOP_BIT: begin
            rxCounter <= rxCounter + 1;
            if ((rxCounter + 1) == DELAY_FRAMES) begin
                rxState <= RX_STATE_IDLE;
                rxCounter <= 0;
                byteReady <= 1;
            end
            else
                rxState <= RX_STATE_IDLE;
        end
    endcase
end

always @(posedge in_clk) begin
    if (byteReady) begin
        out_rx_data <= ~dataIn;
        out_rx_ready <= '1;
    end
    else out_rx_ready <= '0;
end
endmodule
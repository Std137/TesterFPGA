module led_port(
input in_clk,
input in_rst,
input [5:0] in_mem,           //Регистр управления свтодиодами
output [5:0] led_out   //Физичесие выходы светодиодов
);

reg  [5:0] led_stat;

always @(posedge in_clk)
    begin
        if (in_rst) 
            begin
                led_stat <= 0;
            end
        else    
            begin
                led_stat <= in_mem;
            end
    end

assign led_out = led_stat;

endmodule
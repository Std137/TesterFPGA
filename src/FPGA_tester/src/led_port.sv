module led_drv(
input logic in_clk,
input logic in_rst,
input logic [5:0] in_mem,           //Регистр управления свтодиодами
output logic [5:0] led_out          //Физичесие выходы светодиодов
);

logic  [5:0] led_stat;

always_ff @(posedge in_clk)
    begin
        if (in_rst) 
            begin
                led_stat <= '0;
            end
        else    
            begin
                led_stat <= in_mem;
            end
    end

assign led_out = led_stat;

endmodule
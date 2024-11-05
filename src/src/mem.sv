module mem(
input in_clk,
input in_rst,
input [7:0] in_uart,
input in_uart_en,
input  in_key,
input in_key_en,
output [5:0] out_mem
);

logic [5:0] mem_stat;

always @(posedge in_clk)
    begin
        if(in_rst)
            begin
                mem_stat <= 0;
            end
        else
            begin
                if (in_key_en) mem_stat[5]<= in_key;
                if (in_uart_en) mem_stat <= in_uart[5:0];
            end
    end

assign out_mem = mem_stat;

endmodule
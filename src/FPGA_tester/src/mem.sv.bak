module mem(
input in_clk,
input in_rst,
input [5:0] in_mem,
input mem_wrt_en,
output [5:0] out_mem,
output mem_wrt_rd
);

logic [5:0] mem_reg;
logic wrt_ready;

always @(posedge in_clk)
    begin
        if(in_rst)
            begin
                wrt_ready <= 0;
                mem_reg <= 0;
            end
        else
            begin
                if (mem_wrt_en) 
                    begin
                        mem_reg <= in_mem;
                        wrt_ready <= 1;
                    end
                else wrt_ready <= 0;
            end
    end

assign out_mem = mem_reg;
assign mem_wrt_rd = wrt_ready;

endmodule
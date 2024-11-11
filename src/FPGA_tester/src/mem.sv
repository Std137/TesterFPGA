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

always_ff @(posedge in_clk)
  begin
    if(in_rst)
      begin
          mem_wrt_rd <= 0;
          out_mem <= 0;
      end
    else
      if (mem_wrt_en) 
        begin
          out_mem <= in_mem;
          mem_wrt_rd <= 1;
        end
      else 
          mem_wrt_rd <= 0;
  end

endmodule
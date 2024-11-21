module mem(
input logic in_clk,
input logic in_rst,
input logic [5:0] in_mem,
input logic mem_wrt_en,
output logic [5:0] out_mem,
output logic mem_wrt_rd
);

logic [5:0] mem_registr;
logic wrt_ready;

assign out_mem = mem_registr;

always_ff @(posedge in_clk)
  begin
    if(!in_rst)
      begin
          mem_wrt_rd <= '0;
          mem_registr <= '1;
      end
    else
      if (mem_wrt_en)
        begin
          mem_registr <= in_mem;
          mem_wrt_rd <= '1;
        end
      else mem_wrt_rd <= '0;
  end

endmodule
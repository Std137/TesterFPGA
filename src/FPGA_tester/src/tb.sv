module tb ();

logic [5:0] in_mem;
logic in_clk = '0;
logic in_rst;
logic in_utx_st;
logic out_rx;
logic out_utx_bs;
  
uart_tx uart_tx(.*);

always
        #1 in_clk = ~in_clk;

initial  begin
           in_rst = '0;
        #4 in_rst = '1;
           in_utx_st = '0;
        #4 in_mem = 6'b101010;
        #2 in_utx_st = '1;
        #1 in_utx_st = '0;
        #2500 $finish;
      end
      
initial begin
    $dumpfile("test.vcd");
    $dumpvars();
end

endmodule
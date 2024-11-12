module u_tx_tb();

logic in_clk = '0;
logic in_rst = 'x;
logic in_start = 'x;
logic [5:0] in_data = 'x;
logic out_done;
logic out_busy;
logic out_tx;


uart_tx u_tx(.*);

always
  #1  in_clk = ~in_clk;

initial 
    begin
    #8 in_rst = '0;
	 #8 in_rst = '1;
	 #10 in_data = 6'b101010;
		  in_start = '1;
    #2  in_start = '0;
	 #5000 in_data = 6'b010101;
		  in_start = '1;
    #5000 $finish;
    end

  initial begin
    $dumpfile("qqq.vcd");
    $dumpvars();
  end

endmodule
module test_rst();

logic in_clk = 0;
logic in_key_rst = 0;
logic in_fsm_rst = 0;

wire rst;

reset reset(.*);

  always
    #1  in_clk = ~in_clk;

initial 
    begin
    $display("Starting RST");
    $monitor("RST", rst);
    #10 in_key_rst = 1;
    #10 in_key_rst = 0;
    #10 in_fsm_rst = 1;
    #10 in_fsm_rst = 0;
    #20 $finish;
    end

  initial begin
    $dumpfile("qqq.vcd");
    $dumpvars(0,test_rst);
  end

endmodule
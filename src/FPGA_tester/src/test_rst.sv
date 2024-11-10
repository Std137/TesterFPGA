module test_rst();

logic in_clk = 0;
logic in_fsm_rst = 0;
logic rst;

reset reset(.*);

  always
    #1  in_clk = ~in_clk;

initial 
    begin
    #10 in_fsm_rst = 0;
    #2 in_fsm_rst = 1;
    #11 in_fsm_rst = 0;
    #2 in_fsm_rst = 1;
    #20 $finish;
    end

  initial begin
    $dumpfile("qqq.vcd");
    $dumpvars(0,test_rst);
  end

endmodule
module test_rst();

logic in_clk = '0;
logic in_fsm_rst = 1'bx;
logic out_rst;

reset reset(.*);

  always
    #1  in_clk = ~in_clk;

initial 
    begin
    #12 in_fsm_rst = 1;
    #6 in_fsm_rst = 0;
    #11 in_fsm_rst = 1;
    #6 in_fsm_rst = 0;
    #11 in_fsm_rst = 1;
    #20 $finish;
    end

  initial begin
    $dumpfile("qqq.vcd");
    $dumpvars(0,test_rst);
  end

endmodule
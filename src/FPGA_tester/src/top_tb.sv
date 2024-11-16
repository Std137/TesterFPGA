module tester_tb();

logic clk = 1;
logic uart_rx;
logic key_rst;
logic key_switch;
logic uart_tx;
logic [5:0] led;

tester_top top(.*);

always
        #1 clk = ~clk;

initial  begin
        #20 key_switch = 1;
        #20 key_switch = 0;
        #4900  $finish;
      end
      
initial begin
    $dumpfile("top.vcd");
    $dumpvars();
end
endmodule
module tester_tb();

logic clk = 1;
logic uart_rx;
logic key_rst = 1;
logic key_switch;
logic uart_tx;
logic [5:0] led;

tester_top top(.*);

always
        #1 clk <= ~clk;

initial  begin

        #1  key_switch <= 1;
        #20 @(posedge clk);
            key_switch <= 0;
        #5 @(posedge clk);
            key_switch <= 1;
        #5000 @(posedge clk);
            key_switch <= 0;
        #5 @(posedge clk);
            key_switch <= 1;
        #5000  $finish;
      end
      
initial begin
    $dumpfile("top.vcd");
    $dumpvars();
end
endmodule
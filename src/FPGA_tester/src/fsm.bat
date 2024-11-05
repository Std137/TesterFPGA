iverilog -o qqq fsm.sv test_fsm.sv
vvp qqq
gtkwave qqq.vcd
pause
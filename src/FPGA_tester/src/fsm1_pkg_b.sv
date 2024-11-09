`ifndef fsm1_pkg_quard
package fsm1_pkg;
typedef enum logic [2:0]
    { 
        STATE_IDLE  	 = 3'b000,
        STATE_WRITE_C = 3'b001,
		  STATE_WRITE_S =	3'b010,
        STATE_RESET 	 = 3'b011,
		  STATE_WAIT 	 = 3'b100,
		  STATE_SEND  	 = 3'b101,
		  XXX 			 = 'x
	 } state_e;
endpackage
`define fsm1_pkg_quard
`endif
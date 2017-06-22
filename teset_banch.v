include "defines.v";
module test_banch();
	reg CLOCK_50;
	reg reset;
	initial begin
		CLOCK_50 = 1'b0;
		forever #10 CLOCK_50 = ~CLOCK_50;
	end
	
	initial begin
		reset = `RESET_ENABLE;
		#195 reset = `RESET_DISABLE;
		#1000 $stop;
	end
	
	sopc sopc(
		.clock(CLOCK_50),
 		.reset(reset)
	);
endmodule
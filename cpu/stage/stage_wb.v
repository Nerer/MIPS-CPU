include "defines.v";
module stage_wb(
	input wire clock,
	input wire reset,
	
	input wire reg_hi_write_enable,
	input wire[31:0] reg_hi_write_data,
	output reg[31:0] reg_hi_read_data,
	
	input wire reg_lo_write_enable,
	input wire[31:0] reg_lo_write_data,
	output reg[31:0] reg_lo_read_data
);

	always @(posedge clock) begin
		if (reset == `RESET_ENABLE) begin
			reg_hi_read_data = 32'b0;
		end
		else if (reg_hi_write_enable == `WRITE_ENABLE) begin
			reg_hi_read_data = reg_hi_write_data;
		end
	end
	
	always @(posedge clock) begin
		if (reset == `RESET_ENABLE) begin
			reg_lo_read_data = 32'b0;
		end
		else if (reg_lo_write_enable == `WRITE_ENABLE) begin
			reg_lo_read_data = reg_lo_write_data;
		end
	end

endmodule
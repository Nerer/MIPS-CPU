module stage_if(
	input wire clock,
	input wire reset,
	input wire[5:0] stall,
	output reg[31:0] pc_read_data，
	input wire[31:0] pc_write_data,
	input wire pc_write_enable
);

	always @ (posedge clock) begin
		if (reset == `RESET_ENABLE) begin
			pc_read_data <= 32'b0;
		end
		else if (stall[0] == `STALL_DISABLE) begin
			if (pc_write_enable == `WRITE_ENABLE) begin
				pc_read_data = pc_write_data;
			end
			else begin
				pc_read_data = pc_read_data + 32'd4;
			end
		end
	end

endmodule
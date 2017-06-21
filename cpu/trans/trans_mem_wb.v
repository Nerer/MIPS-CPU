module trans_mem_wb(
	input wire clock,
	input wire reset,
	input wire[5: 0] stall,
	input wire mem_reg_write_enable,
	output reg wb_reg_write_enable,
	input wire[4: 0] mem_reg_write_address,
	output reg[4: 0] wb_reg_write_address,
	input wire[31:0] mem_reg_write_data,
	output reg[31:0] wb_reg_write_data,
);

	always @(posedge clock) begin
		if (reset == `RESET_ENABLE || (stall[4] == `STALL_ENABLE && stall[5] == `STALL_DISABLE)) begin
			wb_reg_write_enable <= `WRITE_DISABLE;
			wb_reg_write_address <= 5'b0;
			wb_reg_write_data <= 32'b0;
		end
		else if (stall[4] == `STALL_DISABLE) begin
			wb_reg_write_enable <= mem_reg_write_enable;
			wb_reg_write_address <= mem_reg_write_address;
			wb_reg_write_data <= mem_reg_write_data;
		end
	end

endmodule
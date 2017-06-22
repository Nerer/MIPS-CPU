include "defines.v";
module trans_id_ex(
	input wire clock,
	input wire reset,
	input wire[5: 0] stall,
	input wire[31:0] id_instruction,
	output reg[31:0] ex_instruction,
	input wire[7: 0] id_operator,
	output reg[7: 0] ex_operator,
	input wire[2: 0] id_category,
	output reg[2: 0] ex_category,
	input wire[31:0] id_operand_a,
	output reg[31:0] ex_operand_a,
	input wire[31:0] id_operand_b,
	output reg[31:0] ex_operand_b,
	input wire id_reg_write_enable,
	output reg ex_reg_write_enable,
	input wire[4: 0] id_reg_write_address,
	output reg[4: 0] ex_reg_write_address, 
	input wire[31:0] id_reg_write_data,
	output reg[31:0] ex_reg_write_data
);

	always @(posedge clock) begin
		if (reset == `RESET_ENABLE || (stall[2] == `STALL_DISABLE && stall[3] == `STALL_DISABLE)) begin
			ex_instruction <= 32'b0;
			ex_operator <= `OP_NOP;
			ex_category <= `CATEGORY_NONE;
			ex_operand_a <= 32'b0;
			ex_operand_b <= 32'b0;
			ex_reg_write_enable <= `WRITE_DISABLE;
			ex_reg_write_address <= 32'b0;
			ex_reg_write_data <= 32'b0;
		end
		else if (stall[2] == `STALL_DISABLE) begin
			ex_instruction <= id_instruction;
			ex_operator <= id_operator;
			ex_category <= id_category;
			ex_operand_a <= id_operand_a;
			ex_operand_b <= id_operand_b;
			ex_reg_write_address <= id_reg_write_address;
			ex_reg_write_data <= id_reg_write_data;
			ex_reg_write_enable <= id_reg_write_enable;
		end
	end

endmodule 
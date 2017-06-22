include "defines.v";
module trans_ex_mem(
	input wire clock, //from cpu
	input wire reset, //from cpu
	input wire[5: 0] stall, //from control
	input wire[31:0] ex_instruction, //from ex
	output reg[31:0] mem_instruction, //to mem
	input wire[7: 0] ex_operator, //from ex
	output reg[7: 0] mem_operator, //to mem
	input wire[31:0] ex_operand_a, //from ex
	output reg[31:0] mem_operand_a, //to mem
	input wire[31:0] ex_operand_b, //from ex 
	output reg[31:0] mem_operand_b, //to mem
	input wire ex_reg_write_enable, //from ex
	output reg mem_reg_write_enable, //to mem
	input wire[4: 0] ex_reg_write_address, //from ex
	output reg[4: 0] mem_reg_write_address, //to mem
	input wire[31:0] ex_reg_write_data, //from ex
	output reg[31:0] mem_reg_write_data //to mem
);

//stall
	always @(posedge clock) begin
		if (reset == `RESET_ENABLE || (stall[2] == `STALL_DISABLE && stall[3] == `STALL_DISABLE)) begin
			mem_instruction <= 32'b0;
			mem_operator <= `OP_NOP;
			mem_operand_a <= 32'b0;
			mem_operand_b <= 32'b0;
			mem_reg_write_enable <= `WRITE_DISABLE;
			mem_reg_write_address <= 5'b0;
			mem_reg_write_data <= 32'b0;
		end
		else if (stall[2] == `STALL_DISABLE) begin
			mem_instruction <= ex_instruction;
			mem_operator <= ex_operator;
			mem_operand_a <= ex_operand_a;
			mem_operand_b <= ex_operand_b;
			mem_reg_write_enable <= ex_reg_write_enable;
			mem_reg_write_address <= ex_reg_write_address;
			mem_reg_write_data <= ex_reg_write_data;
		end
	end

endmodule
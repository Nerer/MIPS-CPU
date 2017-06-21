module trans_ex_mem(
	input wire clock,
	input wire reset,
	input wire[5: 0] stall,
	input wire[31:0] ex_instruction,
	output reg[31:0] mem_instruction,
	input wire[7: 0] ex_operator,
	output reg[7: 0] mem_operator,
	input wire[31:0] ex_operand_a,
	output reg[31:0]
);

endmodule
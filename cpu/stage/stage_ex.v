module stage_ex(
	input wire reset, //from cpu
	
	input wire [31:0] instruction_i, //from id
	output reg [31:0] instruction_o, //to mem

	input wire [7: 0] operator_i, //from id
	output reg [7: 0] operator_o, //to mem
	input wire [2: 0] category, //from id
	
	input wire [31:0] operand_a_i, //from id
	output reg [31:0] operand_a_o, //to mem
	input wire [31:0] operand_b_i, //from id
	output reg [31:0] operand_b_o, //to mem
	
	input wire reg_write_enable_i, //from id
	output reg reg_write_enable_o, //to mem
	input wire [4: 0] reg_write_address_i, //from id
	output reg [4: 0] reg_write_address_o, //to mem
	input wire [31:0] reg_write_data_i, //from id
	output reg [31:0] reg_write_data_o, //to mem
	
	output reg reg_hi_write_enable, //to mem
	output reg [31:0] reg_hi_write_data, //to mem
	output reg reg_lo_write_enable, //to mem
	output reg [31:0] reg_lo_write_data, //to mem
	
	input wire mem_reg_hi_write_enable, //from mem
	input wire [31:0] mem_reg_hi_write_data, //from mem
	input wire mem_reg_lo_write_enable, //from mem
	input wire [31:0] mem_reg_lo_write_data, //from mem
	
	input wire [31:0] wb_reg_hi_read_data, //from wb
	input wire wb_reg_hi_write_enable, //from wb
	input wire [31:0] wb_reg_hi_write_data, //from wb
	input wire [31:0] wb_reg_lo_read_data, //from wb
	input wire wb_reg_lo_write_enable, //from wb
	input wire [31:0] wb_reg_lo_write_data, //from wb
	
	output reg stall_request
);

    wire [31:0] operand_a_c = ~operand_a_i + 1;
    wire [31:0] operand_b_c = ~operand_b_i + 1;
	wire [31:0] operand_sum = operand_a_i + (operator_i == `OP_SLT  || operator_i == `OP_SUB  || operator_i == `OP_SUBU ? operand_b_c : operand_b_i);

    assign instruction_o = instruction_i;
    assign operator_o = operator_i;
    assign operand_a_o = operand_a_i;
    assign operand_b_o = operand_b_i;
	
	reg [31:0] reg_hi;
	always @(*) begin
	end
	reg [31:0] reg_lo;
	always @(*) begin
	end
	reg [31:0] result_logic;
	always @(*) begin
		if (reset == `RESET_ENABLE) begin
			result_logic <= 32'b0;
		end
		else begin
			case (operator_i)
				`OP_AND : begin
					result_logic <= operand_a_i & operand_b_i;
				end
				`OP_OR : begin
					result_logic <= operand_a_i | operand_b_i;
				end
				`OP_XOR : begin
					result_logic <= operand_a_i ^ operand_b_i;
				end
				`OP_NOR : begin
					result_logic <= ~(operand_a_i | operand_b_i);
				end
				default : begin
					result_logic <= 32'b0;
				end
			endcase
		end
	end
	
	reg [31:0] result_shift;
	always @(*) begin
		if (reset == `RESET_ENABLE) begin
			result_shift <= 32'b0;
		end
		else begin
			case (operator_i)
				`OP_SLL: begin
				end
				`OP_SRL: begin
				end
				`OP_SRA: begin
				end
				default: begin
				end
			endcase
		end
	end
	reg [31:0] result_move;
	always @(*) begin
		if (reset == `RESET_ENABLE) begin
			result_move <= 32'b0;
		end
		else begin
			case (operator_i)
				`OP_MFHI : begin
				end
				`OP_MFLO : begin
				end
				`OP_MOVN : begin
				end
				`OP_MOVZ : begin
				end
				default : begin
				end
			endcase 
		end
	end
	reg [63:0] result_arithmetic;
	always @(*) begin
		if (reset == `RESET_ENABLE) begin
			result_arithmetic <= 32'b0;
		end
		else begin
			case (operator_i)
				`OP_SLT : begin
				end
				`OP_SLTU : begin
				end
				`OP_ADD, `OP_ADDU, `OP_SUB, `OP_SUBU : begin
				end
				`OP_CLZ : begin
				end
				`OP_CLO : begin
				end
				`OP_MULT, `OP_MUL : begin
				end
				`OP_MULTU : begin
				end
				default : begin
				end
			endcase
		end
	end
	
	reg [31:0] result_jump;
	always @(*) begin
		if (reset == `RESET_ENABLE) begin
			result_jump <= 32'b0;
		end
		else begin
			result_jump <= reg_write_data_i;
		end
	end
	
	always @(*) begin
		case (operator_i) 
			`OP_ADD : begin
			end
			`OP_SUB : begin
			end
			default : begin
			end
		endcase
		
		reg_write_address_o <= reg_write_address_i;
		
		case (category) 
			`CATEGORY_LOGIC : begin
			end
			`CATEGORY_SHIFT : begin
			end
			`CATEGORY_MOVE : begin
			end
			`CATEGORY_ARITHMETIC : begin
			end
			`CATEGORY_JUMP : begin
			end
			default : begin
			end
		endcase
	end
	
	always @(*) begin
		if (reset == `RESET_ENABLE) begin
			reg_hi_write_enable <= `WRITE_DISABLE;
			reg_hi_write_data <= 32'b0;
			reg_lo_write_enable <= `WRITE_DISABLE;
			reg_lo_write_datga <= 32'b0;
		end
		case (operator_i)
			`OP_MTHI : begin
			end
			`OP_MTLO : begin
			end
			`OP_MULT, `OP_MULTU : begin
			end
			default : begin
			end
		endcase
	end
	
	
endmodule
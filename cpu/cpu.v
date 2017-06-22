include "defines.v";
module cpu(
	input wire clock,
	input wire reset,
	output wire[31:0] rom_read_address,
	input wire[31:0] rom_read_data,
	output wire ram_read_enable,
	output wire[31:0] ram_read_address,
	input wire[31:0] ram_read_data,
	output wire ram_write_enable,
	output wire[31:0] ram_write_address,
	output wire[3: 0] ram_write_select,
	output wire[31:0] ram_write_data
);

	wire [5: 0] stall;
//register	
	wire reg_read_enable_a;
	wire [4: 0] reg_read_address_a;
	wire [31:0] reg_read_data_a;
	wire reg_read_enable_b;
	wire [4: 0] reg_read_address_b;
	wire [31:0] reg_read_data_b;
	wire reg_write_enable;
	wire [4:0] reg_write_address;
	wire [31:0] reg_write_data;
//if stage	
	wire [31:0] if_pc_read_data;
	wire [31:0] if_instruction;
//id stage
	wire [31:0] id_instruction_i;
	wire [31:0] id_instruction_o;
	wire id_pc_write_enable;
	wire [31:0] id_pc_write_data;
	wire [31:0] id_pc_read_data;
	wire id_reg_read_enable_a;
	wire [4: 0] id_reg_read_address_a;
	wire [31:0] id_reg_read_data_a;
	wire id_reg_read_enable_b;
	wire [4: 0] id_reg_read_address_b;
	wire [31:0] id_reg_read_data_b;
	wire [7: 0] id_operator;
	wire [2: 0] id_category;
	wire [31:0] id_operand_a;
	wire [31:0] id_operand_b;
	wire id_reg_write_enable;
	wire [4: 0] id_reg_write_address;
	wire [31:0] id_reg_write_data;
	wire id_stall_request;
//ex state
	wire [31:0] ex_instruction_i;
	wire [31:0] ex_instruction_o;
	wire [7: 0] ex_operator_i;
	wire [7: 0] ex_operator_o;
	wire [2: 0] ex_category;
	wire [31:0] ex_operand_a_i;
	wire [31:0] ex_operand_a_o;
	wire [31:0] ex_operand_b_i;
	wire [31:0] ex_operand_b_o;
	wire ex_reg_write_enable_i;
	wire ex_reg_write_enable_o;
	wire [4: 0] ex_reg_write_address_i;
	wire [4: 0] ex_reg_write_address_o;
	wire [31:0] ex_reg_write_data_i;
	wire [31:0] ex_reg_write_data_o;
	wire ex_stall_request;
//mem stage
	wire [31:0] mem_instruction;
	wire [7: 0] mem_operator;
	wire [31:0] mem_operand_a;
	wire [31:0] mem_operand_b;
	wire mem_reg_write_enable_i;
	wire mem_reg_write_enable_o;
	wire [4: 0] mem_reg_write_address_i;
	wire [4: 0] mem_reg_write_address_o;
	wire [31:0] mem_reg_write_data_i;
	wire [31:0] mem_reg_write_data_o;
//wb stage 
	wire wb_reg_write_enable;
	wire [4: 0] wb_reg_write_address;
	wire [31:0] wb_reg_write_data;
	

	
	control control(
		.reset(reset),
		.id_stall_request(id_stall_request),
		.ex_stall_request(ex_stall_request),
		.stall(stall)
	);
	
	register register(
		.clock(clock),
		.reset(reset),
		.read_enable_a(reg_read_enable_a),
		.read_enable_b(reg_read_enable_b),
		.read_address_a(reg_read_address_a),
		.read_address_b(reg_read_address_b),
		.read_data_a(reg_read_data_a),
		.read_data_b(reg_read_data_b),
		.write_enable(reg_write_enable),
		.write_address(reg_write_address),
		.write_data(reg_write_data)
	);
	
	stage_if stage_if(
		.clock(clock),
		.reset(reset),
		.stall(stall),
		.pc_write_enable(id_pc_write_enable),
		.pc_write_data(id_pc_write_data),
		.pc_read_data(if_pc_read_data)
	);

	assign rom_read_address = if_pc_read_data;
	assign if_instruction = rom_read_data;
	
	trans_if_id trans_if_id(
		.clock(clock),
		.reset(reset),
		.stall(stall),
		.if_pc_read_data(if_pc_read_data),
		.if_instruction(if_instruction),
		.id_pc_read_data(id_pc_read_data),
		.id_instruction(id_instruction_i)
	);
	
	stage_id stage_id(
		.reset(reset),
		.instruction_i(id_instruction_i),
		.instruction_o(id_instruction_o),
		.pc_write_enable(id_pc_write_enable),
		.pc_write_data(id_pc_read_data),
		.pc_read_data(id_pc_read_data),
        .reg_read_enable_a(id_reg_read_enable_a),
        .reg_read_address_a(id_reg_read_address_a),
        .reg_read_data_a(id_reg_read_data_a),
        .reg_read_enable_b(id_reg_read_enable_b),
        .reg_read_address_b(id_reg_read_address_b),
        .reg_read_data_b(id_reg_read_data_b),
        .operator(id_operator),
        .category(id_category),
        .operand_a(id_operand_a),
        .operand_b(id_operand_b),
        .reg_write_enable(id_reg_write_enable),
        .reg_write_address(id_reg_write_address),
        .reg_write_data(id_reg_write_data),
        .ex_operator(ex_operator_o),
        .ex_reg_write_enable(ex_reg_write_enable_o),
        .ex_reg_write_address(ex_reg_write_address_o),
        .ex_reg_write_data(ex_reg_write_data_o),
        .mem_reg_write_enable(mem_reg_write_enable_o),
        .mem_reg_write_address(mem_reg_write_address_o),
        .mem_reg_write_data(mem_reg_write_data_o),
        .stall_request(id_stall_request)
	);
	
	assign reg_read_enable_a = id_reg_read_enable_a;
    assign reg_read_address_a = id_reg_read_address_a;
    assign id_reg_read_data_a = reg_read_data_a;
    assign reg_read_enable_b = id_reg_read_enable_b;
    assign reg_read_address_b = id_reg_read_address_b;
    assign id_reg_read_data_b = reg_read_data_b;
	
	trans_id_ex trans_id_ex(
		.clock(clock),
		.reset(reset),
		.stall(stall),
		.id_instruction(id_instruction_o),
		.id_operator(id_operator),
		.id_category(id_category),
		.id_operand_a(id_operand_a),
		.id_operand_b(id_operand_b),
		.id_reg_write_enable(id_reg_write_enable),
		.id_reg_write_address(id_reg_write_address),
		.id_reg_write_data(id_reg_write_data),
		.ex_instruction(ex_instruction_i),
		.ex_operator(ex_operator_i),
		.ex_category(ex_category),
		.ex_operand_a(ex_operand_a_i),
		.ex_operand_b(ex_operand_b_i),
		.ex_reg_write_enable(ex_reg_write_enable_i),
		.ex_reg_write_address(ex_reg_write_address_i),
		.ex_reg_write_data(ex_reg_write_data_i)
	);
	
	stage_ex stage_ex(
		.reset(reset),
		.instruction_i(ex_instruction_i),
		.instruction_o(ex_instruction_o),
		.operator_i(ex_operator_i),
		.operator_o(ex_operator_o),
		.category(ex_category),
		.operand_a_i(ex_operand_a_i),
		.operand_a_o(ex_operand_a_o),
		.operand_b_i(ex_operand_b_i),
		.operand_b_o(ex_operand_b_o),
		.reg_write_enable_i(ex_reg_write_enable_i),
		.reg_write_enable_o(ex_reg_write_enable_o),
		.reg_write_address_i(ex_reg_write_address_i),
		.reg_write_address_o(ex_reg_write_address_o),
		.reg_write_data_i(ex_reg_write_data_i),
		.reg_write_data_o(ex_reg_write_data_o),
		.stall_request(ex_stall_request)
	);

	trans_ex_mem trans_ex_mem(
		.clock(clock),
		.reset(reset),
		.stall(stall),
		.ex_instruction(ex_instruction_o),
		.ex_operator(ex_operator_o),
		.ex_operand_a(ex_operand_a_o),
		.ex_operand_b(ex_operand_b_o),
		.ex_reg_write_enable(ex_reg_write_enable_o),
		.ex_reg_write_address(ex_reg_write_address_o),
		.ex_reg_write_data(ex_reg_write_data_o),
		.mem_instruction(mem_instruction),
		.mem_operator(mem_operator),
		.mem_operand_a(mem_operand_a),
		.mem_operand_b(mem_operand_b),
		.mem_reg_write_enable(mem_reg_write_enable_i),
		.mem_reg_write_address(mem_reg_write_address_i),
		.mem_reg_write_data(mem_reg_write_data_i)
	);

	stage_mem stage_mem(
		.reset(reset),
		.instruction(mem_instruction),
		.operator(mem_operator),
		.operand_a(mem_operand_a),
		.operand_b(mem_operand_b),
		.mem_read_enable(ram_read_enable),
		.mem_read_address(ram_read_address),
		.mem_read_data(ram_read_data),
		.mem_write_enable(ram_write_enable),
		.mem_write_address(ram_write_address),
		.mem_write_data(ram_write_data),
		.mem_write_select(ram_write_select),
		.reg_write_enable_i(mem_reg_write_enable_i),
		.reg_write_enable_o(mem_reg_write_enable_o),
		.reg_write_address_i(mem_reg_write_address_i),
		.reg_write_address_o(mem_reg_write_address_o),
		.reg_write_data_i(mem_reg_write_data_i),
		.reg_write_data_o(mem_reg_write_data_o)
	);
	
	trans_mem_wb trans_mem_wb(
		.clock(clock),
		.reset(reset),
		.stall(stall),
		.mem_reg_write_enable(mem_reg_write_enable_o),
		.mem_reg_write_address(mem_reg_write_address_o),
		.mem_reg_write_data(mem_reg_write_data_o),
		.wb_reg_write_enable(wb_reg_write_enable),
		.wb_reg_write_address(wb_reg_write_address),
		.wb_reg_write_data(wb_reg_write_data)
	);
	
    assign reg_write_enable = wb_reg_write_enable;
    assign reg_write_address = wb_reg_write_address;
    assign reg_write_data = wb_reg_write_data;
	
	
	
endmodule
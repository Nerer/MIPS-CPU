`define OP_ADD 8'b00010000
`define OP_SUB 8'b00010010
`define OP_AND 8'b00000001
`define OP_OR  8'b00000010
`define OP_XOR 8'b00000011
`define OP_SLT 8'b00001110
`define OP_BEQ 8'b00011101
`define OP_BNE 8'b00100100
`define OP_J   8'b00011001
`define OP_JR  8'b00011100
`define OP_LB  8'b00100101
`define OP_LW  8'b00101001
`define OP_SB  8'b00101100
`define OP_SW  8'b00101110


module stage_id(
	input wire reset,
	input wire [31:0] instruction_i,
	output reg [31:0] instruction_o, //to ex
	output reg [2: 0] category, //to ex
	output reg [7: 0] operator, //to ex
	
	output reg [31:0] operand_a, //to ex
	output reg reg_read_enable_a, //to register
	output reg [4: 0] reg_read_address_a, //to register
	input wire [31:0] reg_read_data_a, //from register
	
	output reg [31:0] operand_b, //to ex
	output reg reg_read_enable_b, // to ex
	output reg [4:0] reg_read_address_b, //to register
	input wire [31:0] reg_read_data_b, //from register
	
	output reg reg_write_enable, //to ex
	output reg [4: 0] reg_write_address, //to ex
	output reg [31:0] reg_write_data, //to ex
	
	
	input wire [31:0] pc_read_data, //from pc(rom)
	output reg pc_write_enable, //to pc
	output reg [31:0] pc_write_data, //to pc
	
	input wire [7: 0] ex_operator, //from ex
	input wire ex_reg_write_enable, //from ex
	input wire [4: 0] ex_reg_write_address, //from ex
	input wire [31:0] ex_reg_write_data, //from ex
	input wire mem_reg_write_enable, //from mem
	input wire [4: 0] mem_reg_write_address, //from mem
	input wire [31:0] mem_reg_write_data, //from mem
	output reg stall_request //to ex
);


	wire [31:0] pc_next    = pc_read_data + 32'd4;
    wire [31:0] pc_jump    = {pc_next[31:28], instruction_i[25:0], 2'b0]};
    wire [31:0] pc_branch  = pc_next + {{14 {instruction_i[15]}}, instruction_i[15:0], 2'b00};
    wire [31:0] ex_operator_is_load = ex_operator == `OP_LB  || ex_operator == `OP_LW;
                                      //ex_operator == `OP_LBU ||
                                      //ex_operator == `OP_LH  ||
                                      //ex_operator == `OP_LHU ||
                                      //ex_operator == `OP_LWL ||
                                      //ex_operator == `OP_LWR;

 
	reg [31:0] imm;
	reg instvalid;
	assign instruction_o = instruction_i;
	
	wire [5:0] op = instruction_i[31:26];
	wire [4:0] op2 = instruction_i[10:6];
	wire [5:0] op3 = instruction_i[5:0];
	wire [4:0] op4 = instruction_i[20:16];
//decoding
	always @(*) begin
		if (reset == `RESET_ENABLE) begin
			operator <= `OP_NOP;
			category <= `CATEGORY_NONE;
			reg_read_enable_a <= `READ_DISABLE;
			reg_read_enable_b <= `READ_DISABLE;
			instvalid = 1'b0;
			reg_read_address_a <= 5'b0;
			reg_read_address_b <= 5'b0;
			reg_write_enable <= `WRITE_DISABLE;
			reg_write_data <= 32'b0;
			reg_write_address <= 5'b0;
			pc_write_enable <= `WRITE_DISABLE;
			pc_write_data <= 32'b0;
			imm <= 32'b0;
		end else begin
			operator <= `OP_NOP;
			category <= `CATEGORY_NONE;
			reg_read_enable_a <= `READ_DISABLE;
			reg_read_enable_b <= `READ_DISABLE;
			instvalid = 1'b0;
			reg_read_address_a <= instruction_i[25:21];
			reg_read_address_b <= instruction_i[20:16];
			reg_write_enable <= `WRITE_DISABLE;
			reg_write_data <= 32'b0;
			reg_write_address <= instruction_i[15:11];
			pc_write_enable <= `WRITE_DISABLE;
			pc_write_data <= 32'b0;
			imm <= 32'b0;
			
			case (op)
				6'b000000 : begin
					case (op2)
						5'b00000 : begin
							case (op3)
								`OPC_AND : begin
								end
								`OPC_OR : begin
								end
								`OPC_XOR : begin
								end
								`OPC_NOR : begin
								end
								`OPC_SLLV : begin
								end
								`OPC_SRLV : begin
								end
								`OPC_SRAV : begin
								end
								`OPC_SYNC : begin
								end
								`OPC_MFHI : begin
								end
								`OPC_MFLO : begin
								end
								`OPC_MTHI : begin
								end
								`OPC_MTLO : begin
								end
								`OPC_MOVN : begin
								end
								`OPC_MOVZ : begin
								end
								`OPC_SLT : begin
								end
								`OPC_SLTU : begin
								end
								`OPC_ADD : begin
								end
								`OPC_ADDU : begin
								end
								`OPC_SUB : begin
								end
								`OPC_SUBU : begin
								end
								`OPC_MUlT : begin
								end
								`OPC_MULTU : begin
								end
								`OPC_JR : begin
								end
								`OPC_JALR : begin
								end
							endcase
						end
					endcase
				end
				6'b000001 : begin
					case (op4) 
						`OPC_BGEZ : begin
						end
						`OPC_BGEZAL : begin
						end
						`OPC_BLTZ : begin
						end
						`OPC_BLTZAL : begin
						end
					endcase
				end
				6'b011100 : begin
					case (op3)
						`OPC_CLZ : begin
						end
						`OPC_CLO : begin
						end
						`OPC_MUL : begin
						end
					endcase
				end
				`OPC_ANDI : begin
					operator <= `OP_AND;
					category <= `CATEGORY_LOGIC;
					reg_read_enable_a <= `READ_ENABLE;
					reg_read_enable_b <= `READ_DISABLE;
					reg_write_enable <= `WRITE_ENABLE;
					reg_write_address <= instruction_i[20:16];
					imm <= {16'b0, instruction_i[15:0]};
					instvalid = 1'b1;
				end
				`OPC_ORI : begin
					operator <= `OP_OR;
					category <= `CATEGORY_LOGIC;
					reg_read_enable_a <= `READ_ENABLE;
					reg_read_enable_b <= `READ_DISABLE;
					reg_write_enable <= `WRITE_ENABLE;
					reg_write_address <= instruction_i[20:16];
					imm <= {16'b0, instruction_i[15:0]};
					instvalid = 1'b1;
				end
				`OPC_XORI : begin
					operator <= `OP_XOR;
					category <= `CATEGORY_LOGIC;
					reg_read_enable_a <= `READ_ENABLE;
					reg_read_enable_b <= `READ_DISABLE;
					reg_write_enable <= `WRITE_ENABLE;
					reg_write_address <= instruction_i[20:16];
					imm <= {16'b0, instruction_i[15:0]};
					instvalid = 1'b1;
				end
				`OPC_LUI : begin
					operator <= `OP_OR;
					category <= `CATEGORY_LOGIC;
					reg_read_enable_a <= `READ_ENABLE;
					reg_read_enable_b <= `READ_DISABLE;
					reg_write_enable <= `WRITE_ENABLE;
					reg_write_address <= instruction_i[20:16];
					imm <= {instruction_i[15:0], 16'b0};
				end
				`OPC_PREF : begin
				end
				`OPC_SLTI : begin
					operator <= `OP_SLT;
					category <= `CATEGORY_ARITHMETIC;
					reg_read_enable_a <= `READ_ENABLE;
					reg_read_enable_b <= `READ_DISABLE;
					reg_write_enable <= `WRITE_ENABLE;
					reg_write_address <= instruction_i[20:16];
					imm <= {16{instruction_i[15]}, instruction_i[15:0]};
					instvalid = 1'b1;
				end
				`OPC_SLTIU : begin
				end
				`OPC_ADDI : begin
					operator <= `OP_ADD;
					category <= `CATEGORY_ARITHMETIC;
					reg_read_enable_a <= `READ_ENABLE;
					reg_read_enable_b <= `READ_DISABLE;
					reg_write_enable <= `WRITE_ENABLE;
					reg_write_address <= instruction_i[20:16];
					imm <= {16{instruction_i[15]}, instruction_i[15:0]};
				end
				`OPC_ADDIU : begin
				end
				`OPC_LB : begin
					operator <= `OP_LB;
					category <= `CATEGORY_MEMORY;
					reg_read_enable_a <= `READ_ENABLE;
					reg_read_enable_b <= `READ_DISABLE;
					reg_write_enable <= `WRITE_ENABLE;
					reg_write_address <= instruction_i[20:16];
				end
				`OPC_LBU : begin
				end
				`OPC_LH : begin
				end
				`OPC_LHU : begin
				end
				`OPC_LW : begin
					operator <= `OP_LW;
					category <= `CATEGORY_MEMORY;
					reg_read_enable_a <= `READ_ENABLE;
					reg_read_enable_b <= `READ_DISABLE;
					reg_write_enable <= `WRITE_ENABLE;
					reg_write_address <= instruction_i[20:16];
				end
				`OPC_LWL : begin
				end
				`OPC_LWR : begin
				end
				`OPC_SB : begin
					operator <= `OP_SB;
					category <= `CATEGORY_MEMORY;
					reg_read_enable_a <= `READ_ENABLE;
					reg_read_enable_b <= `READ_DISABLE;
					reg_write_enable <= `WRITE_ENABLE;
					reg_write_address <= instruction_i[20:16];
				end
				`OPC_SH : begin
				end
				`OPC_SW : begin
					operator <= `OP_SB;
					category <= `CATEGORY_MEMORY;
					reg_read_enable_a <= `READ_ENABLE;
					reg_read_enable_b <= `READ_DISABLE;
					reg_write_enable <= `WRITE_ENABLE;
					reg_write_address <= instruction_i[20:16];
				end
				`OPC_SWL : begin
				end
				`OPC_SWR : begin
				end
				`OPC_J : begin
					operator <= `OP_j;
					category <= `CATEGORY_JUMP;
					reg_read_enable_a <= `READ_DISABLE;
					reg_read_enable_b <= `READ_DISABLE;
					reg_write_enable <= `WRITE_DISABLE;
					pc_write_enable <= `WRITE_ENABLE;
					pc_write_data <= pc_jump;
				end
				`OPC_JAL : begin
				end
				`OPC_BEQ : begin
				end
				`OPC_BNE : begin
				end
				`OPC_BGTZ : begin
				end
				`OPC_BLEZ : begin
				end
				
			endcase
				
			if (instruction_i[31:21] == 11'b0) begin
				case (op3)
					`OPC_SLL : begin
					end
					`OPC_SRL : begin
					end
					`OPC_SRA : begin
					end
				endcase
			end
		end
	end


//get operand
	always @(*) begin
		if (reset == `RESET_ENABLE) begin
			operand_a <= 32'b0;
		end
		else if (reg_read_enable_a == `READ_DISABLE) begin
			operand_a <= imm;
		end
		else if (ex_reg_write_enable == `WRITE_ENABLE && reg_read_address_a == ex_reg_write_address) begin
			operand_a <= ex_reg_write_data;
		end
		else if (mem_reg_write_enable == `WRITE_ENABLE && reg_read_address_a == mem_reg_write_address) begin
			operand_a <= mem_reg_write_data;
		end 
		else begin
			operand_a <= reg_read_data_a;
		end
	end
	
	always @(*) begin
		if (reset == `RESET_ENABLE) begin
			operand_b <= 32'b0;
		end
		else if (reg_read_enable_b == `READ_DISABLE) begin
			operand_b <= imm;
		end
		else if (ex_reg_write_enable == `WRITE_ENABLE && reg_read_address_b == ex_reg_write_address) begin
			operand_b <= ex_reg_write_data;
		end
		else if (mem_reg_write_enable == `WRITE_ENABLE && reg_read_address_b == mem_reg_write_address) begin
			operand_b <= mem_reg_write_data;
		end 
		else begin
			operand_b <= reg_read_data_b;
		end
	end

endmodule
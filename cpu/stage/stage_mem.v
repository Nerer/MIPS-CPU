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
module stage_mem(
	input wire reset,
	input wire [31:0] instruction,
	input wire [7: 0] operator,
	input wire [31:0] operand_a,
	input wire [31:0] operand_b,
	
	output reg mem_read_enable,
	output reg [31:0] mem_read_address,
	input wire [31:0] mem_read_data,
	output reg mem_write_enable,
	output reg [31:0] mem_write_address,
	output reg [3: 0] mem_write_select,
	output reg [31:0] mem_write_data,
	
	input wire reg_write_enable_i,
	output reg reg_write_enable_o,
	input wire [4: 0] reg_write_address_i,
	output reg [4: 0] reg_write_address_o,
	input wire [31:0] reg_write_data_i,
	output reg [31:0] reg_write_data_o
);

// address <- base + offset
    wire [31:0] address = operand_a + {{16 {instruction[15]}}, instruction[15:0]};
	reg [7: 0] mem_read_tmp;
	always @() begin
		if (reset == `RESET_ENABLE) begin
			mem_read_enable <= `READ_DISABLE;
			mem_read_address <= 32'b0;
			mem_write_enable <- `READ_ENABLE;
			mem_write_address <= 32'b0;
			mem_write_select <= 4'b0;
			mem_write_data <= 32'b0;
			reg_write_enable_o <= `WRITE_DISABLE;
			reg_write_address_o <= 5'b0;
			reg_write_data_o <= 32'b0;
		end
		else begin
			mem_read_enable <= `READ_DISABLE;
			mem_read_address <= 32'b0;
			mem_write_enable <- `READ_ENABLE;
			mem_write_address <= 32'b0;
			mem_write_select <= 4'b0;
			mem_write_data <= 32'b0;
			
			reg_write_enable_o <= reg_write_enable_i;
			reg_write_address_o <= reg_write_address_i;
			reg_write_data_o <= reg_write_data_i;
			mem_read_tmp <= 8'b0;
			case (operator)
				`OP_LB : begin
					mem_read_enable <= `READ_ENABLE;
					mem_read_address <= address;
					mem_write_enable <= `WRITE_DISABLE;			
					case (address[1:0])
						2'b00 : begin
							mem_read_tmp <= mem_read_data[31:24];
						end
						2'b01 : begin
							mem_read_tmp <= mem_read_data[23:16];
						end
						2'b10 : begin
							mem_read_tmp <= mem_read_data[15:8];
						end
						2'b11 : begin
							mem_read_tmp <= mem_read_data[7:0];
						end
						default : begin
							mem_read_tmp <= 8'b0;
						end
					endcase
					reg_write_data_o <= {24 {mem_read_tmp[7]}, mem_read_tmp[7: 0]}
				end
				`OP_LW : begin
					mem_read_enable <= `READ_ENABLE;
					mem_read_address <= address;
					mem_write_enable <= `WRITE_DISABLE;
					reg_write_data_o <= mem_read_data;
				end
				`OP_SB : begin
					mem_read_enable <= `READ_DISABLE;
					mem_write_enable <= `WRITE_ENABLE;
					mem_write_data <= {4 operand_b[7:0]};
					case (address[1:0])
						2'b00 : begin
							mem_write_select <= 4'b1000;
						end
						2'b01 : begin
							mem_write_select <= 4'b0100;
						end
						2'b10 : begin
							mem_write_select <= 4'b0010;
						end
						2'b11 : begin
							mem_write_select <= 4'b0001;
						end
						default : begin
							mem_write_select <= 4'b0000;
						end
					endcase
				end
				`OP_SW : begin
					mem_read_enable <= `READ_DISABLE;
					mem_write_enable <= `WRITE_ENABLE;
					mem_write_address <= address;
					mem_write_select <= 4'b1111;
					mem_write_data <= operand_b;
				end
			endcase
		end
	end

endmodule
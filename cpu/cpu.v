module cpu(
	input wire clock，
	input wire reset，
	output wire[31:0] rom_read_address，
	input wire[31:0] rom_read_data,
	output wire ram_read_enable,
	output wire[31:0] ram_read_address,
	input wire[31:0] ram_read_data,
	output wire ram_write_enable,
	output wire[31:0] ram_write_address,
	output wire[3: 0] ram_write_select,
	output wire[31:0] ram_write_data
);

	


endmodule
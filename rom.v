include "defines.v";
module rom(
	input wire chip_enable,
	input wire [31:0] read_address,
	output reg [31:0] read_data
);

	reg[31:0] storage[0:1023];
	
	initial $readmemh("instruction_rom_data", storage);
	always @ (*) begin
		if (chip_enable == `CHIP_DISABLE) begin
			read_data <= 32'b0;
		end
		else begin
			read_data <= storage[read_address[11:2]];
		end
	end
  
endmodule
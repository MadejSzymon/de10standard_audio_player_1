import pkg::*;
module memory(o_audio_addr, i_clk, o_audio_data, i_renb);
	
	input i_renb;
	input i_clk;
	
	output [15:0] o_audio_addr;
	output [15:0] o_audio_data;
	
	audio_rom audio_rom (
		.address ( o_audio_addr ),
		.clock ( i_clk ),
		.q ( o_audio_data )
	);
	
	addr_counter addr_counter(
		.i_clk(i_clk),
		.i_enb(i_renb),
		.o_cnt(o_audio_addr)
	);
	
endmodule 
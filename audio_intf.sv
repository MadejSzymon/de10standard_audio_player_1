import pkg::*;
module audio_intf(i_clk, i_lcr_enb, i_audio_data,
			o_audio_data, o_renb, o_lcr);
	
	input i_clk;
	input i_lcr_enb;
	input [15:0] i_audio_data;
	
	output o_audio_data;
	output o_renb;
	output logic o_lcr = 0;
	
	logic [1:0] r_lcr_del = 0;
	
	serializer serializer(
		.i_clk(i_clk),
		.i_enb(r_lcr_del[0]),
		.i_data(i_audio_data),
		.o_data(o_audio_data)
	);
	
	lcr_gen lcr_gen(
		.i_clk(i_clk),
		.i_enb(i_lcr_enb),
		.o_lcr(o_renb)
	);
	
	always@(negedge i_clk) begin
		r_lcr_del[1] <= o_renb;
		r_lcr_del[0] <= r_lcr_del[1];
		o_lcr <= r_lcr_del[0];
	end
	
endmodule 
import pkg::*;
module addr_counter(i_clk, i_enb, o_cnt);
	
	input i_clk;
	input i_enb;
	output logic [15:0] o_cnt = 65535;
	
	always@(negedge i_clk) begin
		if(i_enb)
			o_cnt <= o_cnt + 1'b1;
		if(o_cnt == 65534)
			o_cnt <= 65535;
	end
endmodule 
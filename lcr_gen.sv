
module lcr_gen(i_clk, i_enb, o_lcr);
	
	input i_clk;
	input i_enb;
	output logic o_lcr = 1'b0;
	
	logic [10:0] r_counter = 1'b0;
	
	always@(posedge i_clk) begin
		if(i_enb) begin
			if(r_counter <= 1488) 
				r_counter <= r_counter + 1'b1;
			else
				r_counter <= 1'b0;
		end
		
		if(i_enb && r_counter == 1'b0)
			o_lcr <= 1'b1;
		else
			o_lcr <= 1'b0;
	end
endmodule 
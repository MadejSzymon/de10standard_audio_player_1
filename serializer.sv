module serializer(i_clk, i_enb, i_data, o_data);
	
	input i_clk;
	input i_enb;
	input [15:0] i_data;
	
	output o_data;
	
	logic [31:0] r_data = 0;
	
	assign o_data = r_data[31];
	
	always@(negedge i_clk) begin
		if(i_enb)
			r_data <= {i_data,i_data};
		else
			r_data <= r_data << 1;
	end
endmodule 
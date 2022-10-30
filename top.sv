import pkg::*;
module top(i_CLOCK_50, i_KEY, o_DACDAT, o_DACLRC, o_I2C_SDAT, o_I2C_SCLK, o_MCLK, o_BCLK);
	
	input i_KEY;
	input i_CLOCK_50;
	
	logic w_i2c_done;
	logic w_i2c_next;
	logic w_i2c_enb;
	logic [8:0] w_data;
	logic [6:0] w_addr;
	logic w_clk_12;
	logic w_lcr_enb;
	logic w_renb;
	logic [15:0] w_audio_addr;
	logic [15:0] w_audio_data;
	
	output o_DACLRC;
	output o_DACDAT;
	output o_I2C_SDAT;
	output o_I2C_SCLK;
	output o_MCLK;
	output o_BCLK;
	
	assign o_MCLK = w_clk_12;
	assign o_BCLK = w_clk_12;
	
	pll_12 pll_12(
		.refclk(i_CLOCK_50),   //  refclk.clk
		.rst(0),      //   reset.reset
		.outclk_0(w_clk_12)  // outclk0.clk
	);

	fsm fsm(
		.i_clk(w_clk_12),
		.i_enb(!i_KEY),
		.i_i2c_done(w_i2c_done), 
		.i_i2c_next(w_i2c_next),
		.o_i2c_enb(w_i2c_enb),
		.o_lcr_enb(w_lcr_enb),
		.o_data(w_data),
		.o_addr(w_addr),
		.i_audio_addr(w_audio_addr)
	);
	
	i2c i2c(
		.i_clk(w_clk_12),
		.i_enb(w_i2c_enb),
		.i_data(w_data),
		.i_addr(w_addr),
		.io_i2c(o_I2C_SDAT),
		.o_done(w_i2c_done),
		.o_clk_i2c(o_I2C_SCLK),
		.o_i2c_next(w_i2c_next)
	);
	
	memory memory(
		.o_audio_addr(w_audio_addr),
		.i_clk(w_clk_12),
		.o_audio_data(w_audio_data),
		.i_renb(w_renb)
	);
	
	audio_intf audio_intf(
		.i_clk(w_clk_12),
		.i_lcr_enb(w_lcr_enb),
		.i_audio_data(w_audio_data),
		.o_audio_data(o_DACDAT),
		.o_renb(w_renb),
		.o_lcr(o_DACLRC)
	);
	

endmodule 
`timescale 1ns/100ps
import pkg::*;
module tb();

	logic i_clk = 0;
	logic i_enb = 0;
	
	logic w_i2c_done;
	logic w_i2c_next;
	logic w_i2c_enb;
	logic [8:0] w_data;
	logic [6:0] w_addr;
	fsm_states fsm_state;
	fsm_states fsm_next;
	logic o_i2c;
	logic o_clk_i2c;
	logic w_clk_12;
	logic w_clk_12_90;
	logic w_lcr_enb;
	logic o_lcr;
	logic [4:0] w_audio_addr;
	logic [15:0] w_audio_data;
	logic o_audio_data;
	logic [2:0] r_lcr_del;
	logic [31:0] r_data;
	logic i_btn = 1;
	
	always begin
		#10;
		i_clk <= !i_clk;
	end
	
	top DUT(
		.*
	);
	
	initial begin
		repeat(5) @(negedge i_clk);
		i_btn <= 0;
		i_enb <= 1'b1;
		repeat(5) @(negedge i_clk);
		i_enb <= 1'b0;
		#1000;
		i_btn <= 1;
		#10_500_000;
		i_enb <= 1'b1;
		repeat(5) @(negedge i_clk);
		i_enb <= 1'b0;
		#10_500_000;
		$stop();
	end
	
endmodule 
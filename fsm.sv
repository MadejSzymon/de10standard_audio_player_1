import pkg::*;
module fsm(i_clk, i_enb, i_i2c_done, i_i2c_next, o_i2c_enb, o_data, o_addr, o_lcr_enb, i_audio_addr);
	input i_clk;
	input i_enb;
	input i_i2c_done;
	input i_i2c_next;
	input [15:0] i_audio_addr;
	output logic o_i2c_enb = 0;
	output logic [8:0] o_data = 0;
	output logic [6:0] o_addr = 0;
	
	fsm_states state;
	fsm_states next;
	output logic o_lcr_enb = 0;
	logic r_i2c_flag = 0;
	
	always@(negedge i_clk)
		state <= next;
		
	always@(*) begin
		case(state)
			IDLE: begin
				if(i_enb && r_i2c_flag)
					next = PLAY;
				else if (i_enb && !r_i2c_flag)
					next = L_HEAD_OUT;
					//next = PLAY;
				else
					next = IDLE;
			end  
			 L_HEAD_OUT: begin
				if(i_i2c_next)
					next = ANG_AUDIO_PATH_CTRL;
				else
					next = L_HEAD_OUT;
			 end
			 ANG_AUDIO_PATH_CTRL: begin
				if(i_i2c_next)
					next = DIG_AUDIO_PATH_CTRL;
				else
					next = ANG_AUDIO_PATH_CTRL;
			 end
			 DIG_AUDIO_PATH_CTRL: begin
				if(i_i2c_next)
					next = PWR_DWN_CTRL;
				else
					next = DIG_AUDIO_PATH_CTRL;
			 end
			 PWR_DWN_CTRL: begin
				if(i_i2c_next)
					next = DIG_AUDIO_INTF_FOR;
				else
					next = PWR_DWN_CTRL;
			 end
			 DIG_AUDIO_INTF_FOR: begin
				if(i_i2c_next)
					next = SMPL_CTRL;
				else
					next = DIG_AUDIO_INTF_FOR;
			 end
			 SMPL_CTRL: begin
				if(i_i2c_next)
					next = ACTIVE_CTRL;
				else
					next = SMPL_CTRL;
			 end
			 ACTIVE_CTRL: begin
				if(i_i2c_next)
					next = RST_REG;
				else
					next = ACTIVE_CTRL;
			 end
			 RST_REG: begin
				if(i_i2c_next)
					next = BREAK;
				else
					next = RST_REG;
			 end
			 BREAK: begin
				if(i_i2c_done)
					next = PLAY;
				else
					next = BREAK;
			end
			PLAY: begin
				if(i_audio_addr == 65534)
					next = IDLE;
				else
					next = PLAY;
			end
		endcase
	end
	
	always@(negedge i_clk) begin
		if(state == RST_REG && i_i2c_next)
			o_i2c_enb <= 0;
		
		if(state == L_HEAD_OUT)
			o_i2c_enb <= 1;
	end
	
	always@(negedge i_clk) begin
		case(state) 
			 IDLE: begin
				o_lcr_enb <= 0;
			 end
			 L_HEAD_OUT: begin
				o_data <= DATA_L_HEAD_OUT;
				o_addr <= ADDR_L_HEAD_OUT;
				r_i2c_flag <= 1;
			 end
			 ANG_AUDIO_PATH_CTRL: begin
				o_data <= DATA_ANG_AUDIO_PATH_CTRL;
				o_addr <= ADDR_ANG_AUDIO_PATH_CTRL;				
			 end
			 DIG_AUDIO_PATH_CTRL: begin
				o_data <= DATA_DIG_AUDIO_PATH_CTRL;
				o_addr <= ADDR_DIG_AUDIO_PATH_CTRL;				
			 end
			 PWR_DWN_CTRL: begin
				o_data <= DATA_PWR_DWN_CTRL;
				o_addr <= ADDR_PWR_DWN_CTRL;				
			 end
			 DIG_AUDIO_INTF_FOR: begin
				o_data <= DATA_DIG_AUDIO_INTF_FOR;
				o_addr <= ADDR_DIG_AUDIO_INTF_FOR;				
			 end
			 SMPL_CTRL: begin
				o_data <= DATA_SMPL_CTRL;
				o_addr <= ADDR_SMPL_CTRL;				
			 end
			 ACTIVE_CTRL: begin
				o_data <= DATA_ACTIVE_CTRL;
				o_addr <= ADDR_ACTIVE_CTRL;				
			 end
			 PLAY: begin
				o_lcr_enb <= 1;
			 end
		endcase
	end
endmodule 
import pkg::*;
module i2c(i_clk, i_enb, i_data, i_addr, io_i2c, o_done, o_clk_i2c, o_i2c_next);
	
	input i_clk;
	input i_enb;
	input [8:0] i_data;
	input [6:0] i_addr;
	
	inout io_i2c;
	
	output o_done;
	output logic o_clk_i2c = 1'b1;
	output o_i2c_next;
	
	logic r_i2c = 1'b1;
	logic o_master_busy;
	i2c_states state = I2C_IDLE;
	i2c_states next =  I2C_IDLE;
	logic [6:0] r_addr_dev = ADDR_DEV;
	logic [7:0] r_data = 0;
	logic [3:0] r_counter = 0;
	logic [7:0] r_clk_i2c_counter = 0;
	logic r_enb_flag = 0;
	logic w_detect_negedge;
	logic r_clk_i2c_del = 1;
	logic r_detect_negedge_del = 0;
	
	assign io_i2c = (o_master_busy) ? r_i2c : 1'bz;
	assign o_master_busy = (state != I2C_ACK_1 && state != I2C_ACK_2 && state != I2C_ACK_3) ? 1'b1 : 1'b0;
	assign o_done = (state == I2C_RESET) ? 1'b1 : 1'b0;
	assign o_i2c_next = (state == I2C_STOP && r_clk_i2c_counter == 0 && o_clk_i2c == 1) ? 1'b1 : 1'b0;
	
	always@(negedge i_clk) begin
		if(i_enb && state == I2C_IDLE)
			r_enb_flag <= 1'b1;
		
		if(state == I2C_RESET)
			r_enb_flag <= 1'b0;
	end
	
	always@(negedge i_clk) begin
		if(r_enb_flag) begin
			if(r_clk_i2c_counter == 25) begin
				r_clk_i2c_counter <= 0;
				o_clk_i2c <= !o_clk_i2c;
			end
			else
				r_clk_i2c_counter <= r_clk_i2c_counter + 1'b1;
		end
		else
			r_clk_i2c_counter <= 0;
			
		if(state == I2C_STOP && o_clk_i2c)
			o_clk_i2c <= 1; 
	end
	
	always@(negedge i_clk)
		r_clk_i2c_del <= o_clk_i2c;
	
	assign w_detect_negedge = (!o_clk_i2c && r_clk_i2c_del) ? 1'b1 : 1'b0;
	
	always@(negedge i_clk)
		r_detect_negedge_del <= w_detect_negedge;
	
	always@(*) begin
		case(state)
			I2C_IDLE: begin
				if(r_enb_flag)
					next = I2C_START;
				else
					next = I2C_IDLE;
			end
			I2C_START: begin
				next = I2C_ADDR_DEV_WRITE;				
			end
			I2C_ADDR_DEV_WRITE: begin
				if(r_counter == 7)
					next = I2C_ACK_1;
				else
					next = I2C_ADDR_DEV_WRITE;				
			end
			I2C_ACK_1: begin
				//if()
					next = I2C_ADDR_REG;
				//else
					//next = I2C_STOP;				
			end
			I2C_ADDR_REG: begin
				if(r_counter == 8)
					next = I2C_ACK_2;
				else
					next = I2C_ADDR_REG;				
			end
			I2C_ACK_2: begin
				//if()
					next = I2C_DATA;
				//else
					//next = I2C_STOP;				
			end
			I2C_DATA: begin
				if(r_counter == 8)
					next = I2C_ACK_3;
				else
					next = I2C_DATA;				
			end
			I2C_ACK_3: begin
					next = I2C_STOP;			
			end
			I2C_STOP: begin
				   next = I2C_RESET;
			end
			I2C_RESET: begin
				   next = I2C_IDLE;
			end
		endcase
	end
	
	always@(negedge i_clk) begin
		if(w_detect_negedge || state == I2C_RESET || (state == I2C_STOP && o_clk_i2c && r_clk_i2c_counter == 25) || (state == I2C_START && !o_clk_i2c && r_clk_i2c_counter == 12))
			state <= next;
	end
		
	always@(negedge i_clk) begin
		if (next == I2C_START && r_clk_i2c_counter == 0)
			r_i2c <= 0;
		
		if(state == I2C_STOP && o_clk_i2c && r_clk_i2c_counter == 12)
			r_i2c <= 1;
			
		if(state == I2C_RESET) begin
			r_addr_dev <= ADDR_DEV;
			r_data <= 0;
			r_counter <= 0;
		end
			
		if(r_detect_negedge_del) begin
			case(state)
				I2C_IDLE: begin
				end
				I2C_START: begin
					r_data <= {i_addr,i_data[8]};
				end
				I2C_ADDR_DEV_WRITE: begin
					r_counter <= r_counter + 1'b1;
					r_addr_dev <= r_addr_dev << 1;
					r_i2c <= r_addr_dev[6];
				end
				I2C_ACK_1: begin
					r_counter <= 0;
					r_i2c <= 0;
				end
				I2C_ADDR_REG: begin
					r_counter <= r_counter + 1'b1;
					r_data <= r_data << 1;
					r_i2c <= r_data[7];
				end
				I2C_ACK_2: begin
					r_data <= i_data[7:0];
					r_counter <= 0;
					r_i2c <= 0;
				end
				I2C_DATA: begin
					r_counter <= r_counter + 1'b1;
					r_data <= r_data << 1;
					r_i2c <= r_data[7];
				end
				I2C_ACK_3: begin
					r_counter <= 0;
					r_i2c <= 0;
				end
			endcase
		end
	end
endmodule 
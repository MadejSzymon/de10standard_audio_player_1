package pkg;
	typedef enum {
	 IDLE,  
	 L_HEAD_OUT, 
	 ANG_AUDIO_PATH_CTRL,
	 DIG_AUDIO_PATH_CTRL,
	 PWR_DWN_CTRL,
	 DIG_AUDIO_INTF_FOR, 
	 SMPL_CTRL, 
	 ACTIVE_CTRL,
	 RST_REG,
	 BREAK,
	 PLAY} fsm_states;
	 
	 typedef enum {
	 I2C_IDLE,
	 I2C_START,
	 I2C_ADDR_DEV_WRITE,
	 I2C_ACK_1,
	 I2C_ADDR_REG,
	 I2C_ACK_2,
	 I2C_DATA,
	 I2C_ACK_3,
	 I2C_STOP,
	 I2C_RESET} i2c_states;
	
	parameter ADDR_DEV = 7'b0110100;
	
	parameter ADDR_L_LINE_IN = 7'b0000_000;
	parameter ADDR_R_LINE_IN = 7'b0000_001;
	parameter ADDR_L_HEAD_OUT = 7'b0000_010;
	parameter ADDR_R_HEAD_OUT = 7'b0000_011;
	parameter ADDR_ANG_AUDIO_PATH_CTRL = 7'b0000_100;
	parameter ADDR_DIG_AUDIO_PATH_CTRL = 7'b0000_101;
	parameter ADDR_PWR_DWN_CTRL = 7'b0000_110;
	parameter ADDR_DIG_AUDIO_INTF_FOR = 7'b0000_111;
	parameter ADDR_SMPL_CTRL = 7'b000_1000;
	parameter ADDR_ACTIVE_CTRL = 7'b000_1001;
	parameter ADDR_RST_REG = 7'b0001_111;
	
	
	parameter DATA_L_HEAD_OUT = 9'b101110000;
	parameter DATA_ANG_AUDIO_PATH_CTRL = 9'b000010010;
	parameter DATA_DIG_AUDIO_PATH_CTRL = 9'b000000000;
	parameter DATA_PWR_DWN_CTRL = 9'b000000111;
	parameter DATA_DIG_AUDIO_INTF_FOR = 9'b000000011;
	parameter DATA_SMPL_CTRL = 9'b000001101;
	parameter DATA_ACTIVE_CTRL = 9'b111111111;
	parameter DATA_RST_REG = 9'b000000000;
endpackage 
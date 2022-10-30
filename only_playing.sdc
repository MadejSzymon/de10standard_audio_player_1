create_clock -name i_CLOCK_50 -period 20.000 [get_ports {i_CLOCK_50}]
derive_pll_clocks -create_base_clocks
derive_clock_uncertainty
set_false_path -from [get_ports {i_KEY}]
set_false_path -to [get_ports {o_DACDAT o_BCLK o_I2C_SCLK o_I2C_SDAT o_DACLRC o_MCLK}]
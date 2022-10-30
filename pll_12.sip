set_global_assignment -entity "pll_12" -library "lib_pll_12" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pll_12" -library "lib_pll_12" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "pll_12" -library "lib_pll_12" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll_12" -name SPD_FILE [file join $::quartus(sip_path) "pll_12.spd"]

set_global_assignment -library "lib_pll_12" -name MISC_FILE [file join $::quartus(sip_path) "pll_12_sim/pll_12.vo"]

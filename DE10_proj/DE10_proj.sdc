create_clock -period 20.0 [get_ports CLOCK_50]

derive_pll_clocks
derive_clock_uncertainty

set_max_delay 4.0 -from CLOCK_50 -to u_codec_driver|pll_inst|altpll_component|auto_generated|generic_pll1~PLL_OUTPUT_COUNTER|divclk

set_max_delay 4.0 -from CLOCK_50 -to [get_ports {VGA*}]

set_false_path -from [get_ports {KEY*}] -to *
set_false_path -from [get_ports {SW*} ] -to *
set_false_path -from * -to [get_ports {LED*}]
set_false_path -from * -to [get_ports {HEX*}]
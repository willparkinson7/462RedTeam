set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

create_clock -period 83.3 -name clk -waveform {0.000 41.650} [get_ports clk] 
set_property PACKAGE_PIN L17 [get_ports {clk}]  
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]

set_property PACKAGE_PIN J17 [get_ports {txd}]   
set_property IOSTANDARD LVCMOS33 [get_ports {txd}]

set_property PACKAGE_PIN J18 [get_ports {rxd}]   
set_property IOSTANDARD LVCMOS33 [get_ports {rxd}]

set_property PACKAGE_PIN B18 [get_ports {reset_h}]   
set_property IOSTANDARD LVCMOS33 [get_ports {reset_h}]

set_property PACKAGE_PIN G17 [get_ports {r[1]}]  
set_property PACKAGE_PIN H17 [get_ports {r[0]}]  

set_property PACKAGE_PIN G19 [get_ports {g[1]}]
set_property PACKAGE_PIN H19 [get_ports {g[0]}]


set_property PACKAGE_PIN N18 [get_ports {b[1]}] 
set_property PACKAGE_PIN J19 [get_ports {b[0]}] 

set_property PACKAGE_PIN K18 [get_ports {hs}]
set_property PACKAGE_PIN L18 [get_ports {vs}]

set_property IOSTANDARD LVCMOS33 [get_ports {r[0]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {r[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {g[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {b[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {hs}]
set_property IOSTANDARD LVCMOS33 [get_ports {vs}]
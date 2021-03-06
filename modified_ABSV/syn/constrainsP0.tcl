#Applying constraints

#clock
#Max frequency:

create_clock -name MY_CLK -period 0 RISC_CLK
set_dont_touch_network MY_CLK
set_clock_uncertainty 0.07 [get_clocks MY_CLK]

#Delay input signal w.r.t. clock
set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection [all_inputs] clk]
set_output_delay 0.5 -max -clock MY_CLK [all_outputs]

#Insert output loads
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

######################
#ungroup -all -flatten
#set_implementation DW02_mult/pparch [find cell *mult*]
compile
#optimize_registers
#compile_ultra
report_timing > report_timingP0_RISCV.txt

#Save data required
ungroup -all -flatten
change_names -hierarchy -rules verilog
write_sdf ../netlist/RISCV.sdf
write -f verilog -hierarchy -output ../netlist/RISCV.v
write_sdc ../netlist/RISCV.sdc

#quit

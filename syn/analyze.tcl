#Reading VHDL source files
analyze -f vhdl -lib work ../src/RISCV_package.vhd
analyze -f vhdl -lib work ../src/FA.vhd
analyze -f vhdl -lib work ../src/mux2to1.vhd
analyze -f vhdl -lib work ../src/mux4to1.vhd
analyze -f vhdl -lib work ../src/RCA_8bit.vhd
analyze -f vhdl -lib work ../src/CSA_32bit.vhd
analyze -f vhdl -lib work ../src/reg.vhd
analyze -f vhdl -lib work ../src/reg_1.vhd
analyze -f vhdl -lib work ../src/ALU.vhd
analyze -f vhdl -lib work ../src/Immediate_gen.vhd
analyze -f vhdl -lib work ../src/CU.vhd
analyze -f vhdl -lib work ../src/RegFile_behav.vhd
analyze -f vhdl -lib work ../src/DP1_fetch.vhd
analyze -f vhdl -lib work ../src/DP2_decode.vhd
analyze -f vhdl -lib work ../src/DP3_execute.vhd
analyze -f vhdl -lib work ../src/RISC.vhd

set power_preserve_rtl_hier_names true

elaborate RISC -arch structural -lib work > ./elaborate.txt

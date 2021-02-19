vcom -93 -work ./work ../src/RISCV_package.vhd
vcom -93 -work ./work ../src/FA.vhd
vcom -93 -work ./work ../src/mux2to1.vhd
vcom -93 -work ./work ../src/mux4to1.vhd
vcom -93 -work ./work ../src/reg.vhd
vcom -93 -work ./work ../src/reg_1.vhd
vcom -93 -work ./work ../src/Immediate_gen.vhd
vcom -93 -work ./work ../src/RCA_8bit.vhd
vcom -93 -work ./work ../src/CSA_32bit.vhd
vcom -93 -work ./work ../src/ALU.vhd
vcom -93 -work ./work ../src/RegFile_behav.vhd
vcom -93 -work ./work ../src/DP1_fetch.vhd
vcom -93 -work ./work ../src/DP2_decode.vhd
vcom -93 -work ./work ../src/DP3_execute.vhd
vcom -93 -work ./work ../src/CU.vhd
vcom -93 -work ./work ../src/RISC.vhd

vcom -93 -work ./work ../tb/tb_RISCV.vhd
vsim work.TB_RISCV

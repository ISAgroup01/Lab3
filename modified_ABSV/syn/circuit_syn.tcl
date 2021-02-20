#Reading VHDL source files
analyze -f vhdl -lib work ../src/fpuvhdl/common/fpnormalize_fpnormalize.vhd
analyze -f vhdl -lib work ../src/fpuvhdl/common/fpround_fpround.vhd
analyze -f vhdl -lib work ../src/fpuvhdl/common/packfp_packfp.vhd
analyze -f vhdl -lib work ../src/fpuvhdl/common/unpackfp_unpackfp.vhd
analyze -f vhdl -lib work ../src/fpuvhdl/common/reg.vhd
analyze -f vhdl -lib work ../src/fpuvhdl/multiplier/fpmul_stage1_struct.vhd
analyze -f vhdl -lib work ../src/fpuvhdl/multiplier/fpmul_stage2_struct.vhd
analyze -f vhdl -lib work ../src/fpuvhdl/multiplier/fpmul_stage3_struct.vhd
analyze -f vhdl -lib work ../src/fpuvhdl/multiplier/fpmul_stage4_struct.vhd
analyze -f vhdl -lib work ../src/fpuvhdl/multiplier/fpmul_pipeline.vhd

set power_preserve_rtl_hier_names true

elaborate FPmul -arch pipeline -lib work > ./elaborate.txt

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group RISCV /tb_riscv/sig_risc_clk
add wave -noupdate -expand -group RISCV /tb_riscv/sig_risc_rst
add wave -noupdate -expand -group RISCV -radix hexadecimal /tb_riscv/sig_i_mem_read
add wave -noupdate -expand -group RISCV -radix hexadecimal /tb_riscv/sig_i_mem_address
add wave -noupdate -expand -group RISCV /tb_riscv/sig_d_mem_re
add wave -noupdate -expand -group RISCV -radix decimal /tb_riscv/sig_d_mem_read
add wave -noupdate -expand -group RISCV -radix hexadecimal /tb_riscv/sig_d_mem_address
add wave -noupdate -expand -group RISCV /tb_riscv/sig_d_mem_we
add wave -noupdate -expand -group RISCV -radix decimal /tb_riscv/sig_d_mem_write
add wave -noupdate -expand -group RISCV -group {I&D mem} -radix decimal /tb_riscv/data_mem
add wave -noupdate -expand -group RISCV -group {I&D mem} -radix hexadecimal /tb_riscv/instruction_mem
add wave -noupdate -group Fetch -group mux_if -radix unsigned /tb_riscv/risc_v/dp_fetch/mux_if/a
add wave -noupdate -group Fetch -group mux_if -radix unsigned /tb_riscv/risc_v/dp_fetch/mux_if/b
add wave -noupdate -group Fetch -group mux_if /tb_riscv/risc_v/dp_fetch/mux_if/sel
add wave -noupdate -group Fetch -group mux_if -radix unsigned /tb_riscv/risc_v/dp_fetch/mux_if/s
add wave -noupdate -group Fetch -group reg_pc -radix unsigned /tb_riscv/risc_v/dp_fetch/reg_pc/reg_in
add wave -noupdate -group Fetch -group reg_pc /tb_riscv/risc_v/dp_fetch/reg_pc/reg_en
add wave -noupdate -group Fetch -group reg_pc /tb_riscv/risc_v/dp_fetch/reg_pc/reg_reset
add wave -noupdate -group Fetch -group reg_pc -radix unsigned /tb_riscv/risc_v/dp_fetch/reg_pc/reg_out
add wave -noupdate -group Fetch -group {pc_update CSA} -radix unsigned /tb_riscv/risc_v/dp_fetch/pc_update/a_csa
add wave -noupdate -group Fetch -group {pc_update CSA} -radix unsigned /tb_riscv/risc_v/dp_fetch/pc_update/b_csa
add wave -noupdate -group Fetch -group {pc_update CSA} /tb_riscv/risc_v/dp_fetch/pc_update/cin_csa
add wave -noupdate -group Fetch -group {pc_update CSA} /tb_riscv/risc_v/dp_fetch/pc_update/cout_csa
add wave -noupdate -group Fetch -group {pc_update CSA} -radix unsigned /tb_riscv/risc_v/dp_fetch/pc_update/s_csa
add wave -noupdate -group Decode -group RF -radix unsigned /tb_riscv/risc_v/dp_decode/register_file/readregister1
add wave -noupdate -group Decode -group RF -radix decimal /tb_riscv/risc_v/dp_decode/register_file/readdata1
add wave -noupdate -group Decode -group RF -radix unsigned /tb_riscv/risc_v/dp_decode/register_file/readregister2
add wave -noupdate -group Decode -group RF -radix decimal /tb_riscv/risc_v/dp_decode/register_file/readdata2
add wave -noupdate -group Decode -group RF -radix unsigned /tb_riscv/risc_v/dp_decode/register_file/writeregister
add wave -noupdate -group Decode -group RF -radix decimal /tb_riscv/risc_v/dp_decode/register_file/writedata
add wave -noupdate -group Decode -group RF /tb_riscv/risc_v/dp_decode/register_file/regwrite
add wave -noupdate -group Decode -group RF /tb_riscv/risc_v/dp_decode/register_file/reset
add wave -noupdate -group Decode -group RF -radix unsigned /tb_riscv/risc_v/dp_decode/register_file/registers
add wave -noupdate -group Decode -group {immediate gen} /tb_riscv/risc_v/dp_decode/imm/imm_in
add wave -noupdate -group Decode -group {immediate gen} /tb_riscv/risc_v/dp_decode/imm/imm_out
add wave -noupdate -group Decode -group {immediate gen} /tb_riscv/risc_v/dp_decode/imm/opcode
add wave -noupdate -group Decode -group {immediate gen} /tb_riscv/risc_v/dp_decode/imm/ext_i
add wave -noupdate -group Decode -group {immediate gen} /tb_riscv/risc_v/dp_decode/imm/ext_s
add wave -noupdate -group Decode -group {immediate gen} /tb_riscv/risc_v/dp_decode/imm/ext_b
add wave -noupdate -group Decode -group {immediate gen} /tb_riscv/risc_v/dp_decode/imm/ext_u
add wave -noupdate -group Decode -group {immediate gen} /tb_riscv/risc_v/dp_decode/imm/ext_j
add wave -noupdate -group Execute -group {branch_target CSA} -radix unsigned /tb_riscv/risc_v/dp_execute/branch_target/a_csa
add wave -noupdate -group Execute -group {branch_target CSA} -radix unsigned /tb_riscv/risc_v/dp_execute/branch_target/b_csa
add wave -noupdate -group Execute -group {branch_target CSA} /tb_riscv/risc_v/dp_execute/branch_target/cin_csa
add wave -noupdate -group Execute -group {branch_target CSA} /tb_riscv/risc_v/dp_execute/branch_target/cout_csa
add wave -noupdate -group Execute -group {branch_target CSA} -radix unsigned /tb_riscv/risc_v/dp_execute/branch_target/s_csa
add wave -noupdate -group Execute -group mux_alu -radix unsigned /tb_riscv/risc_v/dp_execute/mux_alu/a
add wave -noupdate -group Execute -group mux_alu -radix unsigned /tb_riscv/risc_v/dp_execute/mux_alu/b
add wave -noupdate -group Execute -group mux_alu /tb_riscv/risc_v/dp_execute/mux_alu/sel
add wave -noupdate -group Execute -group mux_alu -radix unsigned /tb_riscv/risc_v/dp_execute/mux_alu/s
add wave -noupdate -group Execute -group ALU /tb_riscv/risc_v/dp_execute/d_alu/func
add wave -noupdate -group Execute -group ALU -radix unsigned /tb_riscv/risc_v/dp_execute/d_alu/data1
add wave -noupdate -group Execute -group ALU -radix unsigned /tb_riscv/risc_v/dp_execute/d_alu/data2
add wave -noupdate -group Execute -group ALU -radix unsigned /tb_riscv/risc_v/dp_execute/d_alu/outalu
add wave -noupdate -group Execute -group ALU /tb_riscv/risc_v/dp_execute/d_alu/flag0
add wave -noupdate -group Execute -group ALU /tb_riscv/risc_v/dp_execute/d_alu/true_value
add wave -noupdate -group Execute -group ALU /tb_riscv/risc_v/dp_execute/d_alu/false_value
add wave -noupdate -group {Write Back} -radix unsigned /tb_riscv/risc_v/mux_wb/a
add wave -noupdate -group {Write Back} -radix unsigned /tb_riscv/risc_v/mux_wb/b
add wave -noupdate -group {Write Back} -radix unsigned /tb_riscv/risc_v/mux_wb/c
add wave -noupdate -group {Write Back} -radix unsigned /tb_riscv/risc_v/mux_wb/d
add wave -noupdate -group {Write Back} /tb_riscv/risc_v/mux_wb/sel
add wave -noupdate -group {Write Back} -radix unsigned /tb_riscv/risc_v/mux_wb/s
add wave -noupdate -expand -group CU /tb_riscv/risc_v/dp_cu/rst
add wave -noupdate -expand -group CU /tb_riscv/risc_v/dp_cu/alu_opcode
add wave -noupdate -expand -group CU -radix hexadecimal /tb_riscv/risc_v/dp_cu/ir_in
add wave -noupdate -expand -group CU -group {enable signals} /tb_riscv/risc_v/dp_cu/reg1_latch_en
add wave -noupdate -expand -group CU -group {enable signals} /tb_riscv/risc_v/dp_cu/reg2_latch_en
add wave -noupdate -expand -group CU -group {enable signals} /tb_riscv/risc_v/dp_cu/pc_latch_en
add wave -noupdate -expand -group CU -group {enable signals} /tb_riscv/risc_v/dp_cu/regimm_latch_en
add wave -noupdate -expand -group CU -group {enable signals} /tb_riscv/risc_v/dp_cu/regd_latch_en
add wave -noupdate -expand -group CU -group {enable signals} /tb_riscv/risc_v/dp_cu/mux_sel
add wave -noupdate -expand -group CU -group {enable signals} /tb_riscv/risc_v/dp_cu/add_latch_en
add wave -noupdate -expand -group CU -group {enable signals} /tb_riscv/risc_v/dp_cu/alu_outreg_latch_en
add wave -noupdate -expand -group CU -group {enable signals} /tb_riscv/risc_v/dp_cu/reg_latch_en
add wave -noupdate -expand -group CU -group {enable signals} /tb_riscv/risc_v/dp_cu/eq_cond
add wave -noupdate -expand -group CU -group {enable signals} /tb_riscv/risc_v/dp_cu/regd1_latch_en
add wave -noupdate -expand -group CU -group {enable signals} /tb_riscv/risc_v/dp_cu/mem_we
add wave -noupdate -expand -group CU -group {enable signals} /tb_riscv/risc_v/dp_cu/data_mem_latch_en
add wave -noupdate -expand -group CU -group {enable signals} /tb_riscv/risc_v/dp_cu/bypass_mem_latch_en
add wave -noupdate -expand -group CU -group {enable signals} /tb_riscv/risc_v/dp_cu/jump_en
add wave -noupdate -expand -group CU -group {enable signals} /tb_riscv/risc_v/dp_cu/regd2_latch_en
add wave -noupdate -expand -group CU /tb_riscv/risc_v/dp_cu/wb_mux_sel1
add wave -noupdate -expand -group CU /tb_riscv/risc_v/dp_cu/wb_mux_sel2
add wave -noupdate -expand -group CU /tb_riscv/risc_v/dp_cu/rf_we
add wave -noupdate -expand -group CU /tb_riscv/risc_v/dp_cu/ir_opcode
add wave -noupdate -expand -group CU /tb_riscv/risc_v/dp_cu/ir_func
add wave -noupdate -expand -group CU -expand -group cw /tb_riscv/risc_v/dp_cu/cw_mem
add wave -noupdate -expand -group CU -expand -group cw /tb_riscv/risc_v/dp_cu/cw2
add wave -noupdate -expand -group CU -expand -group cw /tb_riscv/risc_v/dp_cu/cw3
add wave -noupdate -expand -group CU -expand -group cw /tb_riscv/risc_v/dp_cu/cw4
add wave -noupdate -expand -group CU -expand -group cw /tb_riscv/risc_v/dp_cu/cw5
add wave -noupdate -expand -group CU /tb_riscv/risc_v/dp_cu/aluopcode_i
add wave -noupdate -expand -group CU /tb_riscv/risc_v/dp_cu/aluopcode1
add wave -noupdate -expand -group {Pipeline regs} -group reg_iftoid1 -radix unsigned /tb_riscv/risc_v/reg_iftoid1/reg_in
add wave -noupdate -expand -group {Pipeline regs} -group reg_iftoid1 /tb_riscv/risc_v/reg_iftoid1/reg_en
add wave -noupdate -expand -group {Pipeline regs} -group reg_iftoid1 /tb_riscv/risc_v/reg_iftoid1/reg_reset
add wave -noupdate -expand -group {Pipeline regs} -group reg_iftoid1 -radix unsigned /tb_riscv/risc_v/reg_iftoid1/reg_out
add wave -noupdate -expand -group {Pipeline regs} -group reg_iftoid2 -radix unsigned /tb_riscv/risc_v/reg_iftoid2/reg_in
add wave -noupdate -expand -group {Pipeline regs} -group reg_iftoid2 /tb_riscv/risc_v/reg_iftoid2/reg_en
add wave -noupdate -expand -group {Pipeline regs} -group reg_iftoid2 /tb_riscv/risc_v/reg_iftoid2/reg_reset
add wave -noupdate -expand -group {Pipeline regs} -group reg_iftoid2 -radix unsigned /tb_riscv/risc_v/reg_iftoid2/reg_out
add wave -noupdate -expand -group {Pipeline regs} -group reg_iftoid3 -radix unsigned /tb_riscv/risc_v/reg_iftoid3/reg_in
add wave -noupdate -expand -group {Pipeline regs} -group reg_iftoid3 /tb_riscv/risc_v/reg_iftoid3/reg_en
add wave -noupdate -expand -group {Pipeline regs} -group reg_iftoid3 /tb_riscv/risc_v/reg_iftoid3/reg_reset
add wave -noupdate -expand -group {Pipeline regs} -group reg_iftoid3 -radix unsigned /tb_riscv/risc_v/reg_iftoid3/reg_out
add wave -noupdate -expand -group {Pipeline regs} -group reg_idtoex1 -radix unsigned /tb_riscv/risc_v/reg_idtoex1/reg_in
add wave -noupdate -expand -group {Pipeline regs} -group reg_idtoex1 /tb_riscv/risc_v/reg_idtoex1/reg_en
add wave -noupdate -expand -group {Pipeline regs} -group reg_idtoex1 /tb_riscv/risc_v/reg_idtoex1/reg_reset
add wave -noupdate -expand -group {Pipeline regs} -group reg_idtoex1 -radix unsigned /tb_riscv/risc_v/reg_idtoex1/reg_out
add wave -noupdate -expand -group {Pipeline regs} -group reg_idtoex2 -radix unsigned /tb_riscv/risc_v/reg_idtoex2/reg_in
add wave -noupdate -expand -group {Pipeline regs} -group reg_idtoex2 /tb_riscv/risc_v/reg_idtoex2/reg_en
add wave -noupdate -expand -group {Pipeline regs} -group reg_idtoex2 /tb_riscv/risc_v/reg_idtoex2/reg_reset
add wave -noupdate -expand -group {Pipeline regs} -group reg_idtoex2 -radix unsigned /tb_riscv/risc_v/reg_idtoex2/reg_out
add wave -noupdate -expand -group {Pipeline regs} -group reg_idtoex3 -radix unsigned /tb_riscv/risc_v/reg_idtoex3/reg_in
add wave -noupdate -expand -group {Pipeline regs} -group reg_idtoex3 /tb_riscv/risc_v/reg_idtoex3/reg_en
add wave -noupdate -expand -group {Pipeline regs} -group reg_idtoex3 /tb_riscv/risc_v/reg_idtoex3/reg_reset
add wave -noupdate -expand -group {Pipeline regs} -group reg_idtoex3 -radix unsigned /tb_riscv/risc_v/reg_idtoex3/reg_out
add wave -noupdate -expand -group {Pipeline regs} -group reg_idtoex4 -radix unsigned /tb_riscv/risc_v/reg_idtoex4/reg_in
add wave -noupdate -expand -group {Pipeline regs} -group reg_idtoex4 /tb_riscv/risc_v/reg_idtoex4/reg_en
add wave -noupdate -expand -group {Pipeline regs} -group reg_idtoex4 /tb_riscv/risc_v/reg_idtoex4/reg_reset
add wave -noupdate -expand -group {Pipeline regs} -group reg_idtoex4 -radix unsigned /tb_riscv/risc_v/reg_idtoex4/reg_out
add wave -noupdate -expand -group {Pipeline regs} -group reg_idtoex6 -radix unsigned /tb_riscv/risc_v/reg_idtoex6/reg_in
add wave -noupdate -expand -group {Pipeline regs} -group reg_idtoex6 /tb_riscv/risc_v/reg_idtoex6/reg_en
add wave -noupdate -expand -group {Pipeline regs} -group reg_idtoex6 /tb_riscv/risc_v/reg_idtoex6/reg_reset
add wave -noupdate -expand -group {Pipeline regs} -group reg_idtoex6 -radix unsigned /tb_riscv/risc_v/reg_idtoex6/reg_out
add wave -noupdate -expand -group {Pipeline regs} -group reg_extomem3 -radix unsigned /tb_riscv/risc_v/reg_extomem3/reg_in
add wave -noupdate -expand -group {Pipeline regs} -group reg_extomem3 /tb_riscv/risc_v/reg_extomem3/reg_en
add wave -noupdate -expand -group {Pipeline regs} -group reg_extomem3 /tb_riscv/risc_v/reg_extomem3/reg_reset
add wave -noupdate -expand -group {Pipeline regs} -group reg_extomem3 -radix unsigned /tb_riscv/risc_v/reg_extomem3/reg_out
add wave -noupdate -expand -group {Pipeline regs} -group reg_extomem4 -radix unsigned /tb_riscv/risc_v/reg_extomem4/reg_in
add wave -noupdate -expand -group {Pipeline regs} -group reg_extomem4 /tb_riscv/risc_v/reg_extomem4/reg_en
add wave -noupdate -expand -group {Pipeline regs} -group reg_extomem4 /tb_riscv/risc_v/reg_extomem4/reg_reset
add wave -noupdate -expand -group {Pipeline regs} -group reg_extomem4 -radix unsigned /tb_riscv/risc_v/reg_extomem4/reg_out
add wave -noupdate -expand -group {Pipeline regs} -group reg_extomem5 -radix unsigned /tb_riscv/risc_v/reg_extomem5/reg_in
add wave -noupdate -expand -group {Pipeline regs} -group reg_extomem5 /tb_riscv/risc_v/reg_extomem5/reg_en
add wave -noupdate -expand -group {Pipeline regs} -group reg_extomem5 /tb_riscv/risc_v/reg_extomem5/reg_reset
add wave -noupdate -expand -group {Pipeline regs} -group reg_extomem5 -radix unsigned /tb_riscv/risc_v/reg_extomem5/reg_out
add wave -noupdate -expand -group {Pipeline regs} -group reg_extomem6 -radix unsigned /tb_riscv/risc_v/reg_extomem6/reg_in
add wave -noupdate -expand -group {Pipeline regs} -group reg_extomem6 /tb_riscv/risc_v/reg_extomem6/reg_en
add wave -noupdate -expand -group {Pipeline regs} -group reg_extomem6 /tb_riscv/risc_v/reg_extomem6/reg_reset
add wave -noupdate -expand -group {Pipeline regs} -group reg_extomem6 -radix unsigned /tb_riscv/risc_v/reg_extomem6/reg_out
add wave -noupdate -expand -group {Pipeline regs} -group reg_extomem7 -radix unsigned /tb_riscv/risc_v/reg_extomem7/reg_in
add wave -noupdate -expand -group {Pipeline regs} -group reg_extomem7 /tb_riscv/risc_v/reg_extomem7/reg_en
add wave -noupdate -expand -group {Pipeline regs} -group reg_extomem7 /tb_riscv/risc_v/reg_extomem7/reg_reset
add wave -noupdate -expand -group {Pipeline regs} -group reg_extomem7 -radix unsigned /tb_riscv/risc_v/reg_extomem7/reg_out
add wave -noupdate -expand -group {Pipeline regs} -group reg_memtowb2 -radix unsigned /tb_riscv/risc_v/reg_memtowb2/reg_in
add wave -noupdate -expand -group {Pipeline regs} -group reg_memtowb2 /tb_riscv/risc_v/reg_memtowb2/reg_en
add wave -noupdate -expand -group {Pipeline regs} -group reg_memtowb2 /tb_riscv/risc_v/reg_memtowb2/reg_reset
add wave -noupdate -expand -group {Pipeline regs} -group reg_memtowb2 -radix unsigned /tb_riscv/risc_v/reg_memtowb2/reg_out
add wave -noupdate -expand -group {Pipeline regs} -group reg_memtowb3 -radix unsigned /tb_riscv/risc_v/reg_memtowb3/reg_in
add wave -noupdate -expand -group {Pipeline regs} -group reg_memtowb3 /tb_riscv/risc_v/reg_memtowb3/reg_en
add wave -noupdate -expand -group {Pipeline regs} -group reg_memtowb3 /tb_riscv/risc_v/reg_memtowb3/reg_reset
add wave -noupdate -expand -group {Pipeline regs} -group reg_memtowb3 -radix unsigned /tb_riscv/risc_v/reg_memtowb3/reg_out
add wave -noupdate -expand -group {Pipeline regs} -group reg_memtowb4 -radix unsigned /tb_riscv/risc_v/reg_memtowb4/reg_in
add wave -noupdate -expand -group {Pipeline regs} -group reg_memtowb4 /tb_riscv/risc_v/reg_memtowb4/reg_en
add wave -noupdate -expand -group {Pipeline regs} -group reg_memtowb4 /tb_riscv/risc_v/reg_memtowb4/reg_reset
add wave -noupdate -expand -group {Pipeline regs} -group reg_memtowb4 -radix unsigned /tb_riscv/risc_v/reg_memtowb4/reg_out
add wave -noupdate -expand -group {Pipeline regs} -group reg_memtowb5 -radix unsigned /tb_riscv/risc_v/reg_memtowb5/reg_in
add wave -noupdate -expand -group {Pipeline regs} -group reg_memtowb5 /tb_riscv/risc_v/reg_memtowb5/reg_en
add wave -noupdate -expand -group {Pipeline regs} -group reg_memtowb5 /tb_riscv/risc_v/reg_memtowb5/reg_reset
add wave -noupdate -expand -group {Pipeline regs} -group reg_memtowb5 -radix unsigned /tb_riscv/risc_v/reg_memtowb5/reg_out
add wave -noupdate -expand -group {Pipeline regs} -group reg_memtowb6 -radix unsigned /tb_riscv/risc_v/reg_memtowb6/reg_in
add wave -noupdate -expand -group {Pipeline regs} -group reg_memtowb6 /tb_riscv/risc_v/reg_memtowb6/reg_en
add wave -noupdate -expand -group {Pipeline regs} -group reg_memtowb6 /tb_riscv/risc_v/reg_memtowb6/reg_reset
add wave -noupdate -expand -group {Pipeline regs} -group reg_memtowb6 -radix unsigned /tb_riscv/risc_v/reg_memtowb6/reg_out
add wave -noupdate -expand -group {Pipeline regs} -group reg_idotex5 /tb_riscv/risc_v/reg_idtoex5/reg_in
add wave -noupdate -expand -group {Pipeline regs} -group reg_idotex5 /tb_riscv/risc_v/reg_idtoex5/reg_en
add wave -noupdate -expand -group {Pipeline regs} -group reg_idotex5 /tb_riscv/risc_v/reg_idtoex5/reg_clk
add wave -noupdate -expand -group {Pipeline regs} -group reg_idotex5 /tb_riscv/risc_v/reg_idtoex5/reg_reset
add wave -noupdate -expand -group {Pipeline regs} -group reg_idotex5 /tb_riscv/risc_v/reg_idtoex5/reg_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {17011 ps} 0}
configure wave -namecolwidth 342
configure wave -valuecolwidth 236
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {136500 ps}

LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

PACKAGE RISCV_package is
  
  constant nb_i : integer := 32; --Number of bits instruction
  constant nb_d : integer := 64; --Number of bits data
  constant nb_reg : integer := 5; --Number of register
--  type TYPE_OP is (ADD, SUB, BITAND, BITXOR--,  FUNCASR);
  type aluOp is (
		NOP, ADD, EXOR, SLT, ADDI, SRAI, ANDI, BEQ, LW, SW, JAL, AUIPC, LUI 
			);
  constant NumBit : integer := 4;		
END PACKAGE;

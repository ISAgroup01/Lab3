LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

PACKAGE RISCV_package is
  
  constant nb : integer := 32; --Number of bits
  constant nb_reg : integer := 5; --Number of register
--  type TYPE_OP is (ADD, SUB, BITAND, BITXOR--,  FUNCASR);
  type aluOp is (
		NOP, ADD, EXOR, SLT, ADDI, SRAI, ANDI, BEQ, LW, SW, JAL, AUIPC, LUI, ABSV 
			);
  constant NumBit : integer := 4;		
END PACKAGE;

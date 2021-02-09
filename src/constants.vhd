package CONSTANTS is
   constant NumBit : integer := 4;		
end CONSTANTS;

--package alu_types is
--	type TYPE_OP is (ADD, SUB, BITAND, BITXOR--,  FUNCASR);
--end alu_types;

package myTypes is
	type aluOp is (
		NOP, ADD, EXOR, SLT, ADDI, SRAI, ANDI, BEQ, LW, SW, JAL, AUIPC, LUI 
			);
end myTypes;

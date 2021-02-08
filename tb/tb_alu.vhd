library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
--use IEEE.std_logic_arith.all;
use WORK.constants.all;
use WORK.alu_types.all;

entity TBALU is
end TBALU;

architecture TEST of TBALU is
    constant NBIT: integer := 16;
	signal	FUNC_CODE:	TYPE_OP:=ADD;
	signal	OP1:	STD_LOGIC_VECTOR(NBIT-1 downto 0);
	signal	OP2:	STD_LOGIC_VECTOR(NBIT-1 downto 0);
	signal	RESULT:	STD_LOGIC_VECTOR(NBIT-1 downto 0);
	
	component ALU
            generic (N : integer := numBit);
            port 	 ( FUNC: IN TYPE_OP;
                           DATA1, DATA2: IN std_logic_vector(N-1 downto 0);
                          OUTALU: OUT std_logic_vector(N-1 downto 0));
	end component;

begin 
		
	U1 : ALU
	Generic Map (NBIT)
	Port Map (FUNC_CODE, OP1, OP2,  RESULT); 


        OP1 <= "0000000000110101";
        OP2 <= "0000000000010110", "0000000000000011" after 10 ns;
	FUNC_CODE <= 	ADD after 2 ns, 
		     	SUB after 4 ns, 
			BITAND after 6 ns, 
			BITXOR after 8 ns, 
			FUNCASR after 10 ns; 
	             

end TEST;

configuration ALU_TEST of TBALU is
   for TEST
      for U1: ALU
         use configuration WORK.CFG_ALU_BEHAVIORAL; 
      end for;
	
   end for;
end ALU_TEST;


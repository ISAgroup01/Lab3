library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.RISCV_package.all;


entity TBALU is
end TBALU;

architecture TEST of TBALU is
    constant NBIT: integer := 16;
    signal  FUNC_CODE:	aluOp:=ADD;
    signal  OP1:	STD_LOGIC_VECTOR(NBIT-1 downto 0);
    signal  OP2:	STD_LOGIC_VECTOR(NBIT-1 downto 0);
    signal  RESULT:	STD_LOGIC_VECTOR(NBIT-1 downto 0);
    signal  ISEQUAL: STD_LOGIC := '0';
	
	component ALU
            generic (N : integer := numBit);
            port 	 ( FUNC: IN aluOp;
                           DATA1, DATA2: IN std_logic_vector(N-1 downto 0);
                          OUTALU: OUT std_logic_vector(N-1 downto 0);
                          FLAG0:  OUT std_logic);
	end component;

begin 
		
	U1 : ALU
	Generic Map (NBIT)
	Port Map (FUNC_CODE, OP1, OP2,  RESULT, ISEQUAL); 


        OP1 <= "0000000000110101";
        OP2 <= "0000000000010110", "0000000000000011" after 6 ns, "0000000000110101" after 16 ns;
	FUNC_CODE <= 	ADD  after 2 ns, 
		     	EXOR after 4 ns, 
		        SLT  after 6 ns, 
			SRAI after 8 ns, 
			ANDI after 10 ns,
                        LUI  after 12 ns,
                        BEQ  after 14 ns; 
	             

end TEST;

configuration ALU_TEST of TBALU is
   for TEST
      for U1: ALU
         use configuration WORK.CFG_ALU_BEHAVIORAL; 
      end for;
	
   end for;
end ALU_TEST;


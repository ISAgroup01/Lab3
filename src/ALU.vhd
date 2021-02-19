library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.RISCV_package.all;

entity ALU is
  generic (N : integer := 32);
  port 	 ( FUNC: IN aluOp;
           DATA1, DATA2: IN std_logic_vector(N-1 downto 0);
           OUTALU: OUT std_logic_vector(N-1 downto 0);
           FLAG0:  out std_logic);
end ALU;

architecture BEHAVIOR of ALU is

  signal true_value : std_logic_vector(N - 1 downto 0) := (others => '1');
  signal false_value : std_logic_vector(N - 1 downto 0) := (others => '0');
begin

P_ALU: process (FUNC, DATA1, DATA2)
 

  begin
    case FUNC is
	      when ADD      => OUTALU <= std_logic_vector(signed(DATA1) + signed(DATA2)) ; 
        when EXOR     => OUTALU <= DATA1 xor DATA2;
        when SLT      => if to_integer(signed(DATA1) - signed(DATA2)) < 0 then
                           OUTALU <= true_value;
                         else
                           OUTALU <= false_value;
                         end if;
        when ADDI     => OUTALU <= std_logic_vector(signed(DATA1) + signed(DATA2));
        when SRAI     => OUTALU <= std_logic_vector(shift_right(signed(DATA1), to_integer(signed(DATA2)))); -- arithmetic shift right
        when ANDI     => OUTALU <= DATA1 and DATA2;
        when LUI      => OUTALU <= DATA2;
        when BEQ      => if DATA1 = DATA2  then
                           FLAG0 <= '1';
                         else
                           FLAG0 <= '0';
                         end if;
                         
       when LW => OUTALU <= std_logic_vector(signed(DATA1) + signed(DATA2));
       when SW => OUTALU <= std_logic_vector(signed(DATA1) + signed(DATA2));          
	when others => null;
    end case; 
  end process P_ALU;

end BEHAVIOR;

configuration CFG_ALU_BEHAVIORAL of ALU is
  for BEHAVIOR
  end for;
end CFG_ALU_BEHAVIORAL;

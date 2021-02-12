--Immediate generation
library IEEE;
use IEEE.std_logic_1164.all; 
use ieee.numeric_std.all;
use WORK.RISCV_package.all;

entity Imm_gen is
	Port (IMM_IN  : IN  std_logic_vector(32 - 1 downto 0);
         IMM_OUT : OUT std_logic_vector(32 - 1 downto 0));
end Imm_gen;

architecture Behavioral of Imm_gen is
signal opcode : std_logic_vector(6 downto 0);
--signal funct : std_logic_vector(2 downto 0);
signal ext_i, ext_s : std_logic_vector(19 downto 0);
signal ext_b : std_logic_vector(18 downto 0);
signal ext_u : std_logic_vector(11 downto 0);
signal ext_j : std_logic_vector(10 downto 0);
begin
	opcode <= IMM_IN(6 downto 0);  --retireve opcode from IR 
	--funct  <= IMM_IN(14 downto 0); --retireve funct from IR
	
  Sign : process(IMM_IN)
  begin
    if(IMM_IN(31)='0') then
      ext_i <= (others => '0');
		ext_s <= (others => '0');
		ext_b <= (others => '0');
		ext_j <= (others => '0');
    else
      ext_i <= (others => '1');
		ext_s <= (others => '1');
		ext_b <= (others => '1');
		ext_j <= (others => '1');
    end if;
  end process Sign;
  -- purpose: Generation of Immediate value
  -- type   : combinational
  -- inputs : opcode
  -- outputs: Imm_out
   Immediate_generation : process (opcode)
   begin
	case opcode is
		-- R-type
		when "0110011" =>
			IMM_OUT <= (others => '0');
		
		-- I-type
		when "0010011" => --I
			--ext_i <= (others => IMM_IN(31));
			IMM_OUT <= ext_i & IMM_IN(31 downto 20);
		when "0000011" => --LW
			--ext_i <= (others => IMM_IN(31));
			IMM_OUT <= ext_i & IMM_IN(31 downto 20);
		
		-- S-type
		when "0100011" => --SW
			--ext_s <= (others => IMM_IN(31));
			IMM_OUT <= ext_s & IMM_IN(31 downto 25) & IMM_IN(11 downto 7);
		
		-- B-type
		when "1100011" => --BEQ
			--ext_b <= (others => IMM_IN(31));
			IMM_OUT <= ext_b & IMM_IN(31) & IMM_IN(7) & IMM_IN(30 downto 25) & IMM_IN(11 downto 8) & '0';
		
		-- J-type
		when "1101111" => --JAL
			--ext_j <= (others => IMM_IN(31));
			IMM_OUT <= ext_j & IMM_IN(31) & IMM_IN(19 downto 12) & IMM_IN(20) & IMM_IN(30 downto 21) & '0';
		
		-- U-type
      when "0010111" => --AUIPC
			ext_u <= (others => '0');
			IMM_OUT <= IMM_IN(31 downto 12) & ext_u;
      when "0110111" => --LUI
			ext_u <= (others => '0');
			IMM_OUT <= IMM_IN(31 downto 12) & ext_u;
		
		when others =>
			IMM_OUT <= (others => '0');
	 end case;
	end process Immediate_generation;

end Behavioral;

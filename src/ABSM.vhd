library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;
--use IEEE.numeric_std.all;
use WORK.RISCV_package.all;

Entity ABSM is
port(
		ABS_in : in std_logic_vector(nb-1 downto 0);
		ABS_ctrl : in std_logic;
		ABS_out : out std_logic_vector(nb-1 downto 0)
		);
end ABSM;

Architecture struct of ABSM is

begin

	Conv : process(ABS_in)

    variable sig_ABS_conv: std_logic_vector(nb-1 downto 0);
	
		begin
		
		if (ABS_ctrl = '1') then
		
		  if (ABS_in(nb-1) = '1') then
			
			 sig_ABS_conv := unsigned(not(ABS_in)) + 1;
			
			 ABS_out <= std_logic_vector(sig_ABS_conv);
			 
			 else
			   
			  ABS_out <= ABS_in;
			 
		
		  end if; --ABS_in
		 
		 end if; --ABS_ctrl

	end process;

end struct;
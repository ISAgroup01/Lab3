library IEEE;
use IEEE.std_logic_1164.all; 
use ieee.numeric_std.all;
use WORK.RISCV_package.all;

entity REG is
	Port (REG_IN    :	In	signed(nb_i-1 downto 0);
		   REG_EN    :	In	std_logic;
	      REG_CLK   :	In	std_logic;
         REG_RESET :	In	std_logic;
         REG_OUT   : Out signed(nb_i-1 downto 0));
end REG;

architecture REGSYNCH of REG is -- REGISTER flip flop D with syncronous reset
begin
	PSYNCH: process(REG_CLK,REG_RESET)
	begin
	  if REG_CLK'event and REG_CLK='1' then -- positive edge triggered:
	    if REG_RESET='0' then -- active low reset 
	      REG_OUT <= (others => '0'); 
	    else
		   if REG_EN = '1' then
	        REG_OUT <= REG_IN; -- input is written on output
			end if;
	    end if;
	  end if;
	end process;
end REGSYNCH;

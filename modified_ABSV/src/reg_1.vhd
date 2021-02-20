--Reg std_logic
library IEEE;
use IEEE.std_logic_1164.all; 
use ieee.numeric_std.all;
use WORK.RISCV_package.all;

entity REG_1 is
	Port (REG_IN    :	In	std_logic;
		   REG_EN    :	In	std_logic;
	      REG_CLK   :	In	std_logic;
         REG_RESET :	In	std_logic;
         REG_OUT   : Out std_logic);
end REG_1;

architecture REGSYNCH of REG_1 is -- REGISTER flip flop D with syncronous reset
begin
	PSYNCH: process(REG_CLK,REG_RESET)
	begin
	  if REG_CLK'event and REG_CLK='1' then -- positive edge triggered:
	    if REG_RESET='0' then -- active low reset 
	      REG_OUT <= '0'; 
	    else
		   if REG_EN = '1' then
	        REG_OUT <= REG_IN; -- input is written on output
			end if;
	    end if;
	  end if;
	end process;
end REGSYNCH;

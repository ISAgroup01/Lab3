--mux3to1
library IEEE;
use IEEE.std_logic_1164.all; 
use ieee.numeric_std.all;

entity mux4to1 is
	Generic (N : integer := 32);
	Port(A   :  IN   std_logic_vector(N-1 downto 0);
	     B   :  IN   std_logic_vector(N-1 downto 0);
		  C   :  IN   std_logic_vector(N-1 downto 0);
		  D   :  IN   std_logic_vector(N-1 downto 0);
		  sel :  IN   std_logic_vector(1 downto 0);
		  S   :  OUT  std_logic_vector(N-1 downto 0));
end mux4to1;

architecture behavioral of mux4to1 is
begin
	with sel select
		S <= A when "00",
			  B when "01",
			  C when "10",
			  D when "11",
			  A when others;
end behavioral;
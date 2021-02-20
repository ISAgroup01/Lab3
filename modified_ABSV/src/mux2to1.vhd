library IEEE;
use IEEE.std_logic_1164.all; 
use ieee.numeric_std.all;
--use WORK.RISCV_package.all;

entity mux2to1 is
	Generic (N : integer := 32);
	Port(A   :  IN   std_logic_vector(N-1 downto 0);
	     B   :  IN   std_logic_vector(N-1 downto 0);
		  sel :  IN   std_logic;
		  S   :  OUT  std_logic_vector(N-1 downto 0));
end mux2to1;

architecture behavioral of mux2to1 is
begin
	with sel select
		S <= A when '0',
			  B when '1',
			  A when others;
end behavioral;

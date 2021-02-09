-- 4bits RCA
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.RISCV_package.all;

entity RCA is
	Port(A_rca    : IN  std_logic_vector(16 -1 downto 0);
		  B_rca    : IN  std_logic_vector(16 -1 downto 0);
		  Cin_rca  : IN  std_logic;
		  Cout_rca : OUT std_logic;
		  S_rca    : OUT std_logic_vector(16 -1 downto 0));
end entity;

architecture STRUCT of RCA is
component FA
	Port(A    : IN  std_logic;
		  B    : IN  std_logic;
		  Cin  : IN  std_logic;
		  Cout : OUT std_logic;
		  S    : OUT std_logic);
end component;
signal c : std_logic_vector(16-1 downto 0) := (others => '0');
begin
	FA_0 : FA port map(A => A_rca(0), B => B_rca(0), Cin => Cin_rca, Cout => c(0), S => S_rca(0));
--	FA_1 : FA port map(A => A_rca(1), B => B_rca(1), Cin => c(0), Cout => c(1), S => S_rca(1));
--	FA_2 : FA port map(A => A_rca(2), B => B_rca(2), Cin => c(1), Cout => c(2), S => S_rca(2));
--	FA_3 : FA port map(A => A_rca(3), B => B_rca(3), Cin => c(2), Cout => c(3), S => S_rca(3));
	
	FA_i : for i in 1 to 15 generate
		FA_i : FA port map(A => A_rca(i), B => B_rca(i), Cin => c(i-1), Cout => c(i), S => S_rca(i));
	end generate;
	Cout_rca <= c(15);
end architecture;
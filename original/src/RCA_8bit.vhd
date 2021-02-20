-- 4bits RCA
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.RISCV_package.all;

entity RCA is
	Port(A_rca    : IN  std_logic_vector(8 -1 downto 0);
		  B_rca    : IN  std_logic_vector(8 -1 downto 0);
		  Cin_rca  : IN  std_logic;
		  Cout_rca : OUT std_logic;
		  S_rca    : OUT std_logic_vector(8 -1 downto 0));
end entity;

architecture STRUCT of RCA is
component FA
	Port(A    : IN  std_logic;
		  B    : IN  std_logic;
		  Cin  : IN  std_logic;
		  Cout : OUT std_logic;
		  S    : OUT std_logic);
end component;
signal c : std_logic_vector(8-1 downto 0) := (others => '0');
begin
	FA_0 : FA port map(A => A_rca(0), B => B_rca(0), Cin => Cin_rca, Cout => c(0), S => S_rca(0));
	FA_i : for i in 1 to 7 generate
		FA_i : FA port map(A => A_rca(i), B => B_rca(i), Cin => c(i-1), Cout => c(i), S => S_rca(i));
	end generate;
	Cout_rca <= c(7);
end architecture;
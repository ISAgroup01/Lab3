--FA
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.RISCV_package.all;

entity FA is
	Port(A    : IN  std_logic;
		  B    : IN  std_logic;
		  Cin  : IN  std_logic;
		  Cout : OUT std_logic;
		  S    : OUT std_logic);
end entity;

architecture STRUCT of FA is
begin
	S    <= A xor B xor Cin;
	Cout <= (A and B) or (A and Cin) or (B and Cin);
end architecture;
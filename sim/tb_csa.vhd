library IEEE;

use IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;

entity TBCSA is
end TBCSA;

architecture TEST of TBCSA is
component CSA
	Port(A_csa    : IN  std_logic_vector(64 - 1 downto 0);
		  B_csa    : IN  std_logic_vector(64 - 1 downto 0);
		  Cin_csa  : IN  std_logic;
		  Cout_csa : OUT std_logic;
		  S_csa    : OUT std_logic_vector(64 - 1 downto 0));
end component;
signal OP1, OP2, res_S : std_logic_vector(63 downto 0);
signal res_Cout : std_logic;
begin 
	U1 : CSA
	Port Map (A_csa => OP1, B_csa => OP2, Cin_csa => '0', Cout_csa => res_Cout, S_csa => res_S); 
   OP1 <= std_logic_vector(to_unsigned(1111, 64));
   OP2 <= std_logic_vector(to_unsigned(4005, 64));
	             
end TEST;
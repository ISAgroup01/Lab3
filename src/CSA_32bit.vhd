--CSA 64bits 4 blocks of 16 bits
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.RISCV_package.all;

entity CSA is
	Port( A_csa    : IN  std_logic_vector(32 - 1 downto 0);
		   B_csa    : IN  std_logic_vector(32 - 1 downto 0);
		   Cin_csa  : IN  std_logic;
		   Cout_csa : OUT std_logic;
		   S_csa    : OUT std_logic_vector(32 - 1 downto 0));
end entity;

architecture STRUCT of CSA is
component RCA
	Port(A_rca    : IN  std_logic_vector(8 -1 downto 0);
		  B_rca    : IN  std_logic_vector(8 -1 downto 0);
		  Cin_rca  : IN  std_logic;
		  Cout_rca : OUT std_logic;
		  S_rca    : OUT std_logic_vector(8 -1 downto 0));
end component;
component mux2to1
	Generic (N : integer := 32);
	Port(A   :  IN   std_logic_vector(N-1 downto 0);
	     B   :  IN   std_logic_vector(N-1 downto 0);
		  sel :  IN   std_logic;
		  S   :  OUT  std_logic_vector(N-1 downto 0));
end component;

type type_sum is array (2 downto 0) of std_logic_vector(8-1 downto 0);
signal S_temp0, S_temp1 : type_sum;
signal C_temp0, C_temp1 : std_logic_vector(2 downto 0);
signal C_temp : std_logic;
signal sig1, sig2, sig3 : std_logic_vector(8 downto 0);
signal sig0 : std_logic_vector(8 - 1 downto 0);
signal A0, B0, A1, B1, A2, B2 : std_logic_vector(8 downto 0);
signal A3, B3, sig4 : std_logic_vector(16 downto 0);
begin

	RCA0 : RCA port map(A_rca => A_csa(7 downto 0), B_rca => B_csa(7 downto 0), Cin_rca => Cin_csa, Cout_rca => C_temp, S_rca => sig0);
	RCA_i : for i in 1 to 3 generate
		RCAi_0  : RCA port map(A_rca=> A_csa((8*i)+7 downto 8*i), B_rca=> B_csa((8*i)+7 downto 8*i), Cin_rca=> '0', Cout_rca=> C_temp0(i-1), S_rca=> S_temp0(i-1));
		RCAi_1  : RCA port map(A_rca=> A_csa((8*i)+7 downto 8*i), B_rca=> B_csa((8*i)+7 downto 8*i), Cin_rca=> '1', Cout_rca=> C_temp1(i-1), S_rca=> S_temp1(i-1));
	end generate;
	A0 <= C_temp0(0) & S_temp0(0);
	B0 <= C_temp1(0) & S_temp1(0);
	mux0 : mux2to1 Generic Map(N => 9)
		            Port Map(A => A0, B => B0, sel => C_temp, S => sig1);
	A1 <= C_temp0(2) & S_temp0(2);
	B1 <= C_temp1(2) & S_temp1(2);
	mux1 : mux2to1 Generic Map(N => 9)
		            Port Map(A => A1, B => B1, sel => C_temp0(1), S => sig2);
	A2 <= C_temp0(2) & S_temp0(2);
	B2 <= C_temp1(2) & S_temp1(2);
	mux2 : mux2to1 Generic Map(N => 9)
		            Port Map(A => A2, B => B2, sel => C_temp1(1), S => sig3);
	A3 <= sig2 & S_temp0(1);
	B3 <= sig3 & S_temp1(1);
	mux3 : mux2to1 Generic Map(N => 17)
		            Port Map(A => A3, B => B3, sel => sig1(8), S => sig4);
	
	S_csa <= sig4(16-1 downto 0) & sig1(8-1 downto 0) & sig0;
	Cout_csa <= sig4(16);
end architecture;

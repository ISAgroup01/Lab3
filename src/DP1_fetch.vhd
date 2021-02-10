library IEEE;
use IEEE.std_logic_1164.all; 
use ieee.numeric_std.all;
use WORK.RISCV_package.all;

entity FETCH is
	Port(
		  PC_b : IN std_logic_vector(nb-1downto 0);
		  PC_sel : IN std_logic_vector;
		  fetch_CLK : IN std_logic;
		  fetch_RST : IN std_logic;
		  PC_out : OUT std_logic_vector(nb-1downto 0));
end FETCH;

architecture STUCT of FETCH is
component mux2to1
	Generic (N : integer := 32);
	Port(A   :  IN   std_logic_vector(N-1 downto 0);
	     B   :  IN   std_logic_vector(N-1 downto 0);
		  sel :  IN   std_logic;
		  S   :  OUT  std_logic_vector(N-1 downto 0));
end component;
component REG
	Generic (N : integer := 32);
	Port (REG_IN    :	In	signed(N-1 downto 0);
		   REG_EN    :	In	std_logic;
	      REG_CLK   :	In	std_logic;
         REG_RESET :	In	std_logic;
         REG_OUT   : Out signed(N-1 downto 0));
end component;
component CSA
	Port( A_csa    : IN  std_logic_vector(32 - 1 downto 0);
		   B_csa    : IN  std_logic_vector(32 - 1 downto 0);
		   Cin_csa  : IN  std_logic;
		   Cout_csa : OUT std_logic;
		   S_csa    : OUT std_logic_vector(32 - 1 downto 0));
end component;
signal PC_new, PC_in, PC_out_tmp : std_logic_vector(nb-1 downto 0);
signal Co_csa : std_logic;
begin
	mux_IF : mux2to1 Generic Map(N => nb)
					     Port Map (A => PC_new, B => PC_b, sel => PC_sel, S => PC_in);
	--PC
	REG_PC : REG Generic Map(N => nb)
					 Port Map(REG_IN => PC_in, REG_EN => '1', REG_CLK => fetch_CLK,
								 REG_RESET => fetch_RST, REG_OUT => PC_out_tmp);
	--Update PC (+4)
	PC_update : CSA 
	Port Map (A_csa=> PC_out_tmp, B_csa=> std_logic_vector(to_unsigned(4, 32)), Cin_csa=>'0', Cout_csa=>Co_csa, S_csa=>PC_new); 
	
	PC_out <= PC_out_tmp;

end STRUCT;

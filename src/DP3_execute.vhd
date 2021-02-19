library IEEE;
use IEEE.std_logic_1164.all; 
use ieee.numeric_std.all;
use WORK.RISCV_package.all;

entity EXECUTE is
	Port(PC : IN std_logic_vector(nb-1 downto 0);
	     DATA1_ex  : IN std_logic_vector(nb-1 downto 0);
	     DATA2_ex : IN std_logic_vector(nb-1 downto 0);
		  IMM : IN std_logic_vector(nb-1 downto 0);
		  ALUSrc : IN std_logic;
		  ALUOpcode : IN aluOp;
		  PC_out : OUT std_logic_vector(nb-1 downto 0);
		  Zero : OUT std_logic;
		  ALU_res_ex : OUT std_logic_vector(nb-1 downto 0));
end EXECUTE;

architecture STRUCT of EXECUTE is
component ALU
  generic (N : integer := 32);
  port 	 ( FUNC: IN aluOp;
           DATA1, DATA2: IN std_logic_vector(N-1 downto 0);
           OUTALU: OUT std_logic_vector(N-1 downto 0);
           FLAG0:  out std_logic);
end component;
component CSA
	Port( A_csa    : IN  std_logic_vector(32 - 1 downto 0);
	      B_csa    : IN  std_logic_vector(32 - 1 downto 0);
	      Cin_csa  : IN  std_logic;
	      Cout_csa : OUT std_logic;
	      S_csa    : OUT std_logic_vector(32 - 1 downto 0));
end component;
component mux2to1
	Generic (N : integer := 32);
	Port(A   :  IN   std_logic_vector(N-1 downto 0);
	     B   :  IN   std_logic_vector(N-1 downto 0);
	     sel :  IN   std_logic;
	     S   :  OUT  std_logic_vector(N-1 downto 0));
end component;

signal IMMx2, ALU_in2 : std_logic_vector(nb-1 downto 0);
signal Co_csa : std_logic;
begin
	--Shift left 1
	IMMx2 <= IMM(nb - 2 downto 0) & '0';
	--Branch Target
	Branch_Target : CSA 
	Port Map (A_csa=> IMMx2, B_csa=> PC, Cin_csa=> '0', Cout_csa=> Co_csa, S_csa=> PC_out); 
	
	mux_ALU : mux2to1 Generic Map(N => nb)
					     Port Map (A => DATA2_ex, B => IMM, sel => ALUSrc, S => ALU_in2);
	d_ALU : ALU Generic Map (N => nb)
					Port Map(
						FUNC => ALUOpcode,
						DATA1 => DATA1_ex,
						DATA2 => ALU_in2,
						OUTALU => ALU_res_ex,
						FLAG0 => Zero);

end STRUCT;

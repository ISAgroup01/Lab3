library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;
use WORK.RISCV_package.all;

entity TB_ABSM is
end TB_ABSM;

architecture TEST of TB_ABSM is
   
------------------------------------------------------------------------------------------
  -- COMPONENTS
-----------------------------------------------------------------------------------------
	
component ABSM is
port(
		ABS_in : in std_logic_vector(nb-1 downto 0);
		ABS_ctrl : in std_logic;
		ABS_out : out std_logic_vector(nb-1 downto 0)
		);
end component;

---------------------------------------------------------------------------------------------
--SIGNALS
---------------------------------------------------------------------------------------------

signal sig_ABS_in : std_logic_vector(nb-1 downto 0) := (others => '0');
signal sig_ABS_ctrl : std_logic := '1';
signal sig_ABS_out : std_logic_vector(nb-1 downto 0);

begin 
		
	UUT : ABSM
	
  port map(
		ABS_in => sig_ABS_in,
		ABS_ctrl => sig_ABS_ctrl,
		ABS_out => sig_ABS_out
		);
	
	tb : PROCESS
	begin
	  
sig_ABS_in <= std_logic_vector(to_signed(1, 32));
wait for 20 ns;

sig_ABS_in <= std_logic_vector(to_signed(120, 32));
wait for 20 ns;

sig_ABS_in <= std_logic_vector(to_signed(-1, 32));
wait for 20 ns;

sig_ABS_in <= std_logic_vector(to_signed(-120, 32));
wait for 20 ns;

sig_ABS_in <= std_logic_vector(to_signed(1994, 32));
wait for 20 ns;

sig_ABS_in <= std_logic_vector(to_signed(-15, 32));
wait for 20 ns;

sig_ABS_in <= std_logic_vector(to_signed(-1194, 32));
wait for 20 ns;

sig_ABS_in <= std_logic_vector(to_signed(1000, 32));

						  
END PROCESS tb;
	             

end TEST;





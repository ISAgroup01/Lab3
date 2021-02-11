library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.all;
use WORK.RISCV_package.all;

entity TB_RF is
end TB_RF;

architecture TEST of TB_RF is
   
------------------------------------------------------------------------------------------
  -- COMPONENTS
-----------------------------------------------------------------------------------------
	
COMPONENT RegFile_behav IS
   PORT(
      ReadRegister1    : IN  std_logic_vector(4 downto 0);
      ReadRegister2    : IN  std_logic_vector(4 downto 0);
      WriteRegister    : IN  std_logic_vector(4 downto 0);
      WriteData        : IN  std_logic_vector(31 downto 0);
      ReadData1        : OUT std_logic_vector(31 downto 0);
      ReadData2        : OUT std_logic_vector(31 downto 0);
      
      RegWrite         : IN  std_logic; --Enable signal
      Reset            : IN std_logic; --active high (1) reset
      Clock            : IN std_logic
   );
END component;

---------------------------------------------------------------------------------------------
--SIGNALS
---------------------------------------------------------------------------------------------

signal sig_ReadRegister1 :  std_logic_vector(4 downto 0):= (others => '0');
signal sig_ReadRegister2 :  std_logic_vector(4 downto 0):= (others => '0');
signal sig_WriteRegister :  std_logic_vector(4 downto 0):= (others => '0');

signal sig_WriteData 	   :  std_logic_vector(31 downto 0):= (others => '0');
signal sig_ReadData1     :  std_logic_vector(31 downto 0):= (others => '0');
signal sig_ReadData2     :  std_logic_vector(31 downto 0):= (others => '0');

signal sig_RegWrite 		 :  std_logic := '1';
signal sig_Reset   		  :  std_logic := '0';
signal sig_Clock    		 :  std_logic := '0';

begin 
		
	UUT : RegFile_behav
	
Port Map (ReadRegister1 => sig_ReadRegister1,
			 ReadRegister2 => sig_ReadRegister2,
			 WriteRegister => sig_WriteRegister,
			 WriteData => sig_WriteData,			
			 ReadData1 => sig_ReadData1,
			 ReadData2 => sig_ReadData2,
      
			 RegWrite => sig_RegWrite,
			 Reset => sig_Reset,
			 Clock => sig_Clock
				); 

clock : PROCESS
	begin
	 sig_Clock <='1';
	 wait for 5 ns;
	 sig_Clock <='0';
	 wait for 5 ns;
END PROCESS clock;
	
	tb : PROCESS
	begin
-------------------------------------------------------------------------------------------------
--write some values into registers

sig_writeRegister <= std_logic_vector(to_unsigned(0, 5));
sig_writeData <= std_logic_vector(to_unsigned(27, 32));
wait for 10ns;

sig_writeRegister <= std_logic_vector(to_unsigned(1, 5));
sig_writeData <= std_logic_vector(to_unsigned(52, 32));
wait for 10ns;

sig_writeRegister <= std_logic_vector(to_unsigned(2, 5));
sig_writeData <= std_logic_vector(to_unsigned(120, 32));
wait for 10ns;

sig_writeRegister <= std_logic_vector(to_unsigned(1, 5));
sig_writeData <= std_logic_vector(to_unsigned(44, 32));
wait for 10ns;

-------------------------------------------------------------------------------------------------
--read some registers (output 1)

sig_readRegister1 <= std_logic_vector(to_unsigned(0, 5));
wait for 10ns;

sig_readRegister1 <= std_logic_vector(to_unsigned(1, 5));
wait for 10ns;

sig_readRegister1 <= std_logic_vector(to_unsigned(2, 5));
wait for 10ns;

-------------------------------------------------------------------------------------------------
--read some registers (output 2)

sig_readRegister2 <= std_logic_vector(to_unsigned(0, 5));
wait for 10ns;

sig_readRegister2 <= std_logic_vector(to_unsigned(2, 5));
wait for 10ns;

sig_readRegister2 <= std_logic_vector(to_unsigned(1, 5));
wait for 10ns;

-------------------------------------------------------------------------------------------------
--write & read at the same time

sig_writeRegister <= std_logic_vector(to_unsigned(2, 5));
sig_writeData <= std_logic_vector(to_unsigned(1994, 32));

sig_readRegister1 <= std_logic_vector(to_unsigned(2, 5));
wait for 10ns;

sig_readRegister2 <= std_logic_vector(to_unsigned(2, 5));
wait for 10ns;

sig_readRegister1 <= std_logic_vector(to_unsigned(2, 5));
wait for 10ns;

sig_readRegister2 <= std_logic_vector(to_unsigned(2, 5));
wait for 10ns;

-------------------------------------------------------------------------------------------------
--Turn off, Reset and then read

sig_RegWrite <= '0';
wait for 10 ns;

sig_Reset <= '1';
wait for 10 ns;

sig_readRegister1 <= std_logic_vector(to_unsigned(2, 5));
wait for 10 ns;

sig_readRegister1 <= std_logic_vector(to_unsigned(1, 5));
wait for 10ns;

sig_Reset<='0';
wait for 10ns;
------------------------------------------------------------------------------------------------

						  
END PROCESS tb;
	             

end TEST;





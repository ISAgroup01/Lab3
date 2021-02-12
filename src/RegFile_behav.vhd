library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

ENTITY RegFile_behav IS
   PORT(
      ReadRegister1    : IN  std_logic_vector(4 downto 0);
      ReadRegister2    : IN  std_logic_vector(4 downto 0);
      WriteRegister    : IN  std_logic_vector(4 downto 0);
      WriteData        : IN  std_logic_vector(31 downto 0);
      ReadData1        : OUT std_logic_vector(31 downto 0);
      ReadData2        : OUT std_logic_vector(31 downto 0);
      
      RegWrite         : IN  std_logic; --Enable signal
      Reset            : IN std_logic; --active low (0) reset
      Clock            : IN std_logic
   );
END RegFile_behav;

architecture behavioral of RegFile_behav is

        -- suggested structures
  subtype REG_ADDR is natural range 0 to ((2**5)-1); -- using natural type
	type REG_ARRAY is array(REG_ADDR) of std_logic_vector(31 downto 0);
	signal REGISTERS : REG_ARRAY;

begin

  RF: process(Clock)

    begin

      if Clock' event and Clock='1' then

         if Reset = '1' then
           
          if RegWrite = '1' then

           REGISTERS(to_integer(unsigned(WriteRegister))) <= WriteData;
          
           ReadData1 <= REGISTERS(to_integer(unsigned(ReadRegister1)));
           ReadData2 <= REGISTERS(to_integer(unsigned(ReadRegister2)));
           
          else
            
           ReadData1 <= REGISTERS(to_integer(unsigned(ReadRegister1)));
           ReadData2 <= REGISTERS(to_integer(unsigned(ReadRegister2)));
           
           end if; --RegWrite

          else --Reset = '0'

            REGISTERS <= (others=> (others => '0'));

          end if; --Reset
        
      end if; --CLOCK
  end process;


end behavioral;

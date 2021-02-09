library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity register_file is
 port (
	 ReadRegister1: IN std_logic_vector(4 downto 0);
	 ReadRegister2: IN std_logic_vector(4 downto 0);
   WriteRegister: IN std_logic_vector(4 downto 0);
	 RegWrite: 	    IN std_logic_vector(31 downto 0);
   ReadData1: 		OUT std_logic_vector(31 downto 0);
	 ReadData2: 		OUT std_logic_vector(31 downto 0);
   Clock: 		    IN std_logic
   );
end register_file;

architecture behavioral of register_file is

        -- suggested structures
  subtype REG_ADDR is natural range 0 to ((2**5)-1); -- using natural type
	type REG_ARRAY is array(REG_ADDR) of std_logic_vector(31 downto 0);
	signal REGISTERS : REG_ARRAY := (others=> (others => '0'));

begin

  RF: process(CLK)

    begin

      if CLK' event and CLK='1' then

          ReadData1 <= REGISTERS(to_integer(unsigned(ReadRegister1)));

          ReadData2 <= REGISTERS(to_integer(unsigned(ReadRegister2)));

          REGISTERS(to_integer(unsigned(WriteRegister))) <= RegWrite;

      end if; --CK'
  end process;


end behavioral;

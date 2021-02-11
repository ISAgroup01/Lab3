LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY WriteRegister_logic IS
   PORT(
        WriteRegister   : IN std_logic_vector(4 downto 0);
        WriteData       : IN std_logic_vector(31 downto 0);

        Enable          : in std_logic;

        ToReg0          : OUT std_logic_vector(31 downto 0);
        ToReg1          : OUT std_logic_vector(31 downto 0);
        ToReg2          : OUT std_logic_vector(31 downto 0);
        ToReg3          : OUT std_logic_vector(31 downto 0);
        ToReg4          : OUT std_logic_vector(31 downto 0);
        ToReg5          : OUT std_logic_vector(31 downto 0);
        ToReg6          : OUT std_logic_vector(31 downto 0);
        ToReg7          : OUT std_logic_vector(31 downto 0);
        ToReg8          : OUT std_logic_vector(31 downto 0);
        ToReg9          : OUT std_logic_vector(31 downto 0);

        ToReg10          : OUT std_logic_vector(31 downto 0);
        ToReg11          : OUT std_logic_vector(31 downto 0);
        ToReg12          : OUT std_logic_vector(31 downto 0);
        ToReg13          : OUT std_logic_vector(31 downto 0);
        ToReg14          : OUT std_logic_vector(31 downto 0);
        ToReg15          : OUT std_logic_vector(31 downto 0);
        ToReg16          : OUT std_logic_vector(31 downto 0);
        ToReg17          : OUT std_logic_vector(31 downto 0);
        ToReg18          : OUT std_logic_vector(31 downto 0);
        ToReg19          : OUT std_logic_vector(31 downto 0);

        ToReg20          : OUT std_logic_vector(31 downto 0);
        ToReg21          : OUT std_logic_vector(31 downto 0);
        ToReg22          : OUT std_logic_vector(31 downto 0);
        ToReg23          : OUT std_logic_vector(31 downto 0);
        ToReg24          : OUT std_logic_vector(31 downto 0);
        ToReg25          : OUT std_logic_vector(31 downto 0);
        ToReg26          : OUT std_logic_vector(31 downto 0);
        ToReg27          : OUT std_logic_vector(31 downto 0);
        ToReg28          : OUT std_logic_vector(31 downto 0);
        ToReg29          : OUT std_logic_vector(31 downto 0);

        ToReg30          : OUT std_logic_vector(31 downto 0);
        ToReg31          : OUT std_logic_vector(31 downto 0)
   );
END WriteRegister_logic;

architecture BEHAVIOR of WriteRegister_logic is

begin

  process(WriteData, WriteRegister)
  begin

    if (Enable = '1') then
    
    case WriteRegister is
    when std_logic_vector(to_unsigned(0, 5)) => ToReg0 <= WriteData;
    when std_logic_vector(to_unsigned(1, 5)) => ToReg1 <= WriteData;
    when std_logic_vector(to_unsigned(2, 5)) => ToReg2 <= WriteData;
    when std_logic_vector(to_unsigned(3, 5)) => ToReg3 <= WriteData;
    when std_logic_vector(to_unsigned(4, 5)) => ToReg4 <= WriteData;
    when std_logic_vector(to_unsigned(5, 5)) => ToReg5 <= WriteData;
    when std_logic_vector(to_unsigned(6, 5)) => ToReg6 <= WriteData;
    when std_logic_vector(to_unsigned(7, 5)) => ToReg7 <= WriteData;
    when std_logic_vector(to_unsigned(8, 5)) => ToReg8 <= WriteData;
    when std_logic_vector(to_unsigned(9, 5)) => ToReg9 <= WriteData;

    when std_logic_vector(to_unsigned(10, 5)) => ToReg10 <= WriteData;
    when std_logic_vector(to_unsigned(11, 5)) => ToReg11 <= WriteData;
    when std_logic_vector(to_unsigned(12, 5)) => ToReg12 <= WriteData;
    when std_logic_vector(to_unsigned(13, 5)) => ToReg13 <= WriteData;
    when std_logic_vector(to_unsigned(14, 5)) => ToReg14 <= WriteData;
    when std_logic_vector(to_unsigned(15, 5)) => ToReg15 <= WriteData;
    when std_logic_vector(to_unsigned(16, 5)) => ToReg16 <= WriteData;
    when std_logic_vector(to_unsigned(17, 5)) => ToReg17 <= WriteData;
    when std_logic_vector(to_unsigned(18, 5)) => ToReg18 <= WriteData;
    when std_logic_vector(to_unsigned(19, 5)) => ToReg19 <= WriteData;

    when std_logic_vector(to_unsigned(20, 5)) => ToReg20 <= WriteData;
    when std_logic_vector(to_unsigned(21, 5)) => ToReg21 <= WriteData;
    when std_logic_vector(to_unsigned(22, 5)) => ToReg22 <= WriteData;
    when std_logic_vector(to_unsigned(23, 5)) => ToReg23 <= WriteData;
    when std_logic_vector(to_unsigned(24, 5)) => ToReg24 <= WriteData;
    when std_logic_vector(to_unsigned(25, 5)) => ToReg25 <= WriteData;
    when std_logic_vector(to_unsigned(26, 5)) => ToReg26 <= WriteData;
    when std_logic_vector(to_unsigned(27, 5)) => ToReg27 <= WriteData;
    when std_logic_vector(to_unsigned(28, 5)) => ToReg28 <= WriteData;
    when std_logic_vector(to_unsigned(29, 5)) => ToReg29 <= WriteData;

    when std_logic_vector(to_unsigned(30, 5)) => ToReg30 <= WriteData;
    when std_logic_vector(to_unsigned(31, 5)) => ToReg31 <= WriteData;
    when others  => ToReg0 <= WriteData;
    end case;

    end if;
  end process;
  
end BEHAVIOR;

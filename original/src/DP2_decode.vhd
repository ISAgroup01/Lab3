library IEEE;
use IEEE.std_logic_1164.all; 
use ieee.numeric_std.all;
use WORK.RISCV_package.all;

entity DECODE is
	Port (IR : IN std_logic_vector(nb -1 downto 0);
			REG_WR_EN : IN std_logic; --Enable
			CLOCK : IN std_logic;
			RESET : IN std_logic;
			WRITE_REG : IN std_logic_vector(nb_reg-1 downto 0);
			WRITE_DATA : IN std_logic_vector(nb-1 downto 0);
			READ1 : out std_logic_vector(nb -1 downto 0);
			READ2 : out std_logic_vector(nb -1 downto 0);
			IMM_ext : out std_logic_vector(nb -1 downto 0);
			WR_reg : out std_logic_vector(nb_reg -1 downto 0) --RD
			);
end DECODE;

architecture STRUCT of DECODE is
component Imm_gen
	Port (IMM_IN  : IN  std_logic_vector(32 - 1 downto 0);
         IMM_OUT : OUT std_logic_vector(32 - 1 downto 0));
end component;
component RegFile_behav
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
END component;
	--	INSERT REGISTER UNIT --
	-- Input  : Reg_Read1
	-- Input  : Reg_Read2
	-- Input  : Reg_Write_reg
	-- Input  : Reg_Write_data 
	-- Output : Reg_Data1
	-- Output : Reg_Data2
signal Reg_Read1, Reg_Read2 : std_logic_vector(4 downto 0);
begin
	Reg_Read1 <= IR(19 downto 15); --Source register 1
	Reg_Read2 <= IR(24 downto 20); --Source register 2
	
	Register_file : RegFile_behav Port Map(
      ReadRegister1 => Reg_Read1,
      ReadRegister2 => Reg_Read2,
      WriteRegister => WRITE_REG,
      WriteData => WRITE_DATA,
      ReadData1 => READ1,
      ReadData2 => READ2,
      RegWrite => REG_WR_EN,
      Reset => RESET,
      Clock => CLOCK);
		
	--Imm GEN
	IMM : Imm_gen Port Map(IMM_IN => IR, IMM_OUT => IMM_ext);
	WR_reg <= IR(11 downto 7);
end STRUCT;

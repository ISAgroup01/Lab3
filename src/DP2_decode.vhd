library IEEE;
use IEEE.std_logic_1164.all; 
use ieee.numeric_std.all;
use WORK.RISCV_package.all;

entity DECODE is
	Port (IR : IN std_logic_vector(nb -1 downto 0);
			Reg_wr_en : IN std_logic;
			READ1 : out std_logic_vector(nb -1 downto 0);
			READ2 : out std_logic_vector(nb -1 downto 0);
			IMM_ext : out std_logic_vector(nb -1 downto 0);
			WR_reg : out std_logic_vector(nb_reg -1 downto 0);
			);
end DECODE;

architecture STUCT of DECODE is
component Imm_gen
	Port (IMM_IN  : IN  std_logic_vector(32 - 1 downto 0);
         IMM_OUT : OUT std_logic_vector(32 - 1 downto 0));
end component;

	--	INSERT REGISTER UNIT --
	RF_WE
	-- Input  : Reg_Read1
	-- Input  : Reg_Read2
	-- Input  : Reg_Write_reg
	-- Input  : Reg_Write_data 
	-- Output : Reg_Data1
	-- Output : Reg_Data2
begin
	Reg_Read1 <= IR(19 downto 15); --Source register 1
	Reg_Read2 <= IR(24 downto 20); --Source register 2
	--Imm GEN
	IMM : Imm_gen Port Map(IMM_IN => IR, IMM_OUT = > IMM_ext);
	WR_reg <= IR(11 downto 7);
end STRUCT;

--Top Level RISC-V Lite processor
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.RISCV_package.all;


entity RISC is
	port(
		I_MEM_read    : in  std_logic_vector(nb_i-1 downto 0);
		I_MEM_address : out std_logic_vector(nb_i-1 downto 0);
		D_MEM_read    : in  std_logic_vector(nb_i-1 downto 0);
		D_MEM_address : out std_logic_vector(nb_i-1 downto 0);
		D_MEM_write   : out std_logic_vector(nb_i-1 downto 0));
end entity;

architecture structural of RISC is
--Component
component mux2to1
	Port(A   :  IN   std_logic_vector(nb_i-1 downto 0);
	     B   :  IN   std_logic_vector(nb_i-1 downto 0);
		  sel :  IN   std_logic;
		  S   :  OUT  std_logic_vector(nb_i-1 downto 0));
end component;
component REG
	Port (REG_IN    :	In	signed(nb_i-1 downto 0);
		   REG_EN    :	In	std_logic;
	      REG_CLK   :	In	std_logic;
         REG_RESET :	In	std_logic;
         REG_OUT   : Out signed(nb_i-1 downto 0));
end component;

--Fetch signal
signal new_PC, sig_PC, PC_in, branch_PC : std_logic_vector(nb_i-1 downto 0) := (others => '0');
signal PCSrc, PC_enable, IF_ID_en : std_logic;
--Decode signal
signal PC_ID, ID_instr : std_logic_vector(nb_i -1 downto 0);
signal CU_WB_dec, CU_MEM_dec, CU_EX_dec, Reg_Data1, Reg_Data2 : std_logic_vector(nb_i -1 downto 0);
signal ID_EX_en : std_logic;
--Execute signal
signal PC_EX : std_logic_vector(nb_i-1 downto 0);
signal CU_WB_ex, CU_MEM_ex, CU_EX_ex, Reg_Data1_ex, Reg_Data2_ex, Reg_Write_reg_EX : std_logic_vector(nb_i-1 downto 0);
signal ALU_in2, ALU_res, AddSum1, AddSum2, AddSum_res : std_logic_vector(nb_i-1 downto 0);
signal ALUSrc, ALU_zero, EX_MEM_en : std_logic;
--Mem signal
signal CU_WB_m, CU_MEM_m, ALU_res_m, Reg_Data1_m, Reg_Write_reg_m, MemDataout : std_logic_vector(nb_i-1 downto 0);
signal MEM_WB_en, ALU_zero_m, MemRead, MemWrite : std_logic;
--WB signal
signal MemDataout_wb, ALU_res_wb, Reg_Write_reg, Reg_Write_data : std_logic_vector(nb_i-1 downto 0);
signal MEMReg : std_logic;
--------------------
--CU signal
--RISC_CLK, RISC_RST
--IF_ID_en, ID_EX_en, EX_MEM_en, MEM_WB_en
--ALUSrc, MEMReg
--------------------
begin

--Fetch-----------------------------------------------------------------------------------------------
	
	mux_IF : mux2to1 Port Map (A => new_PC, B => branch_PC, sel => PCSrc, S => PC_in);
	--PC
	REG_PC : REG Port Map(REG_IN => PC_in, REG_EN => PC_enable, REG_CLK => RISC_CLK,
								 REG_RESET => RISC_RST, REG_OUT => sig_PC);
	I_MEM_address <= sig_PC;
	--Update PC (+4)
	new_PC <= sig_PC << 2;
	
	-- INSERT INSTRUCTION MEMORY --
	-- Input  : sig_PC
	-- Output : I_MEM_read
	-- Output : I_MEM_address
	
	REG_IFtoID1 : REG Port Map(REG_IN => sig_PC, REG_EN => IF_ID_en, REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => PC_ID);
	REG_IFtoID2 : REG Port Map(REG_IN => I_MEM_read, REG_EN => IF_ID_en, REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => ID_instr);

--Decode---------------------------------------------------------------------------------------------

	--	INSERT REGISTER UNIT --
	-- Input  : ID_instr
	-- Input  : ID_instr
	-- Input  : Reg_Write_reg
	-- Input  : Reg_Write_data 
	-- Output : Reg_Data1
	-- Output : Reg_Data2
	
	-- INSERT CONTROL UNIT --
	-- Input  : ID_instr
	-- Output : CU_WB_dec
	-- Output : CU_MEM_dec
	-- Output : CU_EX_dec
	
	--CU_WB
	REG_IDtoEX1 : REG Port Map(REG_IN => CU_WB_dec, REG_EN => ID_EX_en, REG_CLK => RISC_CLK, 
										REG_RESET => RISC_RST, REG_OUT => CU_WB_ex);
	--CU_MEM
	REG_IDtoEX2 : REG Port Map(REG_IN => CU_MEM_dec, REG_EN => ID_EX_en, REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => CU_MEM_ex);
	--CU_EX
	REG_IDtoEX3 : REG Port Map(REG_IN => CU_EX_dec, REG_EN => ID_EX_en, REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => CU_EX_ex);
										
	REG_IDtoEX4 : REG Port Map(REG_IN => PC_ID, REG_EN => ID_EX_en, REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => PC_EX);
	REG_IDtoEX5 : REG Port Map(REG_IN => Reg_Data1, REG_EN => ID_EX_en, REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => Reg_Data1_ex);
	REG_IDtoEX6 : REG Port Map(REG_IN => Reg_Data2, REG_EN => ID_EX_en, REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => Reg_Data2_ex);
										
	REG_IDtoEX7 : REG Port Map(REG_IN => , REG_EN => ID_EX_en, REG_CLK => RISC_CLK, REG_RESET => RISC_RST, REG_OUT => );
	REG_IDtoEX8 : REG Port Map(REG_IN => , REG_EN => ID_EX_en, REG_CLK => RISC_CLK, REG_RESET => RISC_RST, REG_OUT => );
	REG_IDtoEX9 : REG Port Map(REG_IN => , REG_EN => ID_EX_en, REG_CLK => RISC_CLK, 
										REG_RESET => RISC_RST, REG_OUT => Reg_Write_reg_EX);

--Execute-------------------------------------------------------------------------------------------------------------------------

	mux_EX : mux2to1 Port Map (A => Reg_Data1_ex, B => , sel => ALUSrc, S => ALU_in2);
	
	-- INSERT ALU --
	-- Input  : Reg_Data1_ex
	-- Input  : ALU_in2
	-- Input  : ALU_sel
	-- Output : ALU_zero
	-- Output : ALU_res
	
	-- INSERT AddSum --
	-- Input  : AddSum1 
	-- Input  : AddSum2
	-- Output : AddSum_res
	
	--CU_WB
	REG_EXtoMEM1 : REG Port Map(REG_IN => CU_WB_ex, REG_EN => EX_MEM_en, REG_CLK => RISC_CLK,
										 REG_RESET => RISC_RST, REG_OUT => CU_WB_m);
	--CU_MEM
	REG_EXtoMEM2 : REG Port Map(REG_IN => CU_MEM_ex, REG_EN => EX_MEM_en, REG_CLK => RISC_CLK,
										 REG_RESET => RISC_RST, REG_OUT => CU_MEM_m);
										 
	REG_EXtoMEM3 : REG Port Map(REG_IN => AddSum_res, REG_EN => EX_MEM_en, REG_CLK => RISC_CLK,
										 REG_RESET => RISC_RST, REG_OUT => branch_PC);
	REG_EXtoMEM4 : REG Port Map(REG_IN => ALU_zero, REG_EN => EX_MEM_en, REG_CLK => RISC_CLK,
										 REG_RESET => RISC_RST, REG_OUT => ALU_zero_m);
	REG_EXtoMEM5 : REG Port Map(REG_IN => ALU_res, REG_EN => EX_MEM_en, REG_CLK => RISC_CLK,
										 REG_RESET => RISC_RST, REG_OUT => ALU_res_m);
	REG_EXtoMEM6 : REG Port Map(REG_IN => Reg_Data1_ex, REG_EN => EX_MEM_en, REG_CLK => RISC_CLK,
								       REG_RESET => RISC_RST, REG_OUT => Reg_Data1_m);
	REG_EXtoMEM7 : REG Port Map(REG_IN => Reg_Write_reg_EX, REG_EN => EX_MEM_en, REG_CLK => RISC_CLK,
										 REG_RESET => RISC_RST, REG_OUT => Reg_Write_reg_m);

--Mem---------------------------------------------------------------------------------------------------------------------------------------

	-- INSERT DATA MEMORY
	-- Input  : ALU_res_m
	-- Input  : Reg_Data1_m
	-- Input  : MemRead
	-- Input  : MemWrite
	-- Output : MemDataout
	
	--Branch
	PCsrc <= ALU_zero_m and CU_MEM_m;
	--CU_WB
	REG_MEMtoWB1 : REG Port Map(REG_IN => CU_WB_m, REG_EN => MEM_WB_en, REG_CLK => RISC_CLK, 
										 REG_RESET => RISC_RST, REG_OUT => PCSrc);
	
	REG_MEMtoWB2 : REG Port Map(REG_IN => MemDataout, REG_EN => MEM_WB_en, REG_CLK => RISC_CLK, 
										 REG_RESET => RISC_RST, REG_OUT => MemDataout_wb);
	REG_MEMtoWB3 : REG Port Map(REG_IN => ALU_res_m, REG_EN => MEM_WB_en, REG_CLK => RISC_CLK, 
										 REG_RESET => RISC_RST, REG_OUT => ALU_res_wb);
	REG_MEMtoWB4 : REG Port Map(REG_IN => Reg_Write_reg_m, REG_EN => MEM_WB_en, REG_CLK => RISC_CLK, 
										 REG_RESET => RISC_RST, REG_OUT => Reg_Write_reg);
--WB----------------------------------------------------------------------------------------------------------------------------------------
	mux_WB : mux2to1 Port Map (A => ALU_res_wb, B => MemDataout_wb, sel => MEMReg, S => Reg_Write_data);
end architecture;

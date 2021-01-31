--Top Level RISC-V Lite processor
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.RISCV_package.all;

entity RISC is
	port(
		I_MEM_read    : in  std_logic_vector(nb_i-1 downto 0);
		I_MEM_address : out std_logic_vector(nb_d-1 downto 0);
		D_MEM_read    : in  std_logic_vector(nb_i-1 downto 0);
		D_MEM_address : out std_logic_vector(nb_i-1 downto 0);
		D_MEM_write   : out std_logic_vector(nb_i-1 downto 0));
end entity;

architecture structural of RISC is
--Component
component mux2to1
	Generic (N : integer := 32);
	Port(A   :  IN   std_logic_vector(nb_i-1 downto 0);
	     B   :  IN   std_logic_vector(nb_i-1 downto 0);
		  sel :  IN   std_logic;
		  S   :  OUT  std_logic_vector(nb_i-1 downto 0));
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
	Port( A_csa    : IN  std_logic_vector(64 - 1 downto 0);
		   B_csa    : IN  std_logic_vector(64 - 1 downto 0);
		   Cin_csa  : IN  std_logic;
		   Cout_csa : OUT std_logic;
		   S_csa    : OUT std_logic_vector(64 - 1 downto 0));
end component;

--Fetch signal
signal new_PC, PC_IF, PC_in, branch_PC : std_logic_vector(nb_d-1 downto 0) := (others => '0');
signal PCSrc, PC_enable, IF_ID_en, Co_csa : std_logic;

--Decode signal
signal PC_ID, ID_instr_ext : std_logic_vector(nb_d -1 downto 0);
signal ID_instr, ext_instr : std_logic_vector(nb_i -1 downto 0);
signal Reg_Data1, Reg_Data2 : std_logic_vector(nb_d -1 downto 0); --Register values
signal Reg_Read1, Reg_Read2 : std_logic_vector(nb_reg -1 downto 0); --Address register
signal alu_ctrl_ID, alu_ctrl_ex : std_logic_vector(-1 downto 0);--Alu control
signal CU_WB_dec, CU_MEM_dec, CU_EX_dec : std_logic_vector(nb_i -1 downto 0);
signal ID_EX_en : std_logic;

--Execute signal
signal PC_EX, EX_instr, EX_instr_sf, branch_PC_EX : std_logic_vector(nb_d-1 downto 0);
signal Reg_Data1_ex, Reg_Data2_ex : std_logic_vector(nb_d-1 downto 0);
signal Reg_Write_reg_EX : std_logic_vector(nb_reg -1 downto 0);
signal ALU_in2, ALU_res : std_logic_vector(nb_d-1 downto 0);
signal ALUSrc, ALU_zero, ALUOp, EX_MEM_en, Co_csa1 : std_logic;
signal CU_WB_ex, CU_MEM_ex, CU_EX_ex : std_logic_vector(nb_i-1 downto 0);

--Mem signal
signal ALU_res_m, Reg_Data2_m, MemDataout : std_logic_vector(nb_d-1 downto 0);
signal Reg_Write_reg_m : std_logic_vector(nb_reg-1 downto 0);
signal CU_WB_m, CU_MEM_m : std_logic_vector(nb_i-1 downto 0);
signal MEM_WB_en, ALU_zero_m, MemRead, MemWrite : std_logic;

--WB signal
signal MemDataout_wb, ALU_res_wb, Reg_Write_data : std_logic_vector(nb_d-1 downto 0);
signal Reg_Write_reg : std_logic_vector(nb_reg-1 downto 0);
signal MEMReg : std_logic;
--------------------
--CU signal
--RISC_CLK, RISC_RST
--IF_ID_en, ID_EX_en, EX_MEM_en, MEM_WB_en
--ALUSrc, MEMReg
--------------------
begin

--Fetch-----------------------------------------------------------------------------------------------
	
	mux_IF : mux2to1 Generic Map(N => nb_d)
					     Port Map (A => new_PC, B => branch_PC, sel => PCSrc, S => PC_in);
	--PC
	REG_PC : REG Generic Map(N => nb_d)
					 Port Map(REG_IN => PC_in, REG_EN => PC_enable, REG_CLK => RISC_CLK,
								 REG_RESET => RISC_RST, REG_OUT => PC_IF);
	I_MEM_address <= PC_IF;
	--Update PC (+4)
	PC_update : CSA 
	Port Map (A_csa=> PC_IF, B_csa=>std_logic_vector(to_unsigned(4, 64)), Cin_csa=>'0', Cout_csa=>Co_csa, S_csa=>new_PC); 
	--new_PC(1 downto 0) <= PC_IF(1 downto 0);
	--new_PC(nb_d-1 downto 2) <= PC_IF(nb_d-1 downto 2) + 1;
	
	-- INSTRUCTION MEMORY --
	-- Input  : I_MEM_address
	-- Output : I_MEM_read
	
	REG_IFtoID1 : REG Generic Map(N => nb_d)
							Port Map(REG_IN => PC_IF, REG_EN => IF_ID_en, REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => PC_ID);
	REG_IFtoID2 : REG Generic Map(N => nb_i)
							Port Map(REG_IN => I_MEM_read, REG_EN => IF_ID_en, REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => ID_instr);

--Decode---------------------------------------------------------------------------------------------

	--	INSERT REGISTER UNIT --
	-- Input  : Reg_Read1
	-- Input  : Reg_Read2
	-- Input  : Reg_Write_reg
	-- Input  : Reg_Write_data 
	-- Output : Reg_Data1
	-- Output : Reg_Data2
	
	-- INSERT CONTROL UNIT --
	-- Input  : Opcode
	-- Output : CU_WB_dec
	-- Output : CU_MEM_dec
	-- Output : CU_EX_dec
	Opcode <= ID_instr(6 downto 0); --Opcode
	Reg_Read1 <= ID_instr(19 downto 15); --Source register 1
	Reg_Read2 <= ID_instr(24 downto 20); --Source register 2
	--Imm GEN
	ext_instr <= (others => ID_instr(nb_i));
	ID_instr_ext <= ext_instr & ID_instr
	
	--CU_WB
	REG_IDtoEX1 : REG Generic Map(N => )
							Port Map(REG_IN => CU_WB_dec, REG_EN => ID_EX_en, REG_CLK => RISC_CLK, 
										REG_RESET => RISC_RST, REG_OUT => CU_WB_ex);
	--CU_MEM
	REG_IDtoEX2 : REG Generic Map(N => )
							Port Map(REG_IN => CU_MEM_dec, REG_EN => ID_EX_en, REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => CU_MEM_ex);
	--CU_EX
	REG_IDtoEX3 : REG Generic Map(N => )
							Port Map(REG_IN => CU_EX_dec, REG_EN => ID_EX_en, REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => CU_EX_ex);
										
	REG_IDtoEX4 : REG Generic Map(N => nb_d)
							Port Map(REG_IN => PC_ID, REG_EN => ID_EX_en, REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => PC_EX);
	REG_IDtoEX5 : REG Generic Map(N => nb_d)
							Port Map(REG_IN => Reg_Data1, REG_EN => ID_EX_en, REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => Reg_Data1_ex);
	REG_IDtoEX6 : REG Generic Map(N => nb_d)
							Port Map(REG_IN => Reg_Data2, REG_EN => ID_EX_en, REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => Reg_Data2_ex);
										
	REG_IDtoEX7 : REG Generic Map(N => nb_d)
							Port Map(REG_IN => ID_instr_ext, REG_EN => ID_EX_en, REG_CLK => RISC_CLK, 
							         REG_RESET => RISC_RST, REG_OUT => EX_instr);
	REG_IDtoEX8 : REG Generic Map(N => )-----------------------------------------------
							Port Map(REG_IN => alu_ctrl_ID, REG_EN => ID_EX_en, REG_CLK => RISC_CLK,
						         	REG_RESET => RISC_RST, REG_OUT => alu_ctrl_EX);
	REG_IDtoEX9 : REG Generic Map(N => nb_reg)
							Port Map(REG_IN => ID_instr(11 downto 7), REG_EN => ID_EX_en, REG_CLK => RISC_CLK, 
										REG_RESET => RISC_RST, REG_OUT => Reg_Write_reg_EX);

--Execute-------------------------------------------------------------------------------------------------------------------------

	--Shift left 1
	EX_instr_sf <= EX_instr(nb_d - 2 downto 0) & '0';
	--Branch Target
	Branch_Target : CSA 
	Port Map (A_csa=> EX_instr_sf, B_csa=> PC_EX, Cin_csa=> '0', Cout_csa=> Co_csa1, S_csa=> branch_PC_EX); 
	--branch_PC_EX <= EX_instr_sf + PC_EX
	
	mux_EX : mux2to1 Generic Map(N => nb_d)
					     Port Map (A => Reg_Data2_ex, B => EX_instr, sel => ALUSrc, S => ALU_in2);
	-- ALU control --
	-- Input   : alu_ctrl_EX
	-- Output  : ALUOp
	-- Output  : ALU_sel
	
	-- INSERT ALU --
	-- Input  : Reg_Data1_ex
	-- Input  : ALU_in2
	-- Input  : ALU_sel
	-- Output : ALU_zero
	-- Output : ALU_res
	
	
	--CU_WB
	REG_EXtoMEM1 : REG Generic Map(N => )
							 Port Map(REG_IN => CU_WB_ex, REG_EN => EX_MEM_en, REG_CLK => RISC_CLK,
										 REG_RESET => RISC_RST, REG_OUT => CU_WB_m);
	--CU_MEM
	REG_EXtoMEM2 : REG Generic Map(N => )
							 Port Map(REG_IN => CU_MEM_ex, REG_EN => EX_MEM_en, REG_CLK => RISC_CLK,
										 REG_RESET => RISC_RST, REG_OUT => CU_MEM_m);
										 
	REG_EXtoMEM3 : REG Generic Map(N => nb_d)
							 Port Map(REG_IN => branch_PC_EX, REG_EN => EX_MEM_en, REG_CLK => RISC_CLK,
										 REG_RESET => RISC_RST, REG_OUT => branch_PC);
	REG_EXtoMEM4 : REG Generic Map(N => 1)
							 Port Map(REG_IN => ALU_zero, REG_EN => EX_MEM_en, REG_CLK => RISC_CLK,
										 REG_RESET => RISC_RST, REG_OUT => ALU_zero_m);
	REG_EXtoMEM5 : REG Generic Map(N => nb_d)
							 Port Map(REG_IN => ALU_res, REG_EN => EX_MEM_en, REG_CLK => RISC_CLK,
										 REG_RESET => RISC_RST, REG_OUT => ALU_res_m);
	REG_EXtoMEM6 : REG Generic Map(N => nb_d)
							 Port Map(REG_IN => Reg_Data2_ex, REG_EN => EX_MEM_en, REG_CLK => RISC_CLK,
								       REG_RESET => RISC_RST, REG_OUT => Reg_Data2_m);
	REG_EXtoMEM7 : REG Generic Map(N => nb_reg)
							 Port Map(REG_IN => Reg_Write_reg_EX, REG_EN => EX_MEM_en, REG_CLK => RISC_CLK,
										 REG_RESET => RISC_RST, REG_OUT => Reg_Write_reg_m);

--Mem---------------------------------------------------------------------------------------------------------------------------------------

	--Branch
	PCsrc <= ALU_zero_m and CU_MEM_m;
	
	-- DATA MEMORY
	-- Input  : ALU_res_m
	-- Input  : Reg_Data2_m
	-- Input  : MemRead
	-- Input  : MemWrite
	-- Output : MemDataout
	D_MEM_address <= ALU_res_m;
	D_MEM_write <= Reg_Data2_m; 
	
	--CU_WB
	REG_MEMtoWB1 : REG Generic Map(N => )
							 Port Map(REG_IN => CU_WB_m, REG_EN => MEM_WB_en, REG_CLK => RISC_CLK, 
										 REG_RESET => RISC_RST, REG_OUT => PCSrc);
	
	REG_MEMtoWB2 : REG Generic Map(N => nb_d)
							 Port Map(REG_IN => D_MEM_read, REG_EN => MEM_WB_en, REG_CLK => RISC_CLK, 
										 REG_RESET => RISC_RST, REG_OUT => MemDataout_wb);
	REG_MEMtoWB3 : REG Generic Map(N => nb_d)
							 Port Map(REG_IN => ALU_res_m, REG_EN => MEM_WB_en, REG_CLK => RISC_CLK, 
										 REG_RESET => RISC_RST, REG_OUT => ALU_res_wb);
	REG_MEMtoWB4 : REG Generic Map(N => nb_reg)
							 Port Map(REG_IN => Reg_Write_reg_m, REG_EN => MEM_WB_en, REG_CLK => RISC_CLK, 
										 REG_RESET => RISC_RST, REG_OUT => Reg_Write_reg);
--WB----------------------------------------------------------------------------------------------------------------------------------------
	mux_WB : mux2to1 Generic Map(N => nb_d)
					     Port Map (A => ALU_res_wb, B => MemDataout_wb, sel => MEMReg, S => Reg_Write_data);
end architecture;

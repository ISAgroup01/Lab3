--Top Level RISC-V Lite processor
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.RISCV_package.all;

entity RISC is
	port(
		RISC_CLK      : in std_logic;
		RISC_RST      : in std_logic;
		I_MEM_read    : in  std_logic_vector(nb-1 downto 0);
		I_MEM_address : out std_logic_vector(nb-1 downto 0);
		D_MEM_read    : in  std_logic_vector(nb-1 downto 0);
		D_MEM_address : out std_logic_vector(nb-1 downto 0);
		D_MEM_write   : out std_logic_vector(nb-1 downto 0));
end entity;

architecture structural of RISC is
--Component
component REG
	Generic (N : integer := 32);
	Port (REG_IN    :	In	signed(N-1 downto 0);
		   REG_EN    :	In	std_logic;
	      REG_CLK   :	In	std_logic;
         REG_RESET :	In	std_logic;
         REG_OUT   : Out signed(N-1 downto 0));
end component;

component CU
  generic (
    MICROCODE_MEM_SIZE :     integer := 10;  -- Microcode Memory Size
    FUNC_SIZE          :     integer := 11;  -- Func Field Size for R-Type Ops
    OP_CODE_SIZE       :     integer := 7;  -- Op Code Size
    ALU_OPC_SIZE       :     integer := 4;  -- ALU Op Code Word Size
    IR_SIZE            :     integer := 32;  -- Instruction Register Size    
    CW_SIZE            :     integer := 15);  -- Control Word Size
  port (
    Clk                : in  std_logic;  -- Clock
    Rst                : in  std_logic;  -- Reset:Active-Low
    -- Instruction Register
    IR_IN              : in  std_logic_vector(IR_SIZE - 1 downto 0);
    
    -- IF Control Signal
    IR_LATCH_EN        : out std_logic;  -- Instruction Register Latch Enable
    NPC_LATCH_EN       : out std_logic;
                                        -- NextProgramCounter Register Latch Enable
    -- ID Control Signals
    RegA_LATCH_EN      : out std_logic;  -- Register A Latch Enable
    RegB_LATCH_EN      : out std_logic;  -- Register B Latch Enable
    RegIMM_LATCH_EN    : out std_logic;  -- Immediate Register Latch Enable

    -- EX Control Signals
    MUXA_SEL           : out std_logic;  -- MUX-A Sel
    MUXB_SEL           : out std_logic;  -- MUX-B Sel
    ALU_OUTREG_EN      : out std_logic;  -- ALU Output Register Enable
    EQ_COND            : out std_logic;  -- Branch if (not) Equal to Zero
    -- ALU Operation Code
    ALU_OPCODE         : out aluOp;--std_logic_vector(ALU_OPC_SIZE -1 downto 0);
    
    -- MEM Control Signals
    DRAM_WE            : out std_logic;  -- Data RAM Write Enable
    LMD_LATCH_EN       : out std_logic;  -- LMD Register Latch Enable
    JUMP_EN            : out std_logic;  -- JUMP Enable Signal for PC input MUX
    PC_LATCH_EN        : out std_logic;  -- Program Counte Latch Enable

    -- WB Control signals
    WB_MUX_SEL         : out std_logic;  -- Write Back MUX Sel
    RF_WE              : out std_logic);  -- Register File Write Enable
end component;

--Fetch signal
signal PC_IF, branch_PC : std_logic_vector(nb-1 downto 0) := (others => '0');
signal PCSrc, IF_ID_en : std_logic;

--Decode signal
signal ID_instr, Imm_id, PC_ID : std_logic_vector(nb -1 downto 0);
signal Reg_Data1, Reg_Data2 : std_logic_vector(nb -1 downto 0); --Register values
signal Reg_Read1, Reg_Read2, Reg_Write_ID : std_logic_vector(nb_reg -1 downto 0); --Address register

--Execute signal
signal PC_EX, branch_PC_EX, Reg_Data1_ex, Reg_Data2_ex : std_logic_vector(nb-1 downto 0);
signal Imm_ex, ALU_res : std_logic_vector(nb-1 downto 0);
signal Reg_Write_EX : std_logic_vector(nb_reg -1 downto 0);

--Mem signal
signal ALU_res_m, Reg_Data2_m, MemDataout : std_logic_vector(nb-1 downto 0);
signal Reg_Write_reg_m : std_logic_vector(nb_reg-1 downto 0);

--WB signal
signal MemDataout_wb, ALU_res_wb, Reg_Write_data : std_logic_vector(nb-1 downto 0);
signal Reg_Write_reg : std_logic_vector(nb_reg-1 downto 0);

--CU signal
signal ID_instr, cu_ir_en, cu_npc_en, cu_regA_en, cu_regB_en : std_logic;
signal cu_regIMM_en, cu_muxA, cu_muxB, cu_ALU, cu_eq_cond : std_logic;
signal cu_ALU_opcode, cu_dram_we, cu_lmd_en, cu_jump_en : std_logic;
signal cu_latch_en, cu_wb_mux_sel, cu_rf_we : std_logic;
begin

--Fetch-----------------------------------------------------------------------------------------------

	DP_FETCH : FETCH 
		Port Map(PC_b => branch_PC,
			      PC_sel  => PCSrc,
		         fetch_CLK  => RISC_CLK,
		         fetch_RST  => RISC_RST,
		         PC_out => PC_IF);
					
	I_MEM_address <= PC_IF;
	
	-- INSTRUCTION MEMORY --
	-- Input  : I_MEM_address
	-- Output : I_MEM_read
	
	IF_ID_en <= '1';
	REG_IFtoID1 : REG Generic Map(N => nb)
							Port Map(REG_IN => PC_IF, REG_EN => cu_ir_en, REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => PC_ID);
	REG_IFtoID2 : REG Generic Map(N => nb)
							Port Map(REG_IN => I_MEM_read, REG_EN => cu_npc_en, REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => ID_instr);

--Decode---------------------------------------------------------------------------------------------
	
	dp_CU : CU 
			Generic Map(
    MICROCODE_MEM_SIZE => 10, FUNC_SIZE => 11, OP_CODE_SIZE => 7, ALU_OPC_SIZE => 4, IR_SIZE => 32, CW_SIZE => 15)
			Port Map(
    Clk => RISC_CLK, Rst => RISC_RST,
    -- Instruction Register
    IR_IN => ID_instr,
    -- IF Control Signal
    IR_LATCH_EN => cu_ir_en,
    NPC_LATCH_EN => cu_npc_en,
    -- ID Control Signals
    RegA_LATCH_EN => cu_regA_en,
    RegB_LATCH_EN => cu_regB_en,
    RegIMM_LATCH_EN => cu_regIMM_en,
    -- EX Control Signals
    MUXA_SEL => cu_muxA,
    MUXB_SEL => cu_muxB,
    ALU_OUTREG_EN => cu_ALU,
    EQ_COND => cu_eq_cond,
    -- ALU Operation Code
    ALU_OPCODE => cu_ALU_opcode,
    -- MEM Control Signals
    DRAM_WE => cu_dram_we,
    LMD_LATCH_EN => cu_lmd_en,
    JUMP_EN => cu_jump_en,
    PC_LATCH_EN => cu_latch_en,
    -- WB Control signals
    WB_MUX_SEL => cu_wb_mux_sel,
    RF_WE => cu_rf_we);
	
	DP_DECODE : DECODE Port Map(
			Reg_wr_en <= cu_rf_we,
	      IR => ID_instr,
			READ1 => Reg_Data1,
			READ2 => Reg_Data2,
			IMM_ext => Imm_id,
			WR_reg => Reg_Write_ID);	
			
	REG_IDtoEX1 : REG Generic Map(N => nb)
							Port Map(REG_IN => PC_ID, REG_EN => , REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => PC_EX);
	REG_IDtoEX2 : REG Generic Map(N => nb)
							Port Map(REG_IN => Reg_Data1, REG_EN => cu_regA_en, REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => Reg_Data1_ex);
	REG_IDtoEX3 : REG Generic Map(N => nb)
							Port Map(REG_IN => Reg_Data2, REG_EN => cu_regB_en, REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => Reg_Data2_ex);
										
	REG_IDtoEX4 : REG Generic Map(N => nb)
							Port Map(REG_IN => Imm_id, REG_EN => cu_regIMM_en, REG_CLK => RISC_CLK, 
							         REG_RESET => RISC_RST, REG_OUT => Imm_ex);

	REG_IDtoEX5 : REG Generic Map(N => nb_reg)
							Port Map(REG_IN => Reg_Write_ID, REG_EN => , REG_CLK => RISC_CLK, 
										REG_RESET => RISC_RST, REG_OUT => Reg_Write_EX);

										
--Execute-------------------------------------------------------------------------------------------------------------------------

	DP_EXECUTE : EXECUTE Port Map(
		  PC => PC_EX,
	     DATA1_ex => Reg_Data1_ex,
	     DATA2_ex => Reg_Data2_ex,
		  IMM => Imm_ex,
		  ALUSrc => ,
		  ALUOpcode => cu_ALU_opcode,
		  PC_out => branch_PC_EX,
		  Zero => ALU_zero,
		  ALU_res_ex => ALU_res);
										 
	REG_EXtoMEM3 : REG Generic Map(N => nb_d)
							 Port Map(REG_IN => branch_PC_EX, REG_EN => , REG_CLK => RISC_CLK,
										 REG_RESET => RISC_RST, REG_OUT => PC_b);
	REG_EXtoMEM4 : REG Generic Map(N => 1)
							 Port Map(REG_IN => ALU_zero, REG_EN => cu_eq_cond, REG_CLK => RISC_CLK,
										 REG_RESET => RISC_RST, REG_OUT => ALU_zero_m);
	REG_EXtoMEM5 : REG Generic Map(N => nb_d)
							 Port Map(REG_IN => ALU_res, REG_EN => cu_ALU, REG_CLK => RISC_CLK,
										 REG_RESET => RISC_RST, REG_OUT => ALU_res_m);
	REG_EXtoMEM6 : REG Generic Map(N => nb_d)
							 Port Map(REG_IN => Reg_Data2_ex, REG_EN => , REG_CLK => RISC_CLK,
								       REG_RESET => RISC_RST, REG_OUT => Reg_Data2_m);
	REG_EXtoMEM7 : REG Generic Map(N => nb_reg)
							 Port Map(REG_IN => Reg_Write_EX, REG_EN => , REG_CLK => RISC_CLK,
										 REG_RESET => RISC_RST, REG_OUT => Reg_Write_m);

--Mem---------------------------------------------------------------------------------------------------------------------------------------

	--Branch
	PCsrc <= ALU_zero_m and ;
	
	-- DATA MEMORY
	-- Input  : ALU_res_m
	-- Input  : Reg_Data2_m
	-- Input  : MemRead
	-- Input  : MemWrite
	-- Output : MemDataout
	D_MEM_address <= ALU_res_m;
	D_MEM_write <= Reg_Data2_m; 

	REG_MEMtoWB2 : REG Generic Map(N => nb)
							 Port Map(REG_IN => D_MEM_read, REG_EN => , REG_CLK => RISC_CLK, 
										 REG_RESET => RISC_RST, REG_OUT => MemDataout_wb);
	REG_MEMtoWB3 : REG Generic Map(N => nb)
							 Port Map(REG_IN => ALU_res_m, REG_EN => , REG_CLK => RISC_CLK, 
										 REG_RESET => RISC_RST, REG_OUT => ALU_res_wb);
	REG_MEMtoWB4 : REG Generic Map(N => nb_reg)
							 Port Map(REG_IN => Reg_Write_reg_m, REG_EN => , REG_CLK => RISC_CLK, 
										 REG_RESET => RISC_RST, REG_OUT => Reg_Write);
--WB----------------------------------------------------------------------------------------------------------------------------------------
	mux_WB : mux2to1 Generic Map(N => nb_d)
					     Port Map (A => ALU_res_wb, B => MemDataout_wb, sel => cu_wb_mux_sel, S => Reg_Write_data);


end architecture;

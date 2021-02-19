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
		D_MEM_WE      : out std_logic;
		D_MEM_RE      : out std_logic;
		D_MEM_address : out std_logic_vector(nb-1 downto 0);
		D_MEM_write   : out std_logic_vector(nb-1 downto 0));
end entity;

architecture structural of RISC is
--Component
component FETCH
	Port(
		  PC_b : IN std_logic_vector(nb-1 downto 0);
		  PC_sel : IN std_logic;
		  fetch_CLK : IN std_logic;
		  fetch_RST : IN std_logic;
		  JAL_value : OUT std_logic_vector(nb-1 downto 0);
		  PC_out : OUT std_logic_vector(nb-1 downto 0));
end component;
component DECODE
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
end component;
component EXECUTE
	Port(PC : IN std_logic_vector(nb-1 downto 0);
	     DATA1_ex  : IN std_logic_vector(nb-1 downto 0);
	     DATA2_ex : IN std_logic_vector(nb-1 downto 0);
		  IMM : IN std_logic_vector(nb-1 downto 0);
		  ALUSrc : IN std_logic;
		  ALUOpcode : IN aluOp;
		  PC_out : OUT std_logic_vector(nb-1 downto 0);
		  Zero : OUT std_logic;
		  ALU_res_ex : OUT std_logic_vector(nb-1 downto 0));
end component;
component REG
	Generic (N : integer := 32);
	Port (REG_IN    :	In	std_logic_vector(N-1 downto 0);
		   REG_EN    :	In	std_logic;
	      REG_CLK   :	In	std_logic;
         REG_RESET :	In	std_logic;
         REG_OUT   : Out std_logic_vector(N-1 downto 0));
end component;
component REG_1
	Port (REG_IN    :	In	std_logic;
		   REG_EN    :	In	std_logic;
	      REG_CLK   :	In	std_logic;
         REG_RESET :	In	std_logic;
         REG_OUT   : Out std_logic);
end component;
component mux4to1
	Generic (N : integer := 32);
	Port(A   :  IN   std_logic_vector(N-1 downto 0);
	     B   :  IN   std_logic_vector(N-1 downto 0);
		  C   :  IN   std_logic_vector(N-1 downto 0);
		  D   :  IN   std_logic_vector(N-1 downto 0);
		  sel :  IN   std_logic_vector(1 downto 0);
		  S   :  OUT  std_logic_vector(N-1 downto 0));
end component;
component CU
  generic (
    MICROCODE_MEM_SIZE :     integer := 16;  -- Microcode Memory Size
    FUNC_SIZE          :     integer := 3;  -- Func Field Size for R-Type Ops
    OP_CODE_SIZE       :     integer := 7;  -- Op Code Size
    ALU_OPC_SIZE       :     integer := 4;  -- ALU Op Code Word Size
    IR_SIZE            :     integer := 32;  -- Instruction Register Size    
    CW_SIZE            :     integer := 20);  -- Control Word Size
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
    Reg1_LATCH_EN       : out std_logic;
    Reg2_LATCH_EN       : out std_logic;
    PC_LATCH_EN         : out std_logic;
    RegIMM_LATCH_EN     : out std_logic;
    RegD_LATCH_EN       : out std_logic;


    -- EX Control Signals
    MUX_SEL              : out std_logic;
    ADD_LATCH_EN         : out std_logic;
    ALU_OUTREG_LATCH_EN  : out std_logic;
    Reg_LATCH_EN         : out std_logic;
    EQ_COND              : out std_logic;
    RegD1_LATCH_EN       : out std_logic;
    
    -- ALU Operation Code
    ALU_OPCODE         : out aluOp;--std_logic_vector(ALU_OPC_SIZE -1 downto 0);
    
    -- MEM Control Signals
    MEM_WE              : out std_logic;
    MEM_RE              : out std_logic;
    DATA_MEM_LATCH_EN   : out std_logic;
    BYPASS_MEM_LATCH_EN : out std_logic;
    JUMP_EN             : out std_logic;
    RegD2_LATCH_EN      : out std_logic;

    -- WB Control signals
    WB_MUX_SEL1         : out std_logic;  -- Write Back MUX Sel
    WB_MUX_SEL2         : out std_logic;  -- Write Back MUX Sel
    RF_WE              : out std_logic);  -- Register File Write Enable

end component;

--Fetch signal
signal PC_IF, branch_PC, jal_if : std_logic_vector(nb-1 downto 0) := (others => '0');
signal PCSrc : std_logic;

--Decode signal
signal ID_instr, Imm_id, PC_ID, jal_id : std_logic_vector(nb -1 downto 0);
signal Reg_Data1, Reg_Data2 : std_logic_vector(nb -1 downto 0); --Register values
signal Reg_Read1, Reg_Read2, Reg_Write_ID : std_logic_vector(nb_reg -1 downto 0); --Address register

--Execute signal
signal PC_EX, branch_PC_EX, Reg_Data1_ex, Reg_Data2_ex, Imm_ex, ALU_res, jal_ex : std_logic_vector(nb-1 downto 0);
signal Reg_Write_EX : std_logic_vector(nb_reg -1 downto 0);
signal ALU_zero : std_logic;

--Mem signal
signal ALU_res_m, Reg_Data2_m, MemDataout, auipc_data, jal_mem : std_logic_vector(nb-1 downto 0);
signal Reg_Write_m : std_logic_vector(nb_reg-1 downto 0);
signal ALU_zero_m : std_logic;

--WB signal
signal MemDataout_wb, ALU_res_wb, Reg_Write_data, jal_wb : std_logic_vector(nb-1 downto 0);
signal Reg_Write : std_logic_vector(nb_reg-1 downto 0);
signal mux_sel_wb : std_logic_vector(1 downto 0);
--CU signal
signal cu_ir_en, cu_npc_en, cu_reg1_en, cu_reg2_en : std_logic;
signal cu_regIMM_en, cu_rd_en, cu_pc_en, cu_mux_sel, cu_add_en, cu_ALU : std_logic;
signal cu_reg_ex_en, cu_eq_cond, cu_rd1_en, cu_mem_we, cu_data_mem, cu_bypass, cu_jump_en, cu_rd2_en : std_logic;
signal cu_wb1, cu_wb2, cu_rf_we : std_logic;
signal cu_ALU_opcode : aluOp;

signal cu_mem_re : std_logic;

begin

--Fetch-----------------------------------------------------------------------------------------------

	DP_FETCH : FETCH 
		Port Map(PC_b => branch_PC,
			      PC_sel  => PCSrc,
		         fetch_CLK  => RISC_CLK,
		         fetch_RST  => RISC_RST,
					JAL_value => jal_if,
		         PC_out => PC_IF);
					
	I_MEM_address <= PC_IF;
	
	-- INSTRUCTION MEMORY --
	-- Input  : I_MEM_address
	-- Output : I_MEM_read
	
	--IF_ID_en <= '1';
	REG_IFtoID1 : REG Generic Map(N => nb)
							Port Map(REG_IN => PC_IF, REG_EN => '1', REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => PC_ID);
	REG_IFtoID2 : REG Generic Map(N => nb)
							Port Map(REG_IN => I_MEM_read, REG_EN => '1', REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => ID_instr);
										
	REG_IFtoID3 : REG Generic Map(N => nb)
							Port Map(REG_IN => jal_if, REG_EN => '1', REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => jal_id);
--Decode---------------------------------------------------------------------------------------------

	dp_CU : CU 
			--Generic Map(
    --MICROCODE_MEM_SIZE => 16, FUNC_SIZE => 3, OP_CODE_SIZE => 7, ALU_OPC_SIZE => 4, IR_SIZE => 32, CW_SIZE => 21)
			Port Map(
    Clk => RISC_CLK, Rst => RISC_RST,
    -- Instruction Register
    IR_IN => ID_instr,
    -- IF Control Signal
    IR_LATCH_EN => cu_ir_en,
    NPC_LATCH_EN => cu_npc_en,
    -- ID Control Signals
    Reg1_LATCH_EN => cu_reg1_en,
    Reg2_LATCH_EN => cu_reg2_en,
    RegIMM_LATCH_EN => cu_regIMM_en,
	 RegD_LATCH_EN => cu_rd_en,
	 PC_LATCH_EN => cu_pc_en,
    -- EX Control Signals
	 MUX_SEL => cu_mux_sel,
    ADD_LATCH_EN => cu_add_en,
    ALU_OUTREG_LATCH_EN => cu_ALU,
    Reg_LATCH_EN => cu_reg_ex_en,
    EQ_COND => cu_eq_cond,
    RegD1_LATCH_EN => cu_rd1_en, 
    -- ALU Operation Code
    ALU_OPCODE => cu_ALU_opcode,
    -- MEM Control Signals
	 MEM_WE => cu_mem_we,
	 MEM_RE => cu_mem_re,
    DATA_MEM_LATCH_EN => cu_data_mem, 
    BYPASS_MEM_LATCH_EN => cu_bypass, 
    JUMP_EN => cu_jump_en,
    RegD2_LATCH_EN => cu_rd2_en, 
    -- WB Control signals
	 WB_MUX_SEL1 => cu_wb1, 
    WB_MUX_SEL2 => cu_wb2, 
    RF_WE => cu_rf_we);


	
	DP_DECODE : DECODE Port Map(
			IR => ID_instr,
			REG_WR_EN => cu_rf_we,
			CLOCK => RISC_CLK,
			RESET => RISC_RST,
			WRITE_REG => Reg_Write, --rd
			WRITE_DATA => Reg_Write_data, --value
			READ1 => Reg_Data1,
			READ2 => Reg_Data2,
			IMM_ext => Imm_id,
			WR_reg => Reg_Write_ID);
			
	REG_IDtoEX1 : REG Generic Map(N => nb)
							Port Map(REG_IN => PC_ID, REG_EN => cu_pc_en, REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => PC_EX);
	REG_IDtoEX2 : REG Generic Map(N => nb)
							Port Map(REG_IN => Reg_Data1, REG_EN => cu_reg1_en, REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => Reg_Data1_ex);
	REG_IDtoEX3 : REG Generic Map(N => nb)
							Port Map(REG_IN => Reg_Data2, REG_EN => cu_reg2_en, REG_CLK => RISC_CLK,
										REG_RESET => RISC_RST, REG_OUT => Reg_Data2_ex);
										
	REG_IDtoEX4 : REG Generic Map(N => nb)
							Port Map(REG_IN => Imm_id, REG_EN => cu_regIMM_en, REG_CLK => RISC_CLK, 
							         REG_RESET => RISC_RST, REG_OUT => Imm_ex);

	REG_IDtoEX5 : REG Generic Map(N => nb_reg)
							Port Map(REG_IN => Reg_Write_ID, REG_EN => cu_rd_en, REG_CLK => RISC_CLK, 
										REG_RESET => RISC_RST, REG_OUT => Reg_Write_EX);
										
	REG_IDtoEX6 : REG Generic Map(N => nb)
							Port Map(REG_IN => jal_id, REG_EN => cu_rd_en, REG_CLK => RISC_CLK, 
										REG_RESET => RISC_RST, REG_OUT => jal_ex);									
--Execute-------------------------------------------------------------------------------------------------------------------------

	DP_EXECUTE : EXECUTE Port Map(
		  PC => PC_EX,
	     DATA1_ex => Reg_Data1_ex,
	     DATA2_ex => Reg_Data2_ex,
		  IMM => Imm_ex,
		  ALUSrc => cu_mux_sel,
		  ALUOpcode => cu_ALU_opcode,
		  PC_out => branch_PC_EX,
		  Zero => ALU_zero,
		  ALU_res_ex => ALU_res);
										 
	REG_EXtoMEM3 : REG Generic Map(N => nb)
							 Port Map(REG_IN => branch_PC_EX, REG_EN => cu_add_en, REG_CLK => RISC_CLK,
										 REG_RESET => RISC_RST, REG_OUT => branch_PC);
	REG_EXtoMEM4 : REG_1 Port Map(REG_IN => ALU_zero, REG_EN => cu_eq_cond, REG_CLK => RISC_CLK,
										 REG_RESET => RISC_RST, REG_OUT => ALU_zero_m);
	REG_EXtoMEM5 : REG Generic Map(N => nb)
							 Port Map(REG_IN => ALU_res, REG_EN => cu_ALU, REG_CLK => RISC_CLK,
										 REG_RESET => RISC_RST, REG_OUT => ALU_res_m);
	REG_EXtoMEM6 : REG Generic Map(N => nb)
							 Port Map(REG_IN => Reg_Data2_ex, REG_EN => cu_reg_ex_en, REG_CLK => RISC_CLK,
								       REG_RESET => RISC_RST, REG_OUT => Reg_Data2_m);
	REG_EXtoMEM7 : REG Generic Map(N => nb_reg)
							 Port Map(REG_IN => Reg_Write_EX, REG_EN => cu_rd1_en, REG_CLK => RISC_CLK,
										 REG_RESET => RISC_RST, REG_OUT => Reg_Write_m);
	REG_EXtoMEM8 : REG Generic Map(N => nb)
							 Port Map(REG_IN => jal_ex, REG_EN => cu_rd1_en, REG_CLK => RISC_CLK,
										 REG_RESET => RISC_RST, REG_OUT => jal_mem);										 
--Mem---------------------------------------------------------------------------------------------------------------------------------------

	--Branch
	PCsrc <= ALU_zero_m and cu_jump_en;
	
	-- DATA MEMORY
	-- Input  : ALU_res_m
	-- Input  : Reg_Data2_m
	-- Input  : cu_mem_we
	-- Output : MemDataout
	D_MEM_address <= ALU_res_m;
	D_MEM_write <= Reg_Data2_m; 
	D_MEM_WE <= cu_mem_we;
	D_MEM_RE <= cu_mem_re;
	
	
	REG_MEMtoWB2 : REG Generic Map(N => nb)
							 Port Map(REG_IN => D_MEM_read, REG_EN => cu_data_mem, REG_CLK => RISC_CLK, 
										 REG_RESET => RISC_RST, REG_OUT => MemDataout_wb);
	REG_MEMtoWB3 : REG Generic Map(N => nb)
							 Port Map(REG_IN => ALU_res_m, REG_EN => cu_bypass, REG_CLK => RISC_CLK, 
										 REG_RESET => RISC_RST, REG_OUT => ALU_res_wb);
	REG_MEMtoWB4 : REG Generic Map(N => nb_reg)
							 Port Map(REG_IN => Reg_Write_m, REG_EN => cu_rd2_en, REG_CLK => RISC_CLK, 
										 REG_RESET => RISC_RST, REG_OUT => Reg_Write);
	REG_MEMtoWB5 : REG Generic Map(N => nb)
							 Port Map(REG_IN => branch_PC, REG_EN => cu_rd2_en, REG_CLK => RISC_CLK, 
										 REG_RESET => RISC_RST, REG_OUT => auipc_data);		
	REG_MEMtoWB6 : REG Generic Map(N => nb)
							 Port Map(REG_IN => jal_mem, REG_EN => cu_rd2_en, REG_CLK => RISC_CLK, 
										 REG_RESET => RISC_RST, REG_OUT => jal_wb);										 
--WB----------------------------------------------------------------------------------------------------------------------------------------
	--mux_sel_wb <= cu_wb2 & cu_wb1;
	mux_sel_wb <= "00";
	mux_WB : mux4to1 Generic Map(N => nb)
					     Port Map (A => ALU_res_wb, B => MemDataout_wb, C => jal_wb, D => auipc_data,
										sel => mux_sel_wb, S => Reg_Write_data);

end architecture;

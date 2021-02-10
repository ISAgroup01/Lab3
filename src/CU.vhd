library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_arith.all;
use work.myTypes.all;
use ieee.numeric_std.all;
--use work.all;

entity CU is
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

end CU;

architecture CU_HW of CU is
  type mem_array is array (integer range 0 to MICROCODE_MEM_SIZE - 1) of std_logic_vector(CW_SIZE - 1 downto 0);
  signal cw_mem : mem_array := ("111100010000111", -- LW
                                "000000000000000",  
                                "111011111001100", -- I-type  
                                "000000000000000", -- AUIPC
                                "000000000000000", -- SW
                                "000000000000000",
                                "000000000000000", -- R-type
                                "000000000000000", -- LUI
                                "000000000000000",
                                "000000000000000",
                                "000000000000000",
                                "000000000000000", 
                                "000000000000000", -- BEQ
                                "000000000000000", -- JAL
                                "000000000000000",
                                "000000000000000");
                                
                                
  signal IR_opcode : std_logic_vector(OP_CODE_SIZE -1 downto 0);  -- OpCode part of IR
  signal IR_func : std_logic_vector(FUNC_SIZE downto 0);   -- Func part of IR
  signal cw   : std_logic_vector(CW_SIZE - 1 downto 0); -- full control word read from cw_mem


  -- control word is shifted to the correct stage
  signal cw1 : std_logic_vector(CW_SIZE -1 downto 0); -- first stage
  signal cw2 : std_logic_vector(CW_SIZE - 1 - 2  downto 0); -- second stage
  signal cw3 : std_logic_vector(CW_SIZE - 1 - 6  downto 0); -- third stage
  signal cw4 : std_logic_vector(CW_SIZE - 1 - 12 downto 0); -- fourth stage
  signal cw5 : std_logic_vector(CW_SIZE -1 - 17 downto 0); -- fifth stage

  signal aluOpcode_i: aluOp := NOP; --NOP defined in package
  signal aluOpcode1: aluOp := NOP;
  signal aluOpcode2: aluOp := NOP;
  signal aluOpcode3: aluOp := NOP;


 
begin  -- cu_rtl

  IR_opcode(5 downto 0) <= IR_IN(6  downto 0);
  IR_func(10 downto 0)  <= IR_IN(14 downto 12);

  -- for the set of instructions considered these are the bits that identifies
  -- them univocally
  cw <= cw_mem(conv_integer(IR_opcode(5 downto 3) & IR_opcode(1)));


  -- stage one control signals
  IR_LATCH_EN  <= cw1(CW_SIZE - 1);
  NPC_LATCH_EN <= cw1(CW_SIZE - 2);
  
  -- stage two control signals
  Reg1_LATCH_EN   <= cw2(CW_SIZE - 3);
  Reg2_LATCH_EN   <= cw2(CW_SIZE - 4);
  RegIMM_LATCH_EN <= cw2(CW_SIZE - 5);
  RegD_LATCH_EN   <= cw2(CW_SIZE - 6);
  
  -- stage three control signals
  MUX_SEL             <= cw3(CW_SIZE - 7);
  ADD_LATCH_EN        <= cw3(CW_SIZE - 8);
  ALU_OUTREG_LATCH_EN <= cw3(CW_SIZE - 9);
  Reg_LATCH_EN        <= cw3(CW_SIZE - 10);
  EQ_COND             <= cw3(CW_SIZE - 11);
  RegD1_LATCH_EN      <= cw3(CW_SIZE - 12);
  -- stage four control signals
  MEM_WE              <= cw4(CW_SIZE - 13);
  DATA_MEM_LATCH_EN   <= cw4(CW_SIZE - 14);
  BYPASS_MEM_LATCH_EN <= cw4(CW_SIZE - 15);
  JUMP_EN             <= cw4(CW_SIZE - 16);
  RegD2_LATCH_EN      <= cw4(CW_SIZE - 17);
  
  -- stage five control signals
  WB_MUX_SEL <= cw5(CW_SIZE - 18);
  RF_WE      <= cw5(CW_SIZE - 19);


  -- process to pipeline control words
  CW_PIPE: process (Clk, Rst)
  begin  -- process Clk
    if Rst = '0' then                   -- asynchronous reset (active low)
      cw1 <= (others => '0');
      cw2 <= (others => '0');
      cw3 <= (others => '0');
      cw4 <= (others => '0');
      cw5 <= (others => '0');
      aluOpcode1 <= NOP;
      aluOpcode2 <= NOP;
      aluOpcode3 <= NOP;
    elsif Clk'event and Clk = '1' then  -- rising clock edge
      cw1 <= cw;
      cw2 <= cw1(CW_SIZE - 1 - 2 downto 0);
      cw3 <= cw2(CW_SIZE - 1 - 5 downto 0);
      cw4 <= cw3(CW_SIZE - 1 - 9 downto 0);
      cw5 <= cw4(CW_SIZE -1 - 13 downto 0);

      aluOpcode1 <= aluOpcode_i;
      aluOpcode2 <= aluOpcode1;
      aluOpcode3 <= aluOpcode2;
    end if;
  end process CW_PIPE;

  ALU_OPCODE <= aluOpcode3;

  -- purpose: Generation of ALU OpCode
  -- type   : combinational
  -- inputs : IR_i
  -- outputs: aluOpcode
   ALU_OP_CODE_P : process (IR_opcode, IR_func)
   begin  -- process ALU_OP_CODE_P
	case IR_opcode is
	        -- R type
		when "0110011" =>
			case IR_func is
				when "000" => aluOpcode_i <= ADD;
				when "100" => aluOpcode_i <= EXOR;
                                when "010" => aluOpcode_i <= SLT;
				when others => aluOpcode_i <= NOP;
			end case;
                -- I type
		when "0010011" =>
                        case IR_funct is
                                when "000" => aluOpcode_i <= ADDI;
                                when "101" => aluOpcode_i <= SRAI;
                                when "111" => aluOpcode_i <= ANDI;
                                when others => aluOpcode_i <= NOP;
                        end case;
                -- BEQ
		when "1100011" => aluOpcode_i <= BEQ;
                -- LW
		when "0000011" => aluOpcode_i <= LW; 
                -- SW
                when "0100011" => aluOpcode_i <= SW;
                -- JAL
                when "1101111" => aluOpcode_i <= JAL;
                -- AUIPC
                when "0010111" => aluOpcode_i <= AUIPC;
                -- LUI
                when "0110111" => aluOpcode_i <= LUI;
                                  
		when others => aluOpcode_i <= NOP;
	 end case;
	end process ALU_OP_CODE_P;


end CU_hw;


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.RISCV_package.all;
use ieee.numeric_std.all;

entity CU is
  --generic (
    --MICROCODE_MEM_SIZE :     integer := 16;  -- Microcode Memory Size
    --FUNC_SIZE          :     integer := 3;  -- Func Field Size for R-Type Ops
    --OP_CODE_SIZE       :     integer := 7;  -- Op Code Size
    --ALU_OPC_SIZE       :     integer := 4;  -- ALU Op Code Word Size
    --IR_SIZE            :     integer := 32;  -- Instruction Register Size    
    --CW_SIZE            :     integer := 20);  -- Control Word Size
  port (
    Clk                : in  std_logic;  -- Clock
    Rst                : in  std_logic;  -- Reset:Active-Low
    -- Instruction Register
    IR_IN              : in  std_logic_vector(31 downto 0);
    
    -- IF Control Signal
    --IR_LATCH_EN        : out std_logic;  -- Instruction Register Latch Enable
    --NPC_LATCH_EN       : out std_logic;
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

end CU;

architecture CU_HW of CU is
  type mem_array is array (integer range 0 to 15) of std_logic_vector(19 downto 0);
  signal cw_mem : mem_array := ("10111101001011001011", -- LW
                                "00100000000000000000",  
                                "10111101001000101001", -- I-type  
                                "00111010001000001111", -- AUIPC
                                "11110101100100000000", -- SW
                                "00000000000000000000",
                                "11101001001000101001", -- R-type
                                "00111101001000101001", -- LUI
                                "00000000000000000000",
                                "00000000000000000000",
                                "00000000000000000000",
                                "00000000000000000000", 
                                "11110010010000010000", -- BEQ
                                "00111010011000011101", -- JAL
                                "00000000000000000000",
                                "00000000000000000000");
                          
                                                        
  signal IR_opcode : std_logic_vector(6 downto 0);  -- OpCode part of IR
  signal IR_func : std_logic_vector(2 downto 0);   -- Func part of IR
  --signal cw   : std_logic_vector(19 downto 0); -- full control word read from cw_mem


  -- control word is shifted to the correct stage
  --signal cw1 : std_logic_vector(19 downto 0); -- first stage
  signal cw2 : std_logic_vector(19 downto 0); -- second stage
  signal cw3 : std_logic_vector(14 downto 0); -- third stage
  signal cw4 : std_logic_vector(8 downto 0); -- fourth stage
  signal cw5 : std_logic_vector(2 downto 0); -- fifth stage

  signal aluOpcode_i: aluOp := NOP; --NOP defined in package
  signal aluOpcode1: aluOp := NOP;
 --signal aluOpcode2: aluOp := NOP;
 --signal aluOpcode3: aluOp := NOP;
 
begin  -- cu_rtl

  IR_opcode <= IR_IN(6  downto 0);
  IR_func  <= IR_IN(14 downto 12);

  -- for the set of instructions considered, these are the bits that identifies
  -- them univocally
  --cw <= cw_mem(to_integer(unsigned'(IR_opcode(6 downto 4) & IR_opcode(2))));
  --cw <= cw_mem(to_integer(unsigned'(IR_opcode(6) & IR_opcode(5) & IR_opcode(4) & IR_opcode(2))));
  --cw2 <= cw_mem(to_integer(unsigned'(IR_opcode(6) & IR_opcode(5) & IR_opcode(4) & IR_opcode(2))));

  -- stage one control signals
  --IR_LATCH_EN  <= cw1(CW_SIZE - 1);
  --NPC_LATCH_EN <= cw1(CW_SIZE - 2);
  
  -- stage two control signals
  Reg1_LATCH_EN   <= cw2(19);
  Reg2_LATCH_EN   <= cw2(18);
  PC_LATCH_EN     <= cw2(17);
  RegIMM_LATCH_EN <= cw2(16);
  RegD_LATCH_EN   <= cw2(15);
  
  -- stage three control signals
  MUX_SEL             <= cw3(14);
  ADD_LATCH_EN        <= cw3(13);
  ALU_OUTREG_LATCH_EN <= cw3(12);
  Reg_LATCH_EN        <= cw3(11);
  EQ_COND             <= cw3(10);
  RegD1_LATCH_EN      <= cw3(9);
  -- stage four control signals
  MEM_WE              <= cw4(8);
  MEM_RE              <= cw4(7);
  DATA_MEM_LATCH_EN   <= cw4(6);
  BYPASS_MEM_LATCH_EN <= cw4(5);
  JUMP_EN             <= cw4(4);
  RegD2_LATCH_EN      <= cw4(3);
  
  -- stage five control signals
  WB_MUX_SEL1 <= cw5(2);
  WB_MUX_SEL2 <= cw5(1);
  RF_WE       <= cw5(0);
  
  cw2 <= cw_mem(to_integer(unsigned'(IR_opcode(6) & IR_opcode(5) & IR_opcode(4) & IR_opcode(2))));
  
  -- process to pipeline control words
  CW_PIPE: process (Clk, Rst)
  begin  -- process Clk
    if Rst = '0' then                   -- asynchronous reset (active low)
      --cw1 <= (others => '0');
      cw3 <= (others => '0');
      cw4 <= (others => '0');
      cw5 <= (others => '0');
      aluOpcode1 <= NOP;
      --aluOpcode2 <= NOP;
     -- aluOpcode3 <= NOP;
   
     
    elsif Clk'event and Clk = '1' then  -- rising clock edge
      --cw1 <= cw;                          
      --cw2 <= cw(CW_SIZE-1 - 2 downto 0);
     -- cw2 <= cw2_var;
      cw3 <= cw2(14 downto 0);   
      cw4 <= cw3(8 downto 0); 
      cw5 <= cw4(2 downto 0); 

      aluOpcode1 <= aluOpcode_i;
      --aluOpcode2 <= aluOpcode1;
      --aluOpcode3 <= aluOpcode2;
    end if;
  end process CW_PIPE;

  ALU_OPCODE <= aluOpcode1;

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
                        case IR_func is
                                when "000" => aluOpcode_i <= ADD;
                                when "101" => aluOpcode_i <= SRAI;
                                when "111" => aluOpcode_i <= ANDI;
                                when "011" => aluOpcode_i <= ABSV; --replacing the SLTIU instr. of the RV32I
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
                --when "0010111" => aluOpcode_i <= AUIPC;
                -- LUI
                when "0110111" => aluOpcode_i <= LUI;
                                  
		when others => aluOpcode_i <= NOP;
	 end case;
	end process ALU_OP_CODE_P;


end CU_hw;

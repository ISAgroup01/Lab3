library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.RISCV_package.all;
use ieee.numeric_std.all;

entity TB_CU is
end entity;
architecture TEST of TB_CU is
  
  component CU is
    generic (
      MICROCODE_MEM_SIZE :     integer := 16;  -- Microcode Memory Size
      FUNC_SIZE          :     integer := 3;  -- Func Field Size for R-Type Ops
      OP_CODE_SIZE       :     integer := 7;  -- Op Code Size
      ALU_OPC_SIZE       :     integer := 4;  -- ALU Op Code Word Size
      IR_SIZE            :     integer := 32;  -- Instruction Register Size    
      CW_SIZE            :     integer := 21);  -- Control Word Size
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
      DATA_MEM_LATCH_EN   : out std_logic;
      BYPASS_MEM_LATCH_EN : out std_logic;
      JUMP_EN             : out std_logic;
      RegD2_LATCH_EN      : out std_logic;

      -- WB Control signals
      WB_MUX_SEL1         : out std_logic;  -- Write Back MUX Sel
      WB_MUX_SEL2         : out std_logic;  -- Write Back MUX Sel
      RF_WE              : out std_logic);  -- Register File Write Enable

  end component;

  signal  sig_Clk, sig_Rst, sig_IR_LATCH_EN, sig_NPC_LATCH_EN, sig_Reg1_LATCH_EN, sig_Reg2_LATCH_EN, sig_PC_LATCH_EN, sig_RegIMM_LATCH_EN, sig_RegD_LATCH_EN, sig_MUX_SEL, sig_ADD_LATCH_EN, sig_ALU_OUTREG_LATCH_EN, sig_Reg_LATCH_EN, sig_EQ_COND, sig_RegD1_LATCH_EN, sig_MEM_WE, sig_DATA_MEM_LATCH_EN, sig_BYPASS_MEM_LATCH_EN, sig_JUMP_EN, sig_RegD2_LATCH_EN, sig_WB_MUX_SEL1, sig_WB_MUX_SEL2, sig_RF_WE : std_logic := '0';

  signal sig_ALU_OPCODE : aluOP;

  signal sig_IR_IN : std_logic_vector(31  downto 0); -- defined without generic
                                                     -- expression

  begin

  CU_instance: CU port map (Clk                  => sig_Clk,
                            Rst                  => sig_Rst,    
   
                            IR_IN                => sig_IR_IN,
    
      
                            IR_LATCH_EN          => sig_IR_LATCH_EN,  
                            NPC_LATCH_EN         => sig_NPC_LATCH_EN,
                                        
                            Reg1_LATCH_EN        => sig_Reg1_LATCH_EN,
                            Reg2_LATCH_EN        => sig_Reg2_LATCH_EN,
                            PC_LATCH_EN          => sig_PC_LATCH_EN,
                            RegIMM_LATCH_EN      => sig_RegIMM_LATCH_EN,
                            RegD_LATCH_EN        => sig_RegD_LATCH_EN,

                            MUX_SEL              => sig_MUX_SEL,
                            ADD_LATCH_EN         => sig_ADD_LATCH_EN,
                            ALU_OUTREG_LATCH_EN  => sig_ALU_OUTREG_LATCH_EN,
                            Reg_LATCH_EN         => sig_Reg_LATCH_EN,
                            EQ_COND              => sig_EQ_COND,
                            RegD1_LATCH_EN       => sig_RegD1_LATCH_EN,

                            ALU_OPCODE           => sig_ALU_OPCODE,
    
                            MEM_WE               =>  sig_MEM_WE,
                            DATA_MEM_LATCH_EN    => sig_DATA_MEM_LATCH_EN,
                            BYPASS_MEM_LATCH_EN  => sig_BYPASS_MEM_LATCH_EN,
                            JUMP_EN              => sig_JUMP_EN,
                            RegD2_LATCH_EN       => sig_RegD2_LATCH_EN,

                            WB_MUX_SEL1          => sig_WB_MUX_SEL1,  
                            WB_MUX_SEL2          => sig_WB_MUX_SEL2,  
                            RF_WE                => sig_RF_WE);

  sig_Rst <= '1';

  sig_IR_IN <= x"00000063";

  CLK_PROCESS : process
       begin
         
       sig_Clk <= '0';

       wait for 10 ns;

       sig_Clk <= '1';

       wait for 10 ns;

     end process;

end architecture;

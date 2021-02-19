library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use std.textio.all;
use IEEE.std_logic_textio.all;
use WORK.RISCV_package.all;

entity TB_RISCV is
end entity;


architecture TB of TB_RISCV is

  component RISC is
	port(
		RISC_CLK      : in std_logic;
		RISC_RST      : in std_logic;
		I_MEM_read    : in  std_logic_vector(nb-1 downto 0);
		I_MEM_address : out std_logic_vector(nb-1 downto 0);
		D_MEM_read    : in  std_logic_vector(nb-1 downto 0);
		D_MEM_RE      : out std_logic;
		D_MEM_WE      : out std_logic;
		D_MEM_address : out std_logic_vector(nb-1 downto 0);
		D_MEM_write   : out std_logic_vector(nb-1 downto 0));
  end component;

  signal sig_RISC_CLK, sig_RISC_RST: std_logic := '0';
  signal sig_D_MEM_WE: std_logic;
  signal sig_D_MEM_RE: std_logic;
  signal sig_I_MEM_read, sig_D_MEM_read, sig_D_MEM_write: std_logic_vector(nb - 1 downto 0) := (others => '0');

  signal sig_D_MEM_address : std_logic_vector(nb - 1 downto 0);
  signal sig_I_MEM_address : std_logic_vector(nb - 1 downto 0);


  
  type MEM_112  is array (integer range 0 to 111) of std_logic_vector(31 downto 0);
  
  type MEM_32  is array (integer range 0 to 31) of std_logic_vector(31 downto 0);
  
  signal data_mem : MEM_32 := (x"00000000", -- 10
                                x"00000000",
                                x"00000000",
                                x"00000000",
                                x"ffffffd1", -- -47
                                x"00000000",
                                x"00000000",
                                x"00000000",
                                x"00000016", -- 22
                                x"00000000",
                                x"00000000",
                                x"00000000",
                                x"fffffffd", -- -3
                                x"00000000",
                                x"00000000",
                                x"00000000",
                                x"0000000f", -- 15
                                x"00000000",
                                x"00000000",
                                x"00000000",
                                x"0000001b", -- 27
                                x"00000000",
                                x"00000000",
                                x"00000000",
                                x"fffffffc", -- -4
                                x"00000000",
                                x"00000000",
                                x"00000000",
                                x"00000000",
                                x"00000000",
                                x"00000000",
                                x"00000000");

  signal instruction_mem : MEM_112 := (
				                           x"00000000", --no instr, here will be implemented the reset
				                           x"00000000",
                                   x"00000000",
                                   x"00000000",
				                           
				                           --x"00700813", --addi
				                           x"02080863", --beq
				                           x"00000000",
                                   x"00000000",
                                   x"00000000",
                                  
                                   
                                   
                                   --x"ffffd217", --auipc
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   
                                   --x"ffc20213", -- addi
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   
                                   
                                   --x"ffffd297", --auipc
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   
                                   
                                   --x"01028293", --addi
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   
                                  
                                   --x"400006b7", --lui
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   
                                   --x"fff68693", --addi
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   
                                   --x"02080863", --beq
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   
                                   --x"00022403", --lw
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                  
                                   --x"41f45493", --srai
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   
                                   --x"00944533", --xor
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   
                                   --x"0014f493", --andi
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   
                                   --x"00950533", --add
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   
                                   --x"00420213", --addi
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   
                                   --x"fff80813", --addi
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   
                                   --x"00d525b3", --slt
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   
                                   x"fc058ee3", --beq
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   
                                   x"000506b3", --add
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   
                                   x"fd5ff0ef", --jal
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   
                                   x"00d2a023", --sw
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   
                                   x"000000ef", --jal
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   
                                   x"00000013", --addi
				                           x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000", 
				                           x"00000000",
                                   x"00000000",
                                   x"00000000",
				                           x"00000000", 
				                           x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000", 
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000", 
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000", 
                                   x"00000000",
                                   x"00000000",
                                   x"00000000");

  begin

  RISC_V : RISC port map(RISC_CLK       => sig_RISC_CLK,
                         RISC_RST       => sig_RISC_RST,
                         I_MEM_read     => sig_I_MEM_read,
                         I_MEM_address  => sig_I_MEM_address,
                         D_MEM_read     => sig_D_MEM_read,
                         D_MEM_WE       => sig_D_MEM_WE,
                         D_MEM_address  => sig_D_MEM_address,
                         D_MEM_write    => sig_D_MEM_write);
                         
                           
  INSTRUCTION_PROC : process(sig_I_MEM_address)
    begin
      
      sig_I_MEM_read <= instruction_mem(to_integer(unsigned(sig_I_MEM_address)));
     
      
    end process;

-------------------------------------------------------------------------------------------------------------	 
  DATA_MEM_PROC : process(sig_D_MEM_address)
    
    begin
      
    if sig_D_MEM_RE = '1' then --read from data mem
      
       sig_D_MEM_read <= data_mem(to_integer(unsigned(sig_D_MEM_address)));
    
   --else
     
   end if;
    
	  
	  if sig_D_MEM_WE = '1' then --write on data mem (and then on file)
            
       data_mem(to_integer(unsigned(sig_D_MEM_address))) <= sig_D_MEM_write;
		
     --else  
      
     end if;

    
     end process;

---------------------------------------------------------------------------------------------------------------	  
     CLK_PROCESS : process
       begin
  
       sig_RISC_CLK <= '0';
       wait for 10 ns;

       sig_RISC_CLK <= '1';
       wait for 10 ns;

     end process;
	  
---------------------------------------------------------------------------------------------------------------	  

   RST_PROCESS : process
    begin
       sig_RISC_RST <= '0';
        wait for 15 ns;
        sig_RISC_RST <= '1';
        wait;
    end process;
end TB;



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
		D_MEM_WE      : out std_logic;
		D_MEM_address : out std_logic_vector(nb-1 downto 0);
		D_MEM_write   : out std_logic_vector(nb-1 downto 0));
  end component;

  signal sig_RISC_CLK, sig_RISC_RST, sig_D_MEM_WE: std_logic := '0';
  signal sig_I_MEM_read, sig_I_MEM_address, sig_D_MEM_read, sig_D_MEM_address, sig_D_MEM_write: std_logic_vector(nb - 1 downto 0) := (others => '0');

  
  type MEM_89  is array (integer range 0 to 88) of std_logic_vector(31 downto 0);
  
  type MEM_2ToPower32  is array (integer range 0 to (2**32)-1) of std_logic_vector(31 downto 0);
  
  signal data_mem : MEM_2ToPower32 := (others => (others => '0'));

  signal instruction_mem : MEM_89 := (
				   x"00700813", --addi
				   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"0FC10217", --auipc
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"FFC20213", -- addi
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"0FC10297", --auipc
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"01028293", --addi
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"400006b7", --lui
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"FFF68693", --addi
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"02080863", --beq
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00022403", --lw
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"41F45493", --srai
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00944533", --xor
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"0014F493", --andi
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00950533", --add
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00420213", --addi
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"FFF80813", --addi
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00D525B3", --slt
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"FC058EE3", --beq
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"000506B3", --add
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"FD5FF0EF", --jal
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00D2A023", --sw
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"000000EF", --jal
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00000013", --addi
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
  
  -----------------------------------------------------------------------------------------------------------
  --Data memory initialization
  
  --Write data on D_RAM (v vector = [10, -47, 22, -3, 15, 27, -4])
  data_mem(to_integer(unsigned(x"10010000")) <= x"0000000A"; --write 10
  data_mem(to_integer(unsigned(x"10010004")) <= x="ffffffd1"; --write -47
  data_mem(to_integer(unsigned(x"10010008")) <= x="00000016"; --write 22
  data_mem(to_integer(unsigned(x"1001000c")) <= x="fffffffd"; --write -3
  data_mem(to_integer(unsigned(x"10010010")) <= x="0000000f"; --write 15
  data_mem(to_integer(unsigned(x"10010014")) <= x="0000001b"; --write 27
  data_mem(to_integer(unsigned(x"10010018")) <= x="fffffffc"; --write -4
  
    --Write data on D_RAM (m value = 0)
  data_mem(to_integer(unsigned(x"1001001c")) <= x"00000000"; --write 0

 ------------------------------------------------------------------------------------------------------------ 
  INSTRUCTION_PROC : process(sig_I_MEM_address)
    begin

     sig_I_MEM_read <= instruction_mem(to_integer(unsigned(sig_I_MEM_address)));
      
    end process;

-------------------------------------------------------------------------------------------------------------	 
  DATA_MEM_PROC : process(sig_D_MEM_address)
    
    variable v_oline: line;
    file fp: text open write_mode is "../sim/DATA_MEMORY.txt"; 
    begin
	  
	  if sig_D_MEM_WE = '0' then  --read from data mem
            
       sig_D_MEM_read <= data_mem(to_integer(unsigned(sig_D_MEM_address);
		
     else  --write on data mem (and then on file)
		
	 data_mem(to_integer(unsigned(sig_D_MEM_address))) <= sig_D_MEM_write;
		
       write(v_oline, sig_D_MEM_write);
       writeline(fp, v_oline);

       write(v_oline, sig_D_MEM_address);
       writeline(fp, v_oline);

     end if;

     file_close(fp);
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
        sig_RISC_RST <= '0', ;
        wait for 10 ns;
        sig_RISC_RST <= '1';
        wait;
    end process;
end TB;



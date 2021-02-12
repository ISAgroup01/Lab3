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


  type ROM  is array (integer range 0 to 84) of std_logic_vector(31 downto 0);
  signal data_mem : ROM := (others => (others => '0'));

  signal instruction_mem : ROM := (x"00700813",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"0FC10217",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"FFC20213",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"0FC10297",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"01028293",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"400006b7",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"FFF68693",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"02080863",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00022403",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"41F45493",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00944533",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"0014F493",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00950533",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00420213",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"FFF80813",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00D525B3",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"FC058EE3",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"000506B3",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"FD5FF0EF",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00D2A023",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"000000EF",
                                   x"00000000",
                                   x"00000000",
                                   x"00000000",
                                   x"00000013");

  begin

  RISC_V : RISC port map(RISC_CLK       => sig_RISC_CLK,
                         RISC_RST       => sig_RISC_RST,
                         I_MEM_read     => sig_I_MEM_read,
                         I_MEM_address  => sig_I_MEM_address,
                         D_MEM_read     => sig_D_MEM_read,
                         D_MEM_WE       => sig_D_MEM_WE,
                         D_MEM_address  => sig_D_MEM_address,
                         D_MEM_write    => sig_D_MEM_write);
  --Write data on D_RAM
  data_mem(0) <= x"00000000";
  INSTRUCTION_PROC : process(sig_I_MEM_address)
    begin

     sig_I_MEM_read <= instruction_mem(to_integer(unsigned(sig_I_MEM_address)));
      
    end process;

  DATE_MEM_PROC : process(sig_D_MEM_address)
    
    variable v_oline: line;
    file fp: text open write_mode is "../sim/DATA_MEMORY.txt"; 
    begin
     --file_open(fp, "DATA_MEMORY.txt", write_mode);
     if sig_D_MEM_WE = '0' then
       sig_D_MEM_read <= x"0000000A";
     else
       write(v_oline, sig_D_MEM_write);
       writeline(fp, v_oline);

       write(v_oline, sig_D_MEM_address);
       writeline(fp, v_oline);

     end if;

     file_close(fp);
     end process;

     CLK_PROCESS : process
       begin
         
       sig_RISC_CLK <= '0';

       wait for 10 ns;

       sig_RISC_CLK <= '1';

       wait for 10 ns;

     end process;

    RST_PROCESS : process
      begin
        sig_RISC_RST <= '0';
        wait for 10 ns;
        sig_RISC_RST <= '1';
        wait;
    end process;
end TB;



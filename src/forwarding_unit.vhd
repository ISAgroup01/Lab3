library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.RISCV_package.all;
use ieee.numeric_std.all;

entity FU is

  port(  reg1 : in std_logic_vector (4 downto 0);
         reg2 : in std_logic_vector (4 downto 0);
         regd : in std_logic_vector (4 downto 0);
         forward1: out std_logic;
         forward2: out std_logic);
        
end entity

architecture FU_BEHAVIOR of FU is

  signal sig_forward1, sig_forward2 : std_logic := '0';
  
  begin

    forward1 <= sig_forward1;
    forward2 <= sig_forward2;
    
  FWD: process(reg1, reg2, regD)

         if reg1 = regD then
             sig_forward1 <= '1';
         else
             sig_forward1 <= '0';
         end if;
         
         if reg2 = regd then
             sig_forward2 <= '1';
         else
             sig_forward2 <= '0';
    
       end process FWD;
end architecture;

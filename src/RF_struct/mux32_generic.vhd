library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux32_generic is

  generic (n : integer := 32);
  Port(
    mux_in0    : in  std_logic_vector(n-1 downto 0);
    mux_in1    : in  std_logic_vector(n-1 downto 0);
    mux_in2    : in  std_logic_vector(n-1 downto 0);
    mux_in3    : in  std_logic_vector(n-1 downto 0);
    mux_in4    : in  std_logic_vector(n-1 downto 0);
    mux_in5    : in  std_logic_vector(n-1 downto 0);
    mux_in6    : in  std_logic_vector(n-1 downto 0);
    mux_in7    : in  std_logic_vector(n-1 downto 0);
    mux_in8    : in  std_logic_vector(n-1 downto 0);
    mux_in9    : in  std_logic_vector(n-1 downto 0);

    mux_in10    : in  std_logic_vector(n-1 downto 0);
    mux_in11    : in  std_logic_vector(n-1 downto 0);
    mux_in12    : in  std_logic_vector(n-1 downto 0);
    mux_in13    : in  std_logic_vector(n-1 downto 0);
    mux_in14    : in  std_logic_vector(n-1 downto 0);
    mux_in15    : in  std_logic_vector(n-1 downto 0);
    mux_in16    : in  std_logic_vector(n-1 downto 0);
    mux_in17    : in  std_logic_vector(n-1 downto 0);
    mux_in18    : in  std_logic_vector(n-1 downto 0);
    mux_in19    : in  std_logic_vector(n-1 downto 0);

    mux_in20    : in  std_logic_vector(n-1 downto 0);
    mux_in21    : in  std_logic_vector(n-1 downto 0);
    mux_in22    : in  std_logic_vector(n-1 downto 0);
    mux_in23    : in  std_logic_vector(n-1 downto 0);
    mux_in24    : in  std_logic_vector(n-1 downto 0);
    mux_in25    : in  std_logic_vector(n-1 downto 0);
    mux_in26    : in  std_logic_vector(n-1 downto 0);
    mux_in27    : in  std_logic_vector(n-1 downto 0);
    mux_in28    : in  std_logic_vector(n-1 downto 0);
    mux_in29    : in  std_logic_vector(n-1 downto 0);

    mux_in30    : in  std_logic_vector(n-1 downto 0);
    mux_in31    : in  std_logic_vector(n-1 downto 0);

    mux_sel    : in  std_logic_vector(4 downto 0);
    mux_out    : out std_logic_vector(n-1 downto 0)
  );
end entity;

architecture BEHAVIOR of mux32_generic is
	begin
	process(mux_sel)
	begin
	    case mux_sel is
    	    when std_logic_vector(to_unsigned(0, 5)) => mux_out <= mux_in0;
    	    when std_logic_vector(to_unsigned(1, 5)) => mux_out <= mux_in1;
    	    when std_logic_vector(to_unsigned(2, 5)) => mux_out <= mux_in2;
    	    when std_logic_vector(to_unsigned(3, 5)) => mux_out <= mux_in3;
    	    when std_logic_vector(to_unsigned(4, 5)) => mux_out <= mux_in4;
          when std_logic_vector(to_unsigned(5, 5)) => mux_out <= mux_in5;
          when std_logic_vector(to_unsigned(6, 5)) => mux_out <= mux_in6;
          when std_logic_vector(to_unsigned(7, 5)) => mux_out <= mux_in7;
          when std_logic_vector(to_unsigned(8, 5)) => mux_out <= mux_in8;
          when std_logic_vector(to_unsigned(9, 5)) => mux_out <= mux_in9;

          when std_logic_vector(to_unsigned(10, 5)) => mux_out <= mux_in10;
    	    when std_logic_vector(to_unsigned(11, 5)) => mux_out <= mux_in11;
    	    when std_logic_vector(to_unsigned(12, 5)) => mux_out <= mux_in12;
    	    when std_logic_vector(to_unsigned(13, 5)) => mux_out <= mux_in13;
    	    when std_logic_vector(to_unsigned(14, 5)) => mux_out <= mux_in14;
          when std_logic_vector(to_unsigned(15, 5)) => mux_out <= mux_in15;
          when std_logic_vector(to_unsigned(16, 5)) => mux_out <= mux_in16;
          when std_logic_vector(to_unsigned(17, 5)) => mux_out <= mux_in17;
          when std_logic_vector(to_unsigned(18, 5)) => mux_out <= mux_in18;
          when std_logic_vector(to_unsigned(19, 5)) => mux_out <= mux_in19;

          when std_logic_vector(to_unsigned(20, 5)) => mux_out <= mux_in20;
    	    when std_logic_vector(to_unsigned(21, 5)) => mux_out <= mux_in21;
    	    when std_logic_vector(to_unsigned(22, 5)) => mux_out <= mux_in22;
    	    when std_logic_vector(to_unsigned(23, 5)) => mux_out <= mux_in23;
    	    when std_logic_vector(to_unsigned(24, 5)) => mux_out <= mux_in24;
          when std_logic_vector(to_unsigned(25, 5)) => mux_out <= mux_in25;
          when std_logic_vector(to_unsigned(26, 5)) => mux_out <= mux_in26;
          when std_logic_vector(to_unsigned(27, 5)) => mux_out <= mux_in27;
          when std_logic_vector(to_unsigned(28, 5)) => mux_out <= mux_in28;
          when std_logic_vector(to_unsigned(29, 5)) => mux_out <= mux_in29;

          when std_logic_vector(to_unsigned(30, 5)) => mux_out <= mux_in30;
          when std_logic_vector(to_unsigned(31, 5)) => mux_out <= mux_in31;

    	    when others => mux_out <= mux_in0;
    	end case;
	end process;
end BEHAVIOR;

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux32to1 is

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

    sel   		 : in  std_logic_vector(4 downto 0);
    S			    : out std_logic_vector(n-1 downto 0)
   );
end entity;

architecture arch of mux32to1 is

	component mux2to1 is
		Generic (N : integer := 32);
		Port(A   :  IN   std_logic_vector(N-1 downto 0);
			  B   :  IN   std_logic_vector(N-1 downto 0);
			  sel :  IN   std_logic;
			  S   :  OUT  std_logic_vector(N-1 downto 0));
	end component;	
	
	type array_32 is array(31 downto 0) of std_logic_vector(n-1 downto 0);
	type array_16 is array (15 downto 0) of std_logic_vector(n-1 downto 0);
	type array_8 is array (7 downto 0) of std_logic_vector(n-1 downto 0);
	type array_4 is array (3 downto 0) of std_logic_vector(n-1 downto 0);
	type array_2 is array (1 downto 0) of std_logic_vector(n-1 downto 0);
	
	signal sig_array_32 : array_32;
	signal sig_array_16 : array_16;
	signal sig_array_8 : array_8;
	signal sig_array_4 : array_4;
	signal sig_array_2 : array_2;
	
	begin
	
	-----------------------------------------------------------------------------------------------------
	--signals
	-----------------------------------------------------------------------------------------------------
	
	sig_array_32(0) <= mux_in0;
	sig_array_32(1) <= mux_in1;
	sig_array_32(2) <= mux_in2;
	sig_array_32(3) <= mux_in3;
	sig_array_32(4) <= mux_in4;
	
	sig_array_32(5) <= mux_in5;
	sig_array_32(6) <= mux_in6;
	sig_array_32(7) <= mux_in7;
	sig_array_32(8) <= mux_in8;
	sig_array_32(9) <= mux_in9;
	
	sig_array_32(10) <= mux_in10;
	sig_array_32(11) <= mux_in11;
	sig_array_32(12) <= mux_in12;
	sig_array_32(13) <= mux_in13;
	sig_array_32(14) <= mux_in14;
	
	sig_array_32(15) <= mux_in15;
	sig_array_32(16) <= mux_in16;
	sig_array_32(17) <= mux_in17;
	sig_array_32(18) <= mux_in18;
	sig_array_32(19) <= mux_in19;
	
	sig_array_32(20) <= mux_in20;
	sig_array_32(21) <= mux_in21;
	sig_array_32(22) <= mux_in22;
	sig_array_32(23) <= mux_in23;
	sig_array_32(24) <= mux_in24;
	
	sig_array_32(25) <= mux_in25;
	sig_array_32(26) <= mux_in26;
	sig_array_32(27) <= mux_in27;
	sig_array_32(28) <= mux_in28;
	sig_array_32(29) <= mux_in29;
	
	sig_array_32(30) <= mux_in30;
	sig_array_32(31) <= mux_in31;
	
	---------------------------------------------------------------------------------------------------
	--port map
	----------------------------------------------------------------------------------------------------
	
	mux_level_1  : for i in 0 to 15 generate
		mux_L1: 		mux2to1 port map(
                  A => sig_array_32(2*i),
                  B => sig_array_32(2*i+1),
                  sel => sel(0),
                  S => sig_array_16(i)
                );
	end generate mux_level_1;
					 
	mux_level_2  : for i in 0 to 7 generate
		mux_L2: 		mux2to1 port map(
                  A => sig_array_16(2*i),
                  B => sig_array_16(2*i+1),
                  sel => sel(1),
                  S => sig_array_8(i)
                );
	end generate mux_level_2;
	
	mux_level_3  : for i in 0 to 3 generate
		mux_L3: 		mux2to1 port map(
                  A => sig_array_8(2*i),
                  B => sig_array_8(2*i+1),
                  sel => sel(2),
                  S => sig_array_4(i)
                );
	end generate mux_level_3;
	
	mux_level_4  : for i in 0 to 1 generate
		mux_L4: 		mux2to1 port map(
                  A => sig_array_4(2*i),
                  B => sig_array_4(2*i+1),
                  sel => sel(3),
                  S => sig_array_2(i)
                );
	end generate mux_level_4;
					 
		mux_L5:		mux2to1 port map(
						A => sig_array_2(0),
                  B => sig_array_2(1),
                  sel => sel(4),
                  S => S
                );
end arch;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY RegFile IS
   PORT(
      ReadRegister1    : IN  std_logic_vector(4 downto 0);
      ReadRegister2    : IN  std_logic_vector(4 downto 0);
      WriteRegister    : IN  std_logic_vector(4 downto 0);
      WriteData        : IN  std_logic_vector(31 downto 0);
      ReadData1        : OUT std_logic_vector(31 downto 0);
      ReadData2        : OUT std_logic_vector(31 downto 0);
      
      RegWrite         : IN  std_logic; --Enable signal
      Reset            : IN std_logic; --active high (1) reset
      Clock            : IN std_logic
   );
END RegFile;

architecture STRUCTURAL of RegFile is
  ------------------------------------------------------------------------------------------------
  --Components
  ------------------------------------------------------------------------------------------------
  component REG is
  	Port (
          REG_IN    :	IN	 std_logic_vector(31 downto 0);
			 REG_EN    :	IN	 std_logic;
			 REG_CLK   :	IN	 std_logic;
          REG_RESET :	IN	 std_logic;
          REG_OUT   :   OUT std_logic_vector (31 downto 0));
  end component;

  component mux32_generic is

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
  end component;

  COMPONENT WriteRegister_logic IS
     PORT(
          WriteRegister   : IN std_logic_vector(4 downto 0);
          WriteData       : IN std_logic_vector(31 downto 0);

          Enable          : in std_logic;

          ToReg0          : OUT std_logic_vector(31 downto 0);
          ToReg1          : OUT std_logic_vector(31 downto 0);
          ToReg2          : OUT std_logic_vector(31 downto 0);
          ToReg3          : OUT std_logic_vector(31 downto 0);
          ToReg4          : OUT std_logic_vector(31 downto 0);
          ToReg5          : OUT std_logic_vector(31 downto 0);
          ToReg6          : OUT std_logic_vector(31 downto 0);
          ToReg7          : OUT std_logic_vector(31 downto 0);
          ToReg8          : OUT std_logic_vector(31 downto 0);
          ToReg9          : OUT std_logic_vector(31 downto 0);

          ToReg10          : OUT std_logic_vector(31 downto 0);
          ToReg11          : OUT std_logic_vector(31 downto 0);
          ToReg12          : OUT std_logic_vector(31 downto 0);
          ToReg13          : OUT std_logic_vector(31 downto 0);
          ToReg14          : OUT std_logic_vector(31 downto 0);
          ToReg15          : OUT std_logic_vector(31 downto 0);
          ToReg16          : OUT std_logic_vector(31 downto 0);
          ToReg17          : OUT std_logic_vector(31 downto 0);
          ToReg18          : OUT std_logic_vector(31 downto 0);
          ToReg19          : OUT std_logic_vector(31 downto 0);

          ToReg20          : OUT std_logic_vector(31 downto 0);
          ToReg21          : OUT std_logic_vector(31 downto 0);
          ToReg22          : OUT std_logic_vector(31 downto 0);
          ToReg23          : OUT std_logic_vector(31 downto 0);
          ToReg24          : OUT std_logic_vector(31 downto 0);
          ToReg25          : OUT std_logic_vector(31 downto 0);
          ToReg26          : OUT std_logic_vector(31 downto 0);
          ToReg27          : OUT std_logic_vector(31 downto 0);
          ToReg28          : OUT std_logic_vector(31 downto 0);
          ToReg29          : OUT std_logic_vector(31 downto 0);

          ToReg30          : OUT std_logic_vector(31 downto 0);
          ToReg31          : OUT std_logic_vector(31 downto 0)
     );
  END Component;

  ------------------------------------------------------------------------------------------------
  --Signals
  ------------------------------------------------------------------------------------------------

  type signal_matx_32_32  is array (31 downto 0) of std_logic_vector(31 downto 0);

  signal sig_2REG_IN  : signal_matx_32_32;
  signal sig_2mux    : signal_matx_32_32;

  ------------------------------------------------------------------------------------------------
  --BEGIN architecture
  ------------------------------------------------------------------------------------------------

  begin

write_logic : WriteRegister_logic port map(WriteRegister => WriteRegister, WriteData => WriteData, Enable => RegWrite,
                                          ToReg0 => sig_2REG_IN(0), ToReg1 => sig_2REG_IN(1), ToReg2 => sig_2REG_IN(2),
                                          ToReg3 => sig_2REG_IN(3), ToReg4 => sig_2REG_IN(4), ToReg5 => sig_2REG_IN(5),
                                          ToReg6 => sig_2REG_IN(6), ToReg7 => sig_2REG_IN(7), ToReg8 => sig_2REG_IN(8),

                                          ToReg9 => sig_2REG_IN(9), ToReg10 => sig_2REG_IN(10), ToReg11 => sig_2REG_IN(11),
                                          ToReg12 => sig_2REG_IN(12), ToReg13 => sig_2REG_IN(13), ToReg14 => sig_2REG_IN(14),
                                          ToReg15 => sig_2REG_IN(15), ToReg16 => sig_2REG_IN(16), ToReg17 => sig_2REG_IN(17),

                                          ToReg18 => sig_2REG_IN(18), ToReg19 => sig_2REG_IN(19), ToReg20 => sig_2REG_IN(20),
                                          ToReg21 => sig_2REG_IN(21), ToReg22 => sig_2REG_IN(22), ToReg23 => sig_2REG_IN(23),
                                          ToReg24 => sig_2REG_IN(24), ToReg25 => sig_2REG_IN(25), ToReg26 => sig_2REG_IN(26),

                                          ToReg27 => sig_2REG_IN(27), ToReg28 => sig_2REG_IN(28), ToReg29 => sig_2REG_IN(29),
                                          ToReg30 => sig_2REG_IN(30), ToReg31 => sig_2REG_IN(31)
                                          );

REG_loop  : for i in 0 to 31 generate
  REG_unit: REG port map  (
                  REG_IN => sig_2REG_IN(i),
                  REG_EN => '1',
                  REG_CLK => Clock,
                  REG_RESET => Reset,
                  REG_OUT => sig_2mux(i)
                );
end generate REG_loop;

MUX1 : mux32_generic port map(
                          mux_in0 => sig_2mux(0), mux_in1 => sig_2mux(1), mux_in2 => sig_2mux(2), mux_in3 => sig_2mux(3), mux_in4 => sig_2mux(4),
                          mux_in5 => sig_2mux(5), mux_in6 => sig_2mux(6), mux_in7 => sig_2mux(7), mux_in8 => sig_2mux(8), mux_in9 => sig_2mux(9),

                          mux_in10 => sig_2mux(10), mux_in11 => sig_2mux(11), mux_in12 => sig_2mux(12), mux_in13 => sig_2mux(13), mux_in14 => sig_2mux(14),
                          mux_in15 => sig_2mux(15), mux_in16 => sig_2mux(16), mux_in17=> sig_2mux(17), mux_in18 => sig_2mux(18), mux_in19 => sig_2mux(19),

                          mux_in20 => sig_2mux(20), mux_in21 => sig_2mux(21), mux_in22 => sig_2mux(22), mux_in23 => sig_2mux(23), mux_in24 => sig_2mux(24),
                          mux_in25 => sig_2mux(25), mux_in26 => sig_2mux(26), mux_in27 => sig_2mux(27), mux_in28 => sig_2mux(28), mux_in29 => sig_2mux(29),

                          mux_in30 => sig_2mux(30), mux_in31 => sig_2mux(31),

                          mux_sel => ReadRegister1, mux_out => ReadData1
                          );

MUX2 : mux32_generic port map(
                          mux_in0 => sig_2mux(0), mux_in1 => sig_2mux(1), mux_in2 => sig_2mux(2), mux_in3 => sig_2mux(3), mux_in4 => sig_2mux(4),
                          mux_in5 => sig_2mux(5), mux_in6 => sig_2mux(6), mux_in7 => sig_2mux(7), mux_in8 => sig_2mux(8), mux_in9 => sig_2mux(9),

                          mux_in10 => sig_2mux(10), mux_in11 => sig_2mux(11), mux_in12 => sig_2mux(12), mux_in13 => sig_2mux(13), mux_in14 => sig_2mux(14),
                          mux_in15 => sig_2mux(15), mux_in16 => sig_2mux(16), mux_in17=> sig_2mux(17), mux_in18 => sig_2mux(18), mux_in19 => sig_2mux(19),

                          mux_in20 => sig_2mux(20), mux_in21 => sig_2mux(21), mux_in22 => sig_2mux(22), mux_in23 => sig_2mux(23), mux_in24 => sig_2mux(24),
                          mux_in25 => sig_2mux(25), mux_in26 => sig_2mux(26), mux_in27 => sig_2mux(27), mux_in28 => sig_2mux(28), mux_in29 => sig_2mux(29),

                          mux_in30 => sig_2mux(30), mux_in31 => sig_2mux(31),

                          mux_sel => ReadRegister2, mux_out => ReadData2
                          );

end architecture;

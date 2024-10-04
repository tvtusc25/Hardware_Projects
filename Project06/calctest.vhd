-- Bruce A. Maxwell
-- Fall 2017
-- CS 232
--
-- test program for the stacker circuit
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calctest is
end entity;

architecture test of calctest is
  constant num_cycles : integer := 90;

  -- this circuit needs a clock and a reset
  signal clk : std_logic := '1';
  signal reset : std_logic;

  -- stacker component
  component calculator
    port (
		clk		 : in	std_logic;
		reset	 	 : in	std_logic;
		b2			 : in std_logic;
		b3			 : in std_logic;
		b4			 : in std_logic;
		op			 : in std_logic_vector(2 downto 0);
		data		 : in std_logic_vector(7 downto 0);
		digit0	 : out std_logic_vector(6 downto 0);
		digit1	 : out std_logic_vector(6 downto 0);
		stackview : out std_logic_vector(3 downto 0);
		stateview: out std_logic_vector(2 downto 0)
    );
  end component;

  -- output signals
  signal digit0, digit1 : std_logic_vector(6 downto 0);
  signal stackview : std_logic_vector(3 downto 0);
  signal stateview : std_logic_vector(2 downto 0);

  -- buttons
  signal op : std_logic_vector(2 downto 0);
  signal b2, b3, b4 : std_logic;
  signal data: std_logic_vector(7 downto 0);

begin

  -- start off with a short reset
  reset <= '0', '1' after 5 ns;

  -- create a clock
  process
  begin
    for i in 1 to num_cycles loop
      clk <= not clk;
      wait for 5 ns;
      clk <= not clk;
      wait for 5 ns;
    end loop;
    wait;
  end process;
  
  
  
  -- 48/(8*(4+(3-1))
  
  -- operations:
  -- mbr = 48
  -- push MBR
  -- mbr = 8
  -- push MBR
  -- mbr = 4
  -- push MBR
  -- mbr = 3
  -- push MBR
  -- mb = 1
  -- pop 3, and MBR = 3-MBR = 3-1 = 2
  -- pop 4, and MBR = 4+MBR = 4+2 = 6
  -- pop 8, and MBR = 8*MBR = 8*6 = 48
  -- pop 48, and MBR = 48/MBR = 48/48 = 1
  
  

  -- clock is in 5ns increments, rising edges on 5, 15, 25, 35, 45..., let 5 cycles
  -- go by before doing anything
  --
  -- We're going to push 48, 8, 4, 3 onto the stack at time 50, 100, 150 and 200,
  -- then put a 1 into the MBR register before popping the three values
  -- off the stack
  data <= "00000000", "00110000" after 50 ns, "00001000" after 100 ns, "00000100" after 150 ns, "00000011" after 200 ns, "00000001" after 250 ns;

  -- put data values into the MBR at 50, 100, 150, 200
  b2 <= '1', '0' after 50 ns, '1' after 60 ns, '0' after 100 ns, '1' after 110 ns, '0' after 150 ns, '1' after 160 ns, '0' after 200 ns, '1' after 210 ns, '0' after 250 ns, '1' after 260 ns;

  -- push 4 values (48, 8, 4, 3) onto the stack using b3 at time 70
  b3 <= '1', '0' after 70 ns, '1' after 80 ns, '0' after 120 ns, '1' after 130 ns, '0' after 170 ns, '1' after 180 ns, '0' after 220 ns, '1' after 230 ns;
  
  -- pop 4 values off the sack using b4 at times 300, 350, 400, 450 should get
  -- 3, 4, 8, 48 in that order
  b4 <= '1', '0' after 300 ns, '1' after 310 ns, '0' after 350 ns, '1' after 360 ns, '0' after 400 ns, '1' after 410 ns, '0' after 450 ns, '1' after 460 ns;

  --sub = 02, add = 06, mult = 30, div = 01
  op <= "001", "000" after 350 ns, "010" after 400 ns, "011" after 450 ns;
  
  -- port map the circuit
  L0: calculator port map(clk, reset, b2, b3, b4, op, data, digit0, digit1, stackview, stateview );

end test;
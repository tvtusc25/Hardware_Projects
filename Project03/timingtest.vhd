-- Bruce A. Maxwell
-- Spring 2013
-- CS 232 Lab 3
-- Test bench for the bright state machine circuit
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- a test bench has no inputs or outputs
entity timingtest is
end timingtest;

-- architecture
architecture test of timingtest is

  -- internal signals for everything we want to send to or receive from the
  -- test circuit
  signal reset, start, react: std_logic;
  signal cycles: std_logic_vector (7 downto 0);
  signal sNum: std_logic_vector (1 downto 0);
  signal red, green: std_logic;
  
  --display
  signal disp0: unsigned(6 downto 0);
  signal disp1: unsigned(6 downto 0);
  
  component hexdisplay
  port(
    A :  IN UNSIGNED(3 downto 0);
    hex: OUT UNSIGNED(6 downto 0)
    );
  end component;
  -- the component statement lets us instantiate a bright circuit
  component timer
    port(
      clk	 : in	std_logic;
		reset	 : in	std_logic;
		start	 : in	std_logic;
		react  : in std_logic;
		sNum	 : out std_logic_vector(1	downto 0);
		cycles : out std_logic_vector(7 downto 0);
		red	 : out std_logic;
		green  : out std_logic
      );
  end component;

  -- signals for making the clock
  constant num_cycles : integer := 50;
  signal clk : std_logic := '1';

begin

  -- these are timed signal assignments to create specific patterns
  reset <= '0', '1' after 20 ns, '0' after 250 ns, '1' after 270 ns;
  start <= '1', '0' after 20 ns, '1' after 50 ns, '0' after 280 ns, '1' after 300 ns;
  react <= '1', '0' after 200 ns, '1' after 220 ns, '0' after 350 ns, '1' after 370 ns;
  

  -- we can use a process and a for loop to generate a clock signal
  process begin
    for i in 1 to num_cycles loop
      clk <= not clk;
      wait for 5 ns;
      clk <= not clk;
      wait for 5 ns;
    end loop;
    wait;
  end process;

  -- this instantiates a bright circuit and sets up the inputs and outputs
  T0: hexdisplay port map(unsigned(cycles(3 downto 0)),disp0);
  T1: hexdisplay port map(unsigned(cycles(7 downto 4)),disp1);
  T2: timer port map (clk, reset, start, react, sNum, cycles, red, green);
end test;
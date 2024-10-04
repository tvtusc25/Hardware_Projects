-- Bruce A. Maxwell
-- Fall 2017
-- CS 232
--
-- test program for the stacker circuit
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stackertest is
end entity;

architecture test of stackertest is
  constant num_cycles : integer := 45;

  -- this circuit needs a clock and a reset
  signal clk : std_logic := '1';
  signal reset : std_logic;

  -- stacker component
  component stacker
    port(reset: in std_logic;
         clock: in std_logic;
         data:  in std_logic_vector(3 downto 0);
         b2:    in std_logic; -- switch values to mbr
         b3:    in std_logic; -- push mbr -> stack
         b4:    in std_logic; -- pop stack -> mbr
         value: out std_logic_vector(3 downto 0);
         stackview: out std_logic_vector(3 downto 0);
         stateview: out std_logic_vector(2 downto 0)
         );
  end component;

  -- output signals
  signal value : std_logic_vector(3 downto 0);
  signal stackview : std_logic_vector(3 downto 0);
  signal stateview : std_logic_vector(2 downto 0);

  -- buttons
  signal b2, b3, b4 : std_logic;
  signal data: std_logic_vector(3 downto 0);

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

  -- clock is in 5ns increments, rising edges on 5, 15, 25, 35, 45..., let 5 cycles
  -- go by before doing anything
  --
  -- We're going to push 1, 2, and 3 onto the stack at time 50, 100, and 150,
  -- then put a "0000" into the MBR register before popping the three values
  -- off the stack
  data <= "0000", "0001" after 50 ns, "0010" after 100 ns, "0011" after 150 ns, "0000" after 190 ns;

  -- put data values into the MBR at 50, 100, 150
  b2 <= '1', '0' after 50 ns, '1' after 60 ns, '0' after 100 ns, '1' after 110 ns, '0' after 150 ns, '1' after 160 ns, '0' after 200 ns, '1' after 210 ns;

  -- push three values (1, 2, 3) onto the stack using b3 at time 70, 120, 170
  b3 <= '1', '0' after 70 ns, '1' after 80 ns, '0' after 120 ns, '1' after 130 ns, '0' after 170 ns, '1' after 180 ns;

  -- pop three values off the sack using b4 at times 220, 280, 340, should get
  -- 3, 2, 1 in that order
  b4 <= '1', '0' after 220 ns, '1' after 230 ns, '0' after 280 ns, '1' after 290 ns, '0' after 340 ns, '1' after 350 ns;

  -- port map the circuit
  L0: stacker port map( reset, clk, data, b2, b3, b4, value, stackview, stateview );

end test;
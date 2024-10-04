-- Stephanie R Taylor
-- Fall 2020
-- CS 232
--
-- test program for the ext light simulation
-- shows how to create a clock using a loop

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity extbench is
end entity;

architecture test of extbench is
  constant num_cycles : integer := 33;  -- run for 40 clock cycles

  -- this circuit needs a clock, enable, and a reset
  -- for the counter
  signal clk    : std_logic := '1';
  signal enable : std_logic;
  signal reset  : std_logic;
  signal f	 : std_logic;
 
  component extension
  port(
  		clk :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC;
		enable :  IN  STD_LOGIC;
		f :  OUT  STD_LOGIC
		);
  end component;

  begin

  -- start off with a short reset
  reset <= '1', '0' after 5 ns;

  enable <= '1';

  -- create a clock
  process begin
    for i in 1 to num_cycles loop
      clk <= not clk;
      wait for 1 ns;
      clk <= not clk;
      wait for 1 ns;
    end loop;
    wait;
  end process;

  -- port map the circuit
  -- Make sure the list of inputs here has signals declared above (all the ones here now have been).
  -- Also make sure the order matches that from the port definition of the ext
  -- component.
  L0: extension port map( clk, reset, enable, f);

end test;



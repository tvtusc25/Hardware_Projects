-- Stephanie R Taylor
-- Fall 2020
-- CS 232
--
-- test program for the traffic light simulation
-- shows how to create a clock using a loop

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity trafficbench is
end entity;

architecture test of trafficbench is
  constant num_cycles : integer := 16;  -- run for 40 clock cycles

  -- this circuit needs a clock, enable, and a reset
  -- for the counter
  signal clk    : std_logic := '1';
  signal enable : std_logic;
  signal reset  : std_logic;

  -- light signals
  signal NSred, NSyellow, NSgreen, EWred, EWyellow, EWgreen: std_logic;

  -- traffic component
  -- YOU MAY NEED TO MODIFY THIS PART!
  -- If the quartus-generated traffic.vhd puts
  -- the input and output signals in a different order, then
  -- you need to copy-paste that order into this file. (Grab
  -- the "port" code.) 
  component traffic
  port(
  		enable :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC;
		clk :  IN  STD_LOGIC;
		NS_R :  OUT  STD_LOGIC;
		NS_G :  OUT  STD_LOGIC;
		NS_Y :  OUT  STD_LOGIC;
		EW_R :  OUT  STD_LOGIC;
		EW_G :  OUT  STD_LOGIC;
		EW_Y :  OUT  STD_LOGIC );
  end component;

  begin

  -- start off with a short reset
  reset <= '1', '0' after 5 ns;

  enable <= '1';

  -- create a clock
  process begin
    for i in 1 to num_cycles loop
      clk <= not clk;
      wait for 5 ns;
      clk <= not clk;
      wait for 5 ns;
    end loop;
    wait;
  end process;

  -- port map the circuit
  -- Make sure the list of inputs here has signals declared above (all the ones here now have been).
  -- Also make sure the order matches that from the port definition of the traffic
  -- component.
  L0: traffic port map( enable, reset, clk, NSred, NSgreen, NSyellow, EWred, EWgreen, EWyellow );

end test;



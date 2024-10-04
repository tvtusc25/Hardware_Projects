-- Stephanie Taylor
-- Fall 2020
-- CS 232 Testbench for 2 7-segment displays

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hexbench2 is
end hexbench2;

architecture one of hexbench2 is

  constant num_cycles : integer := 255;  -- run for 40 clock cycles

  -- this circuit needs a clock, enable, and a reset
  -- for the counter
  signal clk      : std_logic := '1';
  signal reset, enable: std_logic;
  -- signal for count
  signal num : unsigned(7 downto 0);
  -- signals for each hex display
  signal disp0 : unsigned(6 downto 0);
  signal disp1 : unsigned(6 downto 0);

  component hexdisplay
  port(
    A :  IN UNSIGNED(3 downto 0);
    hex: OUT UNSIGNED(6 downto 0)
    );
  end component;
  
  component counter8 is
  port
    (
      clk         : in std_logic;
      reset	  : in std_logic;
      enable	  : in std_logic;
      q  	      : out unsigned(7 downto 0)
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
      wait for 5 ns;
      clk <= not clk;
      wait for 5 ns;
    end loop;
    wait;
  end process;

T0: hexdisplay port map(num(3 downto 0),disp0);
T1: hexdisplay port map(num(7 downto 4),disp1);
T2: counter8 port map(clk,reset,enable,num);

end one;
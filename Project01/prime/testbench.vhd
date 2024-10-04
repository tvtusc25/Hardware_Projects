-- Stephanie Taylor
-- Fall 2020
-- CS 232 Lab 1
-- Test file for the simple circuit in lab 1

library ieee;
use ieee.std_logic_1164.all;

entity testbench is
end testbench;

architecture one of testbench is

  signal a, b, c, d, f: std_logic;

  component prime
  port( 
    A :  IN  STD_LOGIC;
    B :  IN  STD_LOGIC;
    C :  IN  STD_LOGIC;
    D :  IN  STD_LOGIC;
    F :  OUT  STD_LOGIC
    );
  end component;

begin

A <= '0', '1' after 10 ns, '0' after 20 ns, '1' after 50 ns, '0' after 60 ns, '1' after 110 ns, '0' after 130 ns, '1' after 140 ns, '0' after 180 ns;
B <= '0', '1' after 20 ns, '0' after 30 ns, '1' after 70 ns, '0' after 80 ns, '1' after 100 ns, '0' after 110 ns, '1' after 120 ns, '0' after 140 ns, '1' after 150 ns, '0' after 180 ns;
C <= '0', '1' after 30 ns, '0' after 40 ns, '1' after 90 ns, '0' after 120 ns, '1' after 130 ns, '0' after 150 ns, '1' after 160 ns, '0' after 180 ns;
D <= '0', '1' after 40 ns, '0' after 100 ns, '1' after 130 ns, '0' after 160 ns, '1' after 170 ns, '0' after 180 ns;

T0: prime port map(A, B, C, D, F);

end one;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity addbench is
end addbench;

architecture one of addbench is

signal add: std_logic;
signal num1 : unsigned(3 downto 0);
signal num2 : unsigned(3 downto 0);
signal sum  : unsigned(7 downto 0) := "00000000";
signal disp0: unsigned(6 downto 0);
signal disp1: unsigned(6 downto 0);

component addIt
  port(
    A :  IN UNSIGNED(3 downto 0);
	 B :  IN UNSIGNED(3 downto 0);
    C :  OUT UNSIGNED(4 downto 0);
	 add: in std_logic
    );
 end component;
 
component hexdisplay
  port(
    A :  IN UNSIGNED(3 downto 0);
    hex    : OUT UNSIGNED(6 downto 0)
    );
  end component;
 
 begin 
 
 add <= '1', '0' after 75 ns;
 num1 <= "0001" after 0 ns, "0010" after 25 ns, "1001" after 50 ns, "1100" after 75 ns, "1010" after 100 ns, "1111" after 125 ns, "0000" after 150 ns;
 num2 <= "0010" after 0 ns, "0100" after 25 ns, "1000" after 50 ns, "0111" after 75 ns, "1010" after 100 ns,  "1010" after 125 ns,"0000" after 150 ns;
 
 T0: addIt port map(num1, num2, sum(4 downto 0), add);
 T1: hexdisplay port map(sum(3 downto 0), disp0);
 T2: hexdisplay port map(sum(7 downto 4), disp1);
 
 end one;
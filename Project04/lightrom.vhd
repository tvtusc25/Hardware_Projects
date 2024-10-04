library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lightrom is
	port (
			addr  : in std_logic_vector(4 downto 0);
			data	: out std_logic_vector(3 downto 0)
			);
end lightrom;

architecture one of lightrom is 
begin
data <= 
      "0000" when addr = "00000" else -- move 0s to LR  00000000
      "0101" when addr = "00001" else -- bit invert LR  11111111
      "0001" when addr = "00010" else -- shift LR right 01111111
      "0100" when addr = "00011" else -- sub 1 from LR  01111110
      "0001" when addr = "00100" else -- shift LR right 00111111
      "0100" when addr = "00101" else -- sub 1 from LR  00111110
      "0001" when addr = "00110" else -- shift LR right 00011111
      "0100" when addr = "00111" else -- sub 1 from LR  00011110
      "0001" when addr = "01000" else -- shift LR right 00001111
      "0100" when addr = "01001" else -- sub 1 from LR  00001110
      "0001" when addr = "01010" else -- shift LR right 00000111
      "0100" when addr = "01011" else -- sub 1 from LR  00000110
      "0001" when addr = "01100" else -- shift LR right 00000011
      "0100" when addr = "01101" else -- sub 1 from LR  00000010
      "0001" when addr = "01110" else -- shift LR right 00000001
      "0100";
end one;
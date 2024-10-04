library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity hexdisplay is
	port (
			A	 :	in  unsigned(3 downto 0);
			hex : out unsigned(6 downto 0)
			);
end hexdisplay;

architecture test of hexdisplay is			
begin
		hex	<= 
			"1000000" when A = "0000" else
			"1111001" when A = "0001" else
			"0100100" when A = "0010" else
			"0110000" when A = "0011" else
			"0011001" when A = "0100" else
			"0010010" when A = "0101" else
			"0000010" when A = "0110" else
			"1111000" when A = "0111" else
			"0000000" when A = "1000" else
			"0011000" when A = "1001" else
			"0001000" when A = "1010" else
			"0000011" when A = "1011" else
			"1000110" when A = "1100" else
			"0100001" when A = "1101" else
			"0000110" when A = "1110" else
			"0001110" when A = "1111";		

end test;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity addIt is
	port (
			A  : in unsigned(3 downto 0);
			B  : in unsigned(3 downto 0);
			C  : out unsigned(4 downto 0) := "00000";
			add: in std_logic
			);
end addIt;

architecture one of addIt is 
begin
		C <= ('0' & A) + ('0' & B) when (add = '1') else
		('0' & A) - ('0' & B);
end one;
			
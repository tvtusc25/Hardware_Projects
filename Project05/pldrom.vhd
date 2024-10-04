library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pldrom is
	port (
			addr  : in std_logic_vector(4 downto 0);
			data	: out std_logic_vector(9 downto 0)
			);
end pldrom;

architecture one of pldrom is 
begin
  	data <= 
		 "0011100001" when addr = "00000" else -- Move 0001 to ACC high    
		 "0010100000" when addr = "00001" else -- Move 0000 to ACC low
		 "0001000000" when addr = "00010" else -- Move ACC to LR
		 "0100110101" when addr = "00011" else -- Sub 1 from LR
		 "1101100011" when addr = "00100" else -- If LR > 0 branch to 00011
		 "1000000110" when addr = "00101" else -- Else branch to 00110
		 "0001110000" when addr = "00110" else -- Move 1s to LR
		 "0110011100" when addr = "00111" else -- XOR the LR and write it back to the LR (bit inversion)
		 "0100110001" when addr = "01000" else -- Sub 1 from ACC
		 "1101000111" when addr = "01001" else -- If ACC > 0 branch to 00111
		 "1000000000" when addr = "01010" else -- Else branch to 00000
		 "0000000000";                        -- garbage	
end one;






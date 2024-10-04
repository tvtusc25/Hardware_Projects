-- Quartus II VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pld2 is

	port(
		clk		 : in	std_logic;
		reset	 	 : in	std_logic;
		lights	 : out std_logic_vector(7 downto 0);
		IRView	 : out std_logic_vector(9 downto 0)
	);

end entity;

architecture rtl of pld2 is

	signal IR	: std_logic_vector(9 downto 0);
	signal PC	: unsigned(4 downto 0);
	signal LR	: unsigned(7 downto 0);
	signal ACC	: unsigned(7 downto 0);
	signal SRC	: unsigned(7 downto 0);
	signal ROMvalue	: std_logic_vector(9 downto 0);

	-- Build an enumerated type for the state machine
	type state_type is (sFetch, sExecute1, sExecute2);

	-- Register to hold the current state
	signal state   : state_type;
		
component pldrom
    port (
			addr  : in std_logic_vector(4 downto 0);
			data	: out std_logic_vector(9 downto 0)
	 );
end component;

begin

	pldrom1 : pldrom
	port map(
		addr => std_logic_vector(PC),
		data => ROMvalue
	);

	-- Logic to advance to the next state
	process (clk, reset)
	begin
		if reset = '0' then
			state <= sFetch;
			PC <= (others=>'0');
			IR <= (others=>'0');
			LR <= (others=>'0');
		elsif (rising_edge(clk)) then
			case state is
				when sFetch=>
					IR <= ROMvalue;
					PC <= PC + 1;
					state <= sExecute1;
				when sExecute1=>
					case IR(9 downto 8) is
						when "00" =>
							case IR(5 downto 4) is
								when "00" =>
									SRC <= ACC;
								when "01" =>
									SRC <= LR;
								when "10" =>
									SRC <= unsigned(IR(3) & IR(3) & IR(3) & IR(3) & IR(3 downto 0));
								when others =>
									SRC <= (others=>'1');
							end case;
						when "01"=>
							case IR(4 downto 3) is
								when "00" =>
									SRC <= ACC;
								when "01" =>
									SRC <= LR;
								when "10" =>
									SRC <= unsigned(IR(1) & IR(1) & IR(1) & IR(1) & IR(1) & IR(1) & IR(1 downto 0));
								when others =>
									SRC <= (others=>'1');
							end case;
						when "10" =>
							PC <= unsigned(IR(4 downto 0));
						when others =>
							case IR(7 downto 5) is
								when "000" =>
									if ACC = 0 then
										PC <= unsigned(IR(4 downto 0));
									end if;
								when "001" =>
									if LR = 0 then
										PC <= unsigned(IR(4 downto 0));
									end if;
								when "010" =>
									if ACC > 0 then
										PC <= unsigned(IR(4 downto 0));
									end if;
								when "011" =>
									if LR > 0 then
										PC <= unsigned(IR(4 downto 0));
									end if;
								when "100" =>
									if ACC < 1023 then
										PC <= unsigned(IR(4 downto 0));
									end if;
								when others =>
									if LR > 1023 then
										PC <= unsigned(IR(4 downto 0));
									end if;
							end case;
					end case;
					state <= sExecute2;
					
				when sExecute2=>
					case IR(9 downto 8) is
						when "00" =>
							case IR(7 downto 6) is
								when "00" =>
									ACC <= SRC;									
								when "01" =>
									LR <= SRC;									
								when "10" =>
									ACC(3 downto 0) <= SRC(3 downto 0);									
								when others =>
									ACC(7 downto 4) <= SRC(3 downto 0);									
							end case;
						when "01" =>
							case IR(2) is
								when '0' =>
									case IR(7 downto 5) is
										when "000" =>
											ACC <= ACC + SRC;											
										when "001" =>
											ACC <= ACC - SRC;											
										when "010" =>
											ACC <= SRC(6 downto 0) & '0';											
										when "011" =>
											ACC <= SRC(7) & SRC(7 downto 1);											
										when "100" =>
											ACC <= ACC xor SRC;											
										when "101" =>
											ACC <= ACC and SRC;											
										when "110" =>
											ACC <= SRC(6 downto 0) & SRC(7);											
										when others =>
											ACC <= SRC(0) & SRC(7 downto 1);											
									end case;
								when '1' =>
									case IR(7 downto 5) is
										when "000" =>
											LR <= LR + SRC;											
										when "001" =>
											LR <= LR - SRC;											
										when "010" =>
											LR <= SRC(6 downto 0) & '0';											
										when "011" =>
											LR <= SRC(7) & SRC(7 downto 1);												
										when "100" =>
											LR <= LR xor SRC;											
										when "101" =>
											LR <= LR and SRC;										
										when "110" =>
											LR <= SRC(6 downto 0) & SRC(7);												
										when others =>
											LR <= SRC(0) & SRC(7 downto 1);											
									end case;
								when others => 
							end case;
						when others =>
					end case;
					state <= sFetch;
					
				when others =>
			end case;
		end if;
	end process;				

lights <= std_logic_vector(LR);
IRView <= IR;
	
end rtl;
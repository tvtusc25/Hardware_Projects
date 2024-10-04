-- Quartus II VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lights is

	port(
		clk		 : in	std_logic;
		reset	 	 : in	std_logic;
		lightsig	 : out std_logic_vector(7 downto 0);
		IRView	 : out std_logic_vector(3 downto 0)
		--PCView	 : out std_logic_vector(3 downto 0)
	);

end entity;

architecture rtl of lights is

	signal IR	: std_logic_vector(3 downto 0);
	signal PC	: unsigned(4 downto 0);
	signal LR	: unsigned(7 downto 0);
	signal ROMvalue	: std_logic_vector(3 downto 0);
	signal L		: unsigned(3 downto 0);
	signal R		: unsigned(3 downto 0);

	-- Build an enumerated type for the state machine
	type state_type is (sFetch, sExecute);

	-- Register to hold the current state
	signal state   : state_type;
	
component lightrom
    port (
			addr  : in std_logic_vector(4 downto 0);
			data	: out std_logic_vector(3 downto 0)
	 );
end component;

begin

	lightrom1 : lightrom
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
					state <= sExecute;
				when sExecute=>
					case IR is
						when "0000" =>
							LR <= (others=>'0');
							state <= sFetch;
						when "0001" =>
							LR <= LR srl 1;
							state <= sFetch;
						when "0010" =>
							LR <= LR sll 1;
							state <= sFetch;
						when "0011" =>
							LR <= LR + 1;
							state <= sFetch;
						when "0100" =>
							LR <= LR - 1;
							state <= sFetch;
						when "0101" =>
							LR <= not LR;
							state <= sFetch;
						when "0110" =>
							LR <= LR ror 1;
							state <= sFetch;
						when "0111" =>
							LR <= LR rol 1;
							state <= sFetch;
						when "1000" =>
							LR <= "11111111";
							state <= sFetch;
						when "1001" =>
							L <= LR(7 downto 4) sll 1;
							R <= LR(3 downto 0) srl 1;
							LR <= L & R;
							state <= sFetch;
						when others =>
							LR <= LR;
					end case;
			end case;
		end if;
	end process;

	lightsig <= std_logic_vector(LR);
	IRView <= IR;
	
end rtl;
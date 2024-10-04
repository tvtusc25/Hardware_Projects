-- Quartus II VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is

	port(
		clk	 : in	std_logic;
		reset	 : in	std_logic;
		start	 : in	std_logic;
		react  : in std_logic;
		sNum	 : out std_logic_vector(1	downto 0);
		cycles : out std_logic_vector(7 downto 0);
		red	 : out std_logic;
		green  : out std_logic
	);

end entity;

architecture rtl of timer is

	-- Build an enumerated type for the state machine
	type state_type is (sIdle, sWait, sCount);

	-- Register to hold the current state
	signal state   : state_type;
	
	signal count : unsigned (7 downto 0);
	

begin

	-- Logic to advance to the next state
	process (clk, reset, start, react)
	begin
		if reset = '0' then
				state <= sIdle;
				count <= (others=>'0');
		elsif (rising_edge(clk)) then
			count <= count + 1;
			case state is
				when sIdle=>
					if start = '0' then
						state <= sWait;
					else
						state <= sIdle;
					end if;
				when sWait=>
					if react = '0' then
						count <= (others=>'1');
						state <= sIdle;
					elsif count = "00001111" then
						state <= sCount;
						count <= (others=>'0');
					else
						state <= sWait;
					end if;
				when sCount=>
					if react = '0' then
						state <= sIdle;
					else
						state <= sCount;
					end if;
			end case;
		end if;
	end process;
	
-- Output depends solely on the current state
	process (state)
	begin
		case state is
			when sCount =>
				sNum <= "10";
				green  <= '1';
				red    <= '0';
				cycles <= std_logic_vector(count);
			when sWait =>
				sNum <= "01";
				green  <= '0';
				red    <= '1';
				cycles <= (others=>'0');
			when sIdle =>
				sNum <= "00";
				green <= '0';
				red   <= '0';
				cycles <= std_logic_vector(count);
		end case;
	end process;

end rtl;

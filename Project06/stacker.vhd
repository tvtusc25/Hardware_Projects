-- Quartus II VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stacker is
	port( reset: in std_logic; -- button 1
        clock: in std_logic;
        data:  in std_logic_vector(3 downto 0);
        b2:    in std_logic; -- switch values to mbr
        b3:    in std_logic; -- push mbr -> stack
        b4:    in std_logic; -- pop stack -> mbr
        value: out std_logic_vector(3 downto 0);
        stackview: out std_logic_vector(3 downto 0);
        stateview: out std_logic_vector(2 downto 0)
        );

end entity;

architecture rtl of stacker is

	signal RAM_input	: std_logic_vector(3 downto 0);
	signal RAM_output : std_logic_vector(3 downto 0);
	signal RAM_we		: std_logic;
	signal stack_ptr  : unsigned(3 downto 0);
	signal mbr			: std_logic_vector(3 downto 0);
	signal state   	: std_logic_vector(2 downto 0);
		
component memram_lab
    port (
		address		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	 );
end component;

begin

	memram_lab1 : memram_lab
	port map(
		address => std_logic_vector(stack_ptr),
		clock => clock,
		data => RAM_input,
		wren => RAM_we,
		q => RAM_output
	);
	
	value <= mbr;
	stackview <= std_logic_vector(stack_ptr);
	stateview <= state;
	
	-- Logic to advance to the next state
	process (clock, reset)
	begin
		if reset = '0' then
			state <= "000";
			stack_ptr <= (others=>'0');
			mbr <= (others=>'0');
			RAM_input <= (others=>'0');
			RAM_we <= '0';
		elsif (rising_edge(clock)) then
			case state is
				when "000" =>
					if b2 <= '0' then
						mbr <= data;
						state <= "111";
					elsif b3 <= '0' then
						if stack_ptr /= 7 then
							RAM_input <= mbr;
							RAM_we <= '1';
							state <= "001";
						end if;
					elsif b4 <= '0' then 
						if stack_ptr /= 0 then
							stack_ptr <= stack_ptr - 1;
							state <= "100";
						end if;
					end if;
				when "001" =>
					RAM_we <= '0';
					stack_ptr <= stack_ptr + 1;
					state <= "111";
				when "100" =>
					state <= "101";
				when "101" =>
					state <= "110";
				when "110" =>
					mbr <= RAM_output;
					state <= "111";
				when "111" =>
					if b2 <= '1' and b3 <= '1' and b4 <= '1' then
						state <= "000";
					end if;
				when others =>
					state <= "000";
			end case;
		end if;
	end process;
end rtl;
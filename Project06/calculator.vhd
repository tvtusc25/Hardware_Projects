-- Quartus II VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculator is
	port (
		clk		 : in	std_logic;
		reset	 	 : in	std_logic;
		b2			 : in std_logic;
		b3			 : in std_logic;
		b4			 : in std_logic;
		op			 : in std_logic_vector(2 downto 0);
		data		 : in std_logic_vector(7 downto 0);
		digit0	 : out std_logic_vector(6 downto 0);
		digit1	 : out std_logic_vector(6 downto 0);
		stackview : out std_logic_vector(3 downto 0);
		stateview: out std_logic_vector(2 downto 0)
	);

end entity;

architecture rtl of calculator is

	signal RAM_input	: std_logic_vector(7 downto 0);
	signal RAM_output : std_logic_vector(7 downto 0);
	signal RAM_we		: std_logic;
	signal stack_ptr  : unsigned(3 downto 0);
	signal mbr			: std_logic_vector(7 downto 0);
	signal state   	: std_logic_vector(2 downto 0);
		
component memram
    port (
		address		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		clock			: IN STD_LOGIC  := '1';
		data			: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren			: IN STD_LOGIC ;
		q				: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	 );
end component;

component hexdisplay
	port (
		A	 :	in  unsigned(3 downto 0);
		hex : out unsigned(6 downto 0)
	);
end component;

begin

	memram1 : memram
	port map(
		address => std_logic_vector(stack_ptr),
		clock => clk,
		data => RAM_input,
		wren => RAM_we,
		q => RAM_output
	);
	
	hexdisplay1 : hexdisplay
	port map(
		A => unsigned(mbr(7 downto 4)),
		std_logic_vector(hex) => digit1
	);
	
	hexdisplay2 : hexdisplay
	port map(
		A => unsigned(mbr(3 downto 0)),
		std_logic_vector(hex) => digit0
	);
	
	
	stackview <= std_logic_vector(stack_ptr);
	stateview <= state;
	
	-- Logic to advance to the next state
	process (clk, reset)
	begin
		if reset = '0' then
			state <= "000";
			stack_ptr <= (others=>'0');
			mbr <= (others=>'0');
			RAM_input <= (others=>'0');
			RAM_we <= '0';
		elsif (rising_edge(clk)) then
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
					case op is
						when "000" =>
							mbr <= std_logic_vector(unsigned(mbr) + unsigned(RAM_output));
						when "001" =>
							mbr <= std_logic_vector(unsigned(RAM_output) - unsigned(mbr));
						when "010" =>
							mbr <= std_logic_vector(unsigned(mbr(3 downto 0)) * unsigned(RAM_output(3 downto 0)));
						when "011" =>
							mbr <= std_logic_vector(unsigned(RAM_output) / unsigned(mbr));
						when "100" =>
							mbr <= std_logic_vector(unsigned(RAM_output) mod unsigned(mbr));
						when "101" =>
							mbr <= std_logic_vector(unsigned(RAM_output) rem unsigned(mbr));
						when others =>
							mbr <= RAM_output;
					end case;
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
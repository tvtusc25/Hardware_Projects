--Trey Tuscai
--CS232
--28 November 2022
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
	port (
    clk   : in  std_logic;                       -- main clock
    reset : in  std_logic;                       -- reset button

    PCview : out std_logic_vector( 7 downto 0);  -- debugging outputs
    IRview : out std_logic_vector(15 downto 0);
    RAview : out std_logic_vector(15 downto 0);
    RBview : out std_logic_vector(15 downto 0);
    RCview : out std_logic_vector(15 downto 0);
    RDview : out std_logic_vector(15 downto 0);
    REview : out std_logic_vector(15 downto 0);

    iport : in  std_logic_vector(7 downto 0);    -- input port
    oport : out std_logic_vector(15 downto 0));  -- output port

end entity;

architecture rtl of cpu is

--state
type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8);
signal state : state_type;

--registers A-E
signal ra	 : unsigned(15 downto 0);
signal rb	 : unsigned(15 downto 0);
signal rc	 : unsigned(15 downto 0);
signal rd	 : unsigned(15 downto 0);
signal re	 : unsigned(15 downto 0);
--stack pointer
signal sp	 : unsigned(15 downto 0);
--instruction register
signal ir	 : unsigned(15 downto 0);
--memory buffer register
signal mbr 	 : unsigned(15 downto 0);
--condition register
signal cr 	 : unsigned(3 downto 0);
--program register
signal pc	 : unsigned(7 downto 0);
--memory address register
signal mar 	 : unsigned(7 downto 0);

--alu inputs
signal srcA  : unsigned(15 downto 0);
signal srcB  : unsigned(15 downto 0);
--alu output
signal ALU_output	 : unsigned(15 downto 0);
--alu opcode
signal op 	 : unsigned(2 downto 0);
--alu condition register
signal ALU_cr 	 : unsigned(3 downto 0);

--ram output
signal RAM_output : unsigned(15 downto 0);
--ram write enable
signal RAM_we	   : std_logic;

--rom output
signal ROM_output : unsigned(15 downto 0);

--signal output port register
signal OUTREG     : unsigned(15 downto 0);

--small counter
signal waitC : unsigned(2 downto 0);

component alu is 
	port (
		 srcA : in  unsigned(15 downto 0);         
		 srcB : in  unsigned(15 downto 0);         
		 op   : in  std_logic_vector(2 downto 0);  
		 cr   : out std_logic_vector(3 downto 0);  
		 dest : out unsigned(15 downto 0)
	);
end component;

--components
component DataRAM IS
	port (
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
end component;

component ProgramROM IS
	port (
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
end component;

begin

	--port maps
	alu1 : alu
	port map(srcA => srcA, srcB => srcB, op => std_logic_vector(op), unsigned(cr) => ALU_cr, dest => ALU_output);
	
	DataRam1: DataRAm
	port map(address => std_logic_vector(mar), clock => clk, data => std_logic_vector(mbr), wren => RAM_we, unsigned(q) => RAM_output);
	
	ProgramROM1: ProgramROM
	port map(address => std_logic_vector(pc), clock => clk, unsigned(q) => ROM_output);

	process(clk, reset, iport)
	begin
		--reset case
		if reset = '0' then
			PC <= (others => '0');
			IR <= (others => '0');
			OUTREG <= (others => '0');
			MAR <= (others => '0');
			MBR <= (others => '0');
			RA <= (others => '0');
			RB <= (others => '0');
			RC <= (others => '0');
			RD <= (others => '0');
			RE <= (others => '0');
			SP <= (others => '0');
			CR <= (others => '0');
			waitC <= (others => '0');
			state <= s0;
		elsif (rising_edge(clk)) then
			case state is
				--start state
				when s0 =>
					if waitC /= "111" then
						--increment small counter until 7
						waitC <= waitC + 1;
						state <= s0;
					else
						--move to fetch state
						state <= s1;
					end if;
				--fetch state
				when s1 =>
					--copy ROM data contents to the IR
					IR <= ROM_output;
					--increment PC
					PC <= PC + 1;
					--move to execute-setup state
					state <= s2;
				--execute-setup state
				when s2 =>
					op <= IR(14 downto 12);
					--move the correct RAM address into the MAR
					case IR(15 downto 12) is
						when "0000" => --load
							--if IR(11) is set, use the 8 low bits of the IR plus register E (RE)
							if IR(11) = '1' then
								MAR <= IR(7 downto 0) + RE(7 downto 0);
							else
							--if IR(11) is not set, just use the low bits of the IR
								MAR <= IR(7 downto 0);
							end if;
							state <= s3;
						when "0001" => --store
							if IR(11) = '1' then
								MAR <= IR(7 downto 0) + RE(7 downto 0);
							else
								MAR <= IR(7 downto 0);
							end if;
							--put the data to write into the RAM into the MBR
							--Table B
							case IR(10 downto 8) is
								when "000" =>
									MBR <= RA;
								when "001" =>
									MBR <= RB;
								when "010" =>
									MBR <= RC;
								when "011" =>
									MBR <= RD;
								when "100" =>
									MBR <= RE;
								when "101" =>
									MBR <= SP;
								when others =>
									null;
							end case;
							state <= s3;
						when "0010" => --unconditional
							--set the PC to the low 8 bits of the IR
							PC <= IR(7 downto 0);
							state <= s3;
						when "0011" => --conditional, call, return, exit
							case IR(11 downto 10) is
								when "00" => --conditional
									--move the low 8 bits of the IR to the PC if the condition is true.
									if (IR(9 downto 8) = "00" and CR(0) = '1') or
										(IR(9 downto 8) = "01" and CR(1) = '1') or
										(IR(9 downto 8) = "10" and CR(2) = '1') or
										(IR(9 downto 8) = "11" and CR(3) = '1') then
											PC <= IR(7 downto 0);
									end if;
									state <= s3;
								when "01" => --call
									--set the PC to the low 8 bits of the IR
									PC <= IR(7 downto 0);
									--set the MAR to the SP
									MAR <= SP(7 downto 0);
									--set the MBR to the concatenation of four zeros, the CR, and the PC
									MBR <= "0000" & CR & PC;
									--increment the stack pointer
									SP <= SP + 1;
									state <= s3;
								when "10" => --return
									--set the MAR to the SP-1
									MAR <= SP(7 downto 0) - 1;
									--decrement the SP
									SP <= SP - 1;
									state <= s3;
								when "11" => --exit
									state <= s8;
								when others =>
									null;
							end case;
						when "0100" => --push
							--put the current vaue of the SP into the MAR
							MAR <= SP(7 downto 0);
							--increment the SP
							SP <= SP + 1;
							--put the value specified in the source bits into the MBR
							--Table C
							case IR(11 downto 9) is
								when "000" =>
									MBR <= RA;
								when "001" =>
									MBR <= RB;
								when "010" =>
									MBR <= RC;
								when "011" =>
									MBR <= RD;
								when "100" =>
									MBR <= RE;
								when "101" =>
									MBR <= SP;
								when "110" =>
									MBR <= "00000000" & PC;
								when "111" =>
									MBR <= "000000000000" & CR;
								when others =>
									null;
							end case;
							state <= s3;
						when "0101" => --pop
							--put the value specified in the source bits into the MBR
							MAR <= SP(7 downto 0) - 1;
							--decrement the SP
							SP <= SP - 1;
							state <= s3;
						when "0110" => --Store to Output
							state <= s3;
						when "0111" => --Store to Input
							state <= s3;
						when "1000" | "1001" | "1010" | "1011" | "1100" => --binary operations
						--set up srcA and srcB
						--Table E
							case IR(11 downto 9) is
								when "000" =>
									srcA <= RA;
								when "001" =>
									srcA <= RB;
								when "010" =>
									srcA <= RC;
								when "011" =>
									srcA <= RD;
								when "100" =>
									srcA <= RE;
								when "101" =>
									srcA <= SP;
								when "110" =>
									srcA <= (others => '0');
								when "111" =>
									srcA <= (others => '1');
								when others =>
									null;
							end case;
							--Table E
							case IR(8 downto 6) is
								when "000" =>
									srcB <= RA;
								when "001" =>
									srcB <= RB;
								when "010" =>
									srcB <= RC;
								when "011" =>
									srcB <= RD;
								when "100" =>
									srcB <= RE;
								when "101" =>
									srcB <= SP;
								when "110" =>
									srcB <= (others => '0');
								when "111" =>
									srcB <= (others => '1');
								when others =>
									null;
							end case;
							state <= s3;
						when "1101" | "1110" => --unary operations
							--set up srcA and put the direction bit in the low bit of srcB
							srcB <= (0 => IR(11), others => '0');
							--Table E
							case IR(10 downto 8) is
								when "000" =>
									srcB <= RA;
								when "001" =>
									srcB <= RB;
								when "010" =>
									srcB <= RC;
								when "011" =>
									srcB <= RD;
								when "100" =>
									srcB <= RE;
								when "101" =>
									srcB <= SP;
								when "110" =>
									srcB <= (others => '0');
								when "111" =>
									srcB <= (others => '1');
								when others =>
									null;
							end case;
							state <= s3;
						when "1111" => --move
							--set up srcA
							--will come either from a register or be a sign extended value
							--from the immediate value bits of the IR (bits 10 downto 3)
							if IR(11) = '1' then
								if IR(10) = '0' then
									srcA <= "00000000" & IR(10 downto 3);
								else
									srcA <= "11111111" & IR(10 downto 3);
								end if;
							else
								--Table D
								case IR(10 downto 8) is
								when "000" =>
									srcA <= RA;
								when "001" =>
									srcA <= RB;
								when "010" =>
									srcA <= RC;
								when "011" =>
									srcA <= RD;
								when "100" =>
									srcA <= RE;
								when "101" =>
									srcA <= SP;
								when "110" =>
									srcA <= "00000000" & PC;
								when "111" =>
									srcA <= IR;
								when others =>
									null;
								end case;
							end if;
							state <= s3;
						when others =>
							state <= s3;
					end case;
					--Execute-ALU state
					when s3 =>
					--RAM write enable signal to high if the operation is a 
					--store (opcode 0001, or integer 1), a push, or a CALL.
						if IR(15 downto 12) = "0001" or IR(15 downto 12) = "0100" or IR(15 downto 10) = "001101" then
							RAM_we <= '1';
						end if;
						if IR(15 downto 12) = "0101" or IR(15 downto 12) = "0000" or IR(15 downto 10) = "001110" then
							state <= s4;
						else
							state <= s5;
						end if;
					--Execute-MemWait state
					when s4 =>
						--does nothing
						state <= s5;
					--Execute-Write state
					when s5 =>
						--set the write enable flag to '0'.
						RAM_we <= '0';
						case IR(15 downto 12) is 
							--write the contents of the RAM data wire to the specified destination register
							when "0000" => --load
								case IR(10 downto 8) is
								--Table B
									when "000" =>
										RA <= RAM_output;
									when "001" =>
										RB <= RAM_output;
									when "010" =>
										RC <= RAM_output;
									when "011" =>
										RD <= RAM_output;
									when "100" =>
										RE <= RAM_output;
									when "101" =>
										SP <= RAM_output;
									when others =>
										null;
								end case;
								state <= s1;
							--The store, unconditional branch, conditional branch, call, and push operations require no action.
							when "0011" => -- return
								if IR(11 downto 10) = "10" then
									--proper parts of the RAM data wire written to the PC and CR
									PC <= RAM_output(7 downto 0);
									CR <= RAM_output(11 downto 8);
									state <= s6;
								else
									state <= s1;
								end if;
							when "0101" => --pop
							--write the value of the RAM data wire to the destination
								case IR(11 downto 9) is
								--Table C
									when "000" =>
										RA <= RAM_output;
									when "001" =>
										RB <= RAM_output;
									when "010" =>
										RC <= RAM_output;
									when "011" =>
										RD <= RAM_output;
									when "100" =>
										RE <= RAM_output;
									when "101" =>
										SP <= RAM_output;
								   when "110" =>
										PC <= RAM_output(7 downto 0);
									when "111" =>
										CR <= RAM_output(3 downto 0);
									when others =>
										null;
								end case;
								state <= s1;
							when "0110" => --write
							--set the output port register OUTREG to the specified value
								case IR(11 downto 9) is
								--Table D
									when "000" =>
										OUTREG <= RA;
									when "001" =>
										OUTREG <= RB;
									when "010" =>
										OUTREG <= RC;
									when "011" =>
										OUTREG <= RD;
									when "100" =>
										OUTREG <= RE;
									when "101" =>
										OUTREG <= SP;
								   when "110" =>
										OUTREG <= "00000000" & PC;
									when "111" =>
										OUTREG <= IR;
									when others =>
										null;
								end case;
								state <= s1;
							when "0111" => --load
							--write the input port value to the specified register
								case IR(11 downto 9) is
								--Table B
									when "000" =>
										RA <= "00000000" & unsigned(iport);
									when "001" =>
										RB <= "00000000" & unsigned(iport);
									when "010" =>
										RC <= "00000000" & unsigned(iport);
									when "011" =>
										RD <= "00000000" & unsigned(iport);
									when "100" =>
										RE <= "00000000" & unsigned(iport);
									when "101" =>
										SP <= "00000000" & unsigned(iport);
									when others =>
										null;
								end case;
								state <= s1;
							when "1000" | "1001" | "1010" | "1011" | "1100" | "1101" | "1110" | "1111" => --binary and unary arithmetic operations
							--write the destination value to the proper register
								case IR(2 downto 0) is
								--Table B
									when "000" =>
										RA <= alu_output;
									when "001" =>
										RB <= alu_output;
									when "010" =>
										RC <= alu_output;
									when "011" =>
										RD <= alu_output;
									when "100" =>
										RE <= alu_output;
									when "101" =>
										SP <= alu_output;
									when others =>
										null;
								end case;
								--assign the ALU condition flags to the condition register [CR]
								CR <= alu_cr;
								state <= s1;
						when others =>
							state <= s1;
					end case;
					--Execute-ReturnPause1 state
					when s6 =>
					--waits for the return address to propogate through the ROM
						state <= s7;
					--Execute-ReturnPause2 state
					when s7 =>
					--waits for the return address to propagate through the ROM
					--move to fetch
						state <= s1;
					when s8 =>
						state <= s8;
				end case;
			end if;
		end process;
	--connections
	PCview <= std_logic_vector(PC);  
   IRview <= std_logic_vector(IR);
   RAview <= std_logic_vector(RA);
   RBview <= std_logic_vector(RB);
   RCview <= std_logic_vector(RC);
   RDview <= std_logic_vector(RD);
   REview <= std_logic_vector(RE);
	oport <= std_logic_vector(OUTREG);
end rtl;
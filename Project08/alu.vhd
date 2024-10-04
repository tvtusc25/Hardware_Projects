-- Trey Tuscai
-- CS 232 Spring 2013
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- The alu circuit implements the specified operation on srcA and srcB, putting
-- the result in dest and setting the appropriate condition flags.

-- The opcode meanings are shown in the case statement below

-- condition outputs
-- cr(0) <= '1' if the result of the operation is 0
-- cr(1) <= '1' if there is a 2's complement overflow
-- cr(2) <= '1' if the result of the operation is negative
-- cr(3) <= '1' if the operation generated a carry of '1'

-- Note that the and/or/xor operations are defined on std_logic_vectors, so you
-- may have to convert the srcA and srcB signals to std_logic_vectors, execute
-- the operation, and then convert the result back to an unsigned.  You can do
-- this all within a single expression.


entity alu is
  
  port (
    srcA : in  unsigned(15 downto 0);         -- input A
    srcB : in  unsigned(15 downto 0);         -- input B
    op   : in  std_logic_vector(2 downto 0);  -- operation
    cr   : out std_logic_vector(3 downto 0);  -- condition outputs
    dest : out unsigned(15 downto 0));        -- output value

end alu;

architecture test of alu is

  -- The signal tdest is an intermediate signal to hold the result and
  -- catch the carry bit in location 16.
  signal tdest : unsigned(16 downto 0);  
  
  -- Note that you should always put the carry bit into index 16, even if the
  -- carry is shifted out the right side of the number (into position -1) in
  -- the case of a shift or rotate operation.  This makes it easy to set the
  -- condition flag in the case of a carry out.

begin  -- test
  process (srcA, srcB, op)
  begin  -- process
    case op is
      when "000" =>        -- addition     
		tdest <= (srcA(15) & srcA) + (srcB(15) & srcB);
      when "001" =>        -- subtraction
		tdest <= (srcA(15) & srcA) - (srcB(15) & srcB);
      when "010" =>        -- and
		tdest <= '0' & (srcA and srcB);
      when "011" =>        -- or   
		tdest <= '0' & (srcA or srcB);
      when "100" =>        -- xor
		tdest <= '0' & (srcA xor srcB);
      when "101" =>        -- shift
			if srcB(0) <= '0' then
				tdest <= srcA(15) & srcA(14 downto 0) & '0';
			else
				tdest <= srcA(0) & srcA(15) & srcA(15 downto 1);
			end if;
      when "110" =>        -- rotate       
		if srcB(0) <= '0' then
				tdest <= srcA(15) & srcA(14 downto 0) & srcA(15);
			else
				tdest <= srcA(0) & srcA(0) & srcA(15 downto 1);
			end if;
      when "111" =>        -- pass
		tdest <= srcA(15) & srcA;
      when others =>
        null;
    end case;
  end process;

  -- connect the low 16 bits of tdest to dest here
 dest <= tdest(15 downto 0);
  -- set the four CR output bits here
 cr(0) <= '1' when tdest = 0 else '0';
 cr(1) <= '1' when op = "000" and srcA(15) = '0' and srcB(15) = '0' and tdest(15) = '1' else
			 '1' when op = "000" and srcA(15) = '1' and srcB(15) = '1' and tdest(15) = '0' else
			 '1' when op = "001" and srcA(15) = '0' and srcB(15) = '1' and tdest(15) = '0' else
			 '1' when op = "001" and srcA(15) = '1' and srcB(15) = '0' and tdest(15) = '1' else
			 '0';
 cr(2) <= tdest(15);
 cr(3) <= tdest(16);
	
end test;
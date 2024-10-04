-- Quartus II VHDL Template
-- Binary Counter
-- modified by Maxwell S16

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is

  port
    (
      clk         : in std_logic;
      reset	  : in std_logic;
      enable	  : in std_logic;
      q		  : out std_logic_vector (3 downto 0)
      );

end entity;

architecture rtl of counter is

  signal   cnt	: unsigned (3 downto 0);

begin

  process (clk)
  begin
    if reset = '1' then
      -- Reset the counter to 0
      cnt <= "0000";
    elsif (rising_edge(clk)) then
      if enable = '1' then
        -- Increment the counter if counting is enabled			   
        cnt <= cnt + 1;
      end if;
    end if;
  end process;

  q <= std_logic_vector(cnt);

end rtl;
-- Quartus II VHDL Template
-- Binary Counter
-- modified by Taylor F20

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter8 is

  port
    (
      clk         : in std_logic;
      reset	  : in std_logic;
      enable	  : in std_logic;
      q  	      : out unsigned(7 downto 0)
      );

end entity;

architecture rtl of counter8 is
    signal cnt : unsigned(7 downto 0);
begin

  process (clk)
  begin
    if reset = '1' then
      -- Reset the counter to 0
      cnt <= "00000000";
    elsif (rising_edge(clk)) then
      if enable = '1' then
        -- Increment the counter if counting is enabled			   
        cnt <= cnt + 1;
      end if;
    end if;
  end process;
  
  q <= cnt;

end rtl;
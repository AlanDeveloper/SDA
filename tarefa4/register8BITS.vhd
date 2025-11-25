library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register8BITS is
    Port ( 
        clock  : in  STD_LOGIC;
        reset  : in  STD_LOGIC;
        enable : in  STD_LOGIC;
        d_in   : in  STD_LOGIC_VECTOR(7 downto 0);
        d_out  : out STD_LOGIC_VECTOR(7 downto 0)
    );
end register8BITS;

architecture Arc of register8BITS is
begin
    process(clock, reset)
    begin
        if reset = '1' then
            d_out <= (others => '0');
        elsif rising_edge(clock) then
            if enable = '1' then
                d_out <= d_in;
            end if;
        end if;
    end process;    
end Arc;

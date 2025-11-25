library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register32BITS is
    Port ( 
        clock  : in  STD_LOGIC;
        reset  : in  STD_LOGIC;
        enable : in  STD_LOGIC;
        d_in   : in  STD_LOGIC_VECTOR(7 downto 0);
        d_out  : out STD_LOGIC_VECTOR(7 downto 0)
    );
end register32BITS;

architecture Arc of register32BITS is
    signal reg : STD_LOGIC_VECTOR(7 downto 0);
begin
    process(clock, reset)
    begin
        if reset = '1' then
            reg <= (others => '0');
        elsif rising_edge(clock) then
            if enable = '1' then
                reg <= d_in;
            end if;
        end if;
    end process;
    
    d_out <= reg;
    
end Arc;

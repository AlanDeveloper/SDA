library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2to1 is
    Port (
        sel    : in  STD_LOGIC;
        input0 : in  STD_LOGIC_VECTOR(31 downto 0);
        input1 : in  STD_LOGIC_VECTOR(31 downto 0);
        output : out STD_LOGIC_VECTOR(31 downto 0)
    );
end mux2to1;

architecture Arc of mux2to1 is
begin
    process(sel, input0, input1)
    begin
        case sel is
            when '0' => output <= input0;
            when '1' => output <= input1;
            when others => output <= (others => '0');
        end case;
    end process;
end Arc;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shifter is
    Port (
        sel    : in STD_LOGIC_VECTOR(1 downto 0);
        input  : in STD_LOGIC_VECTOR(31 downto 0);
        output : out STD_LOGIC_VECTOR(31 downto 0)
    );
end shifter;

architecture Arc of shifter is
begin
    output <= input(30 downto 0) & '0'     when sel = "01" else  -- Shift LEFT
              '0' & input(31 downto 1)     when sel = "10" else  -- Shift RIGHT
              input;                                             -- Sem shift (00 ou 11)
end Arc;
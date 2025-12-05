Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;

Entity soma16b is
    Port(
        a    : in std_logic_vector(15 downto 0);
        b    : in std_logic_vector(15 downto 0);
        s    : out std_logic_vector(15 downto 0);
        cout : out std_logic
    );
End soma16b;

architecture arq of soma16b is
    signal aux : std_logic_vector(16 downto 0);
begin
    aux <= ('0' & a) + ('0' & b);
    s <= aux(15 downto 0);
    cout <= aux(16);
end arq;
Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;

Entity soma8b is
Port(a,b : in std_logic_vector(7 downto 0);
     s : out std_logic_vector(7 downto 0);
     cout : out std_logic
);
End soma8b;

architecture arq of soma8b is
signal aux_a, aux_b, aux_s : std_logic_vector(8 downto 0);
begin
    aux_a <= '0' & a;
    aux_b <= '0' & b;
    aux_s <= aux_a + aux_b;
    s <= aux_s(7 downto 0);
    cout <= aux_s(8);
end arq;
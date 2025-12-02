Library IEEE;
USE IEEE.std_logic_1164.all;

Entity PROJETO is
Port(
    a : in std_logic_vector(7 downto 0);
    b : in std_logic_vector(7 downto 0);
    resultado : out std_logic_vector(15 downto 0)
);
End PROJETO;

architecture arq of PROJETO is
    component matricial is
        Port(a, b : in std_logic_vector(7 downto 0);
             p : out std_logic_vector(15 downto 0)
        );
    End component;
begin
    MULT: matricial port map(
        a => a,
        b => b,
        p => resultado
    );
end arq;
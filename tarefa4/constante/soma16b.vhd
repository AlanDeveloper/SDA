Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;

Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;

Entity somador_16b is
    Port(
        a       : in STD_LOGIC_VECTOR(15 downto 0);
        b       : in STD_LOGIC_VECTOR(15 downto 0);
        op      : in STD_LOGIC;
        resultado : out STD_LOGIC_VECTOR(15 downto 0);
        cout    : out STD_LOGIC
    );
End somador_16b;

architecture estrutural of somador_16b is
    signal aux : STD_LOGIC_VECTOR(16 downto 0);
    signal b_complementado : STD_LOGIC_VECTOR(15 downto 0);
begin
    
    b_complementado <= NOT b when op = '1' else b;
    
    aux <= ('0' & a) + ('0' & b_complementado) + op;
    
    resultado <= aux(15 downto 0);
    cout <= aux(16);
    
end estrutural;
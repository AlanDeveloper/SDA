Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;

Entity mult_x7 is
    Port(
        md        : in STD_LOGIC_VECTOR(7 downto 0);
        resultado : out STD_LOGIC_VECTOR(15 downto 0)
    );
End mult_x7;

architecture estrutural of mult_x7 is
    
    component somador_16b is
        Port(
            a       : in STD_LOGIC_VECTOR(15 downto 0);
            b       : in STD_LOGIC_VECTOR(15 downto 0);
            op      : in STD_LOGIC;
            resultado : out STD_LOGIC_VECTOR(15 downto 0);
            cout    : out STD_LOGIC
        );
    End component;
    
    signal md_x8 : STD_LOGIC_VECTOR(15 downto 0);
    signal md_estendido : STD_LOGIC_VECTOR(15 downto 0);
    signal diferenca : STD_LOGIC_VECTOR(15 downto 0);
    signal cout_dummy : STD_LOGIC;
    
begin
    
    md_estendido <= "00000000" & md;
    md_x8 <= md_estendido(12 downto 0) & "000";
    
    SUB: somador_16b port map(
        a       => md_x8,
        b       => md_estendido,
        op      => '1',
        resultado => diferenca,
        cout    => cout_dummy
    );
    
    resultado <= diferenca;
    
end estrutural;
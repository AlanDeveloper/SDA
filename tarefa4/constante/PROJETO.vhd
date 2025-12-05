Library IEEE;
USE IEEE.std_logic_1164.all;

Entity PROJETO is
    Port(
        clk       : in STD_LOGIC;
        rst       : in STD_LOGIC;
        start     : in STD_LOGIC;
        md        : in STD_LOGIC_VECTOR(7 downto 0);
        resultado : out STD_LOGIC_VECTOR(15 downto 0);
        pronto    : out STD_LOGIC
    );
End PROJETO;

architecture estrutural of PROJETO is
    
    component mult_sequencial is
        Port(
            clk       : in STD_LOGIC;
            rst       : in STD_LOGIC;
            start     : in STD_LOGIC;
            md        : in STD_LOGIC_VECTOR(7 downto 0);
            resultado : out STD_LOGIC_VECTOR(15 downto 0);
            pronto    : out STD_LOGIC
        );
    End component;
    
begin
    
    MULT: mult_sequencial port map(
        clk => clk,
        rst => rst,
        start => start,
        md => md,
        resultado => resultado,
        pronto => pronto
    );
    
end estrutural;
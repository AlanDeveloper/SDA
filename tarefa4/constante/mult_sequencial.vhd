
Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;

Entity mult_sequencial is
    Port(
        clk       : in STD_LOGIC;
        rst       : in STD_LOGIC;
        start     : in STD_LOGIC;
        md        : in STD_LOGIC_VECTOR(7 downto 0);
        resultado : out STD_LOGIC_VECTOR(15 downto 0);
        pronto    : out STD_LOGIC
    );
End mult_sequencial;

architecture estrutural of mult_sequencial is
    
    component mult_x7 is
        Port(
            md        : in STD_LOGIC_VECTOR(7 downto 0);
            resultado : out STD_LOGIC_VECTOR(15 downto 0)
        );
    End component;
    
    signal resultado_comb : STD_LOGIC_VECTOR(15 downto 0);
    signal resultado_reg : STD_LOGIC_VECTOR(15 downto 0);
    signal pronto_reg : STD_LOGIC;
    
begin
    
    MULT: mult_x7 port map(
        md => md,
        resultado => resultado_comb
    );
    
    process(clk, rst)
    begin
        if rst = '1' then
            resultado_reg <= (others => '0');
            pronto_reg <= '0';
        elsif rising_edge(clk) then
            if start = '1' then
                resultado_reg <= resultado_comb;
                pronto_reg <= '1';
            else
                pronto_reg <= '0';
            end if;
        end if;
    end process;
    
    resultado <= resultado_reg;
    pronto <= pronto_reg;
    
end estrutural;
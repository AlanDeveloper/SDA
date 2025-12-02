Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;

Entity mult_sequencial is
    Port(
        clk       : in STD_LOGIC;
        rst       : in STD_LOGIC;
        start     : in STD_LOGIC;
        a         : in STD_LOGIC_VECTOR(7 downto 0);
        b         : in STD_LOGIC_VECTOR(7 downto 0);  -- Sempre 7
        resultado : out STD_LOGIC_VECTOR(15 downto 0);
        pronto    : out STD_LOGIC
    );
End mult_sequencial;

architecture arq of mult_sequencial is
    type estado is (OCIOSO, CALC_SHIFT, CALC_SUB, FINALIZADO);
    signal estado_atual : estado;
    
    signal md : STD_LOGIC_VECTOR(7 downto 0);
    signal acc : STD_LOGIC_VECTOR(15 downto 0);
    signal md_shift3 : STD_LOGIC_VECTOR(15 downto 0);  -- MD × 8
    
begin
    
    process(clk, rst)
    begin
        if rst = '1' then
            estado_atual <= OCIOSO;
            md <= (others => '0');
            acc <= (others => '0');
            pronto <= '0';
            
        elsif rising_edge(clk) then
            case estado_atual is
                
                when OCIOSO =>
                    pronto <= '0';
                    if start = '1' then
                        md <= a;
                        acc <= (others => '0');
                        estado_atual <= CALC_SHIFT;
                    end if;
                
                when CALC_SHIFT =>
                    -- MD × 8 = shift left 3 bits
                    md_shift3 <= md & "00000000";
                    estado_atual <= CALC_SUB;
                
                when CALC_SUB =>
                    -- MD × 7 = (MD × 8) - MD
                    acc <= md_shift3 - ("00000000" & md);
                    estado_atual <= FINALIZADO;
                
                when FINALIZADO =>
                    pronto <= '1';
                    if start = '0' then
                        estado_atual <= OCIOSO;
                    end if;
            end case;
        end if;
    end process;
    
    resultado <= acc;
end arq;

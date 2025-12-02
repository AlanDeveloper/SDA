Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
USE IEEE.numeric_std.all;

Entity mult_sequencial is
    Port(
        clk       : in STD_LOGIC;
        rst       : in STD_LOGIC;
        start     : in STD_LOGIC;
        a         : in STD_LOGIC_VECTOR(7 downto 0);
        b         : in STD_LOGIC_VECTOR(7 downto 0);
        resultado : out STD_LOGIC_VECTOR(15 downto 0);
        pronto    : out STD_LOGIC
    );
End mult_sequencial;

architecture arq of mult_sequencial is
    type estado is (OCIOSO, OPERANDO, FAST_MULT7, FINALIZADO);
    signal estado_atual : estado;
    
    signal contador : INTEGER range 0 to 8;
    signal md : STD_LOGIC_VECTOR(7 downto 0);
    signal mr : STD_LOGIC_VECTOR(7 downto 0);
    signal acc : STD_LOGIC_VECTOR(15 downto 0);
    signal soma_entrada : STD_LOGIC_VECTOR(15 downto 0);
    signal soma_saida : STD_LOGIC_VECTOR(15 downto 0);
    
    -- Sinais para multiplicação otimizada por 7
    signal md_shift3 : STD_LOGIC_VECTOR(15 downto 0);  -- MD × 8
    signal md_extended : STD_LOGIC_VECTOR(15 downto 0); -- MD estendido
    signal resultado_mult7 : STD_LOGIC_VECTOR(15 downto 0);
    
begin
    
    -- Lógica normal de soma (para multiplicação genérica)
    soma_entrada <= "00000000" & md when mr(0) = '1' else (others => '0');
    soma_saida <= acc + soma_entrada;
    
    -- Lógica otimizada para multiplicação por 7
    -- MD × 7 = MD × 8 - MD = (MD << 3) - MD
    md_shift3 <= md & "00000000";  -- Shift left 3 posições = multiplicação por 8
    md_extended <= "00000000" & md;
    resultado_mult7 <= md_shift3 - md_extended;
    
    process(clk, rst)
    begin
        if rst = '1' then
            estado_atual <= OCIOSO;
            contador <= 0;
            md <= (others => '0');
            mr <= (others => '0');
            acc <= (others => '0');
            pronto <= '0';
            
        elsif rising_edge(clk) then
            case estado_atual is
                
                when OCIOSO =>
                    pronto <= '0';
                    if start = '1' then
                        md <= a;
                        mr <= b;
                        acc <= (others => '0');
                        contador <= 0;
                        
                        -- Detecta se está multiplicando por 7
                        if b = "00000111" then
                            estado_atual <= FAST_MULT7;
                        elsif a = "00000111" then
                            -- Se A=7 e B≠7, troca os operandos
                            md <= b;
                            mr <= a;
                            estado_atual <= FAST_MULT7;
                        else
                            -- Multiplicação genérica
                            estado_atual <= OPERANDO;
                        end if;
                    end if;
                
                when FAST_MULT7 =>
                    -- Executa multiplicação otimizada em 1 ciclo
                    -- Resultado = MD × 8 - MD
                    acc <= resultado_mult7;
                    mr <= (others => '0');
                    estado_atual <= FINALIZADO;
                
                when OPERANDO =>
                    if contador < 8 then
                        acc <= '0' & soma_saida(15 downto 1);
                        mr <= soma_saida(0) & mr(7 downto 1);
                        
                        contador <= contador + 1;
                    else
                        estado_atual <= FINALIZADO;
                    end if;
                
                when FINALIZADO =>
                    pronto <= '1';
                    if start = '0' then
                        estado_atual <= OCIOSO;
                    end if;
            end case;
        end if;
    end process;
    
    resultado <= acc(7 downto 0) & mr;
end arq;

Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;

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
    type estado is (OCIOSO, OPERANDO, FINALIZADO);
    signal estado_atual : estado;
    
    signal contador : INTEGER range 0 to 8;
    signal md : STD_LOGIC_VECTOR(7 downto 0);
    signal mr : STD_LOGIC_VECTOR(7 downto 0);
    signal acc : STD_LOGIC_VECTOR(15 downto 0);  -- Acumulador (parte alta do resultado)
    signal soma_entrada : STD_LOGIC_VECTOR(15 downto 0);
    signal soma_saida : STD_LOGIC_VECTOR(15 downto 0);
    
begin
    
    -- MUX superior: seleciona 0 ou MD para somar baseado em mr(0)
    soma_entrada <= "00000000" & md when mr(0) = '1' else (others => '0');
    
    -- Somador
    soma_saida <= acc + soma_entrada;
    
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
                        estado_atual <= OPERANDO;
                    end if;
                
                when OPERANDO =>
                    if contador < 8 then
                        -- Concatena resultado: parte alta (após soma) e LSB de MR
                        -- Depois faz shift right de tudo junto
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
    
    -- Resultado final: concatenação de acc e mr
    resultado <= acc(7 downto 0) & mr;

end arq;

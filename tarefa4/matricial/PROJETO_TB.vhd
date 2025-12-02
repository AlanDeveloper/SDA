library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PROJETO_TB is
end PROJETO_TB;

architecture Behavioral of PROJETO_TB is
    component PROJETO
       Port(
            a : in std_logic_vector(7 downto 0);
            b : in std_logic_vector(7 downto 0);
            resultado : out std_logic_vector(15 downto 0)
        );
    end component;
    
    signal clock    : STD_LOGIC := '0';
    signal reset    : STD_LOGIC := '0';
    signal a  : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal b  : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal resultado  : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    
    constant CLK_PERIOD : time := 10 ns;
    
begin
    UUT: PROJETO
        port map (
            a : in std_logic_vector(7 downto 0);
            b : in std_logic_vector(7 downto 0);
            resultado : out std_logic_vector(15 downto 0)
        );
    
    clk_process: process
    begin
        clock <= '0';
        wait for CLK_PERIOD/2;
        clock <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    test_process: process
    begin
        report "===== INICIANDO TESTES =====";
        
        -- Reset inicial
        reset <= '1';
        wait until rising_edge(clock);
        wait until rising_edge(clock);
        reset <= '0';
        wait until rising_edge(clock);
        
        -----------------------------------------------------------------
        -- TESTE 1: 5 * 7
        -----------------------------------------------------------------
        report "TESTE 1: R0 <- 10";
        a <= "00000101";
        b <= "00000111";
        wait until rising_edge(clock);
        assert resultado = "0000000000100011"
            report "ERRO TESTE 1: resultado deveria ser 0000000000100011"
            severity error;
        
        -----------------------------------------------------------------
        -- TESTE 2: 10 * 2
        -----------------------------------------------------------------
        report "TESTE 1: R0 <- 10";
        a <= "00001010";
        b <= "00000010";
        wait until rising_edge(clock);
        assert resultado = "0000000000010100"
            report "ERRO TESTE 2: resultado deveria ser 0000000000010100"
            severity error;
        
        report "===== TODOS OS TESTES PASSARAM =====";
        wait;
    end process;
    
end Behavioral;

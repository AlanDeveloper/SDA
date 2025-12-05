Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;

Entity PROJETO_TB is
End PROJETO_TB;

architecture tb of PROJETO_TB is
    
    component PROJETO is
        Port(
            clk       : in STD_LOGIC;
            rst       : in STD_LOGIC;
            start     : in STD_LOGIC;
            md        : in STD_LOGIC_VECTOR(7 downto 0);
            resultado : out STD_LOGIC_VECTOR(15 downto 0);
            pronto    : out STD_LOGIC
        );
    End component;
    
    signal clk_tb : STD_LOGIC := '0';
    signal rst_tb : STD_LOGIC := '1';
    signal start_tb : STD_LOGIC := '0';
    signal md_tb : STD_LOGIC_VECTOR(7 downto 0);
    signal resultado_tb : STD_LOGIC_VECTOR(15 downto 0);
    signal pronto_tb : STD_LOGIC;
    
begin
    
    DUT: PROJETO port map(
        clk => clk_tb,
        rst => rst_tb,
        start => start_tb,
        md => md_tb,
        resultado => resultado_tb,
        pronto => pronto_tb
    );
    
    process
    begin
        clk_tb <= '0';
        wait for 5 ns;
        clk_tb <= '1';
        wait for 5 ns;
    end process;
    
    process
    begin
        
        rst_tb <= '1';
        start_tb <= '0';
        md_tb <= (others => '0');
        wait for 20 ns;
        rst_tb <= '0';
        wait for 10 ns;
        
        -- ===== TESTE 1: 5 x 7 = 35 =====
        report "TESTE 1: 5 x 7";
        md_tb <= "00000101";  -- 5
        start_tb <= '1';
        wait for 10 ns;
        start_tb <= '0';
        wait until pronto_tb = '1';
        report "Resultado: " & integer'image(conv_integer(resultado_tb)) & " (esperado 35)";
        wait for 10 ns;
        
        -- ===== TESTE 2: 10 x 7 = 70 =====
        report "TESTE 2: 10 x 7";
        md_tb <= "00001010";  -- 10
        start_tb <= '1';
        wait for 10 ns;
        start_tb <= '0';
        wait until pronto_tb = '1';
        report "Resultado: " & integer'image(conv_integer(resultado_tb)) & " (esperado 70)";
        wait for 10 ns;
        
        -- ===== TESTE 3: 15 x 7 = 105 =====
        report "TESTE 3: 15 x 7";
        md_tb <= "00001111";  -- 15
        start_tb <= '1';
        wait for 10 ns;
        start_tb <= '0';
        wait until pronto_tb = '1';
        report "Resultado: " & integer'image(conv_integer(resultado_tb)) & " (esperado 105)";
        wait for 10 ns;
        
        -- ===== TESTE 4: 20 x 7 = 140 =====
        report "TESTE 4: 20 x 7";
        md_tb <= "00010100";  -- 20
        start_tb <= '1';
        wait for 10 ns;
        start_tb <= '0';
        wait until pronto_tb = '1';
        report "Resultado: " & integer'image(conv_integer(resultado_tb)) & " (esperado 140)";
        wait for 10 ns;
        
        -- ===== TESTE 5: 52 x 7 = 364 =====
        report "TESTE 5: 52 x 7";
        md_tb <= "00110100";  -- 52
        start_tb <= '1';
        wait for 10 ns;
        start_tb <= '0';
        wait until pronto_tb = '1';
        report "Resultado: " & integer'image(conv_integer(resultado_tb)) & " (esperado 364)";
        wait for 10 ns;
        
        -- ===== TESTE 6: 100 x 7 = 700 =====
        report "TESTE 6: 100 x 7";
        md_tb <= "01100100";  -- 100
        start_tb <= '1';
        wait for 10 ns;
        start_tb <= '0';
        wait until pronto_tb = '1';
        report "Resultado: " & integer'image(conv_integer(resultado_tb)) & " (esperado 700)";
        wait for 10 ns;
        
        -- ===== TESTE 7: 0 x 7 = 0 =====
        report "TESTE 7: 0 x 7";
        md_tb <= "00000000";  -- 0
        start_tb <= '1';
        wait for 10 ns;
        start_tb <= '0';
        wait until pronto_tb = '1';
        report "Resultado: " & integer'image(conv_integer(resultado_tb)) & " (esperado 0)";
        wait for 10 ns;
        
        -- ===== TESTE 8: 255 x 7 = 1785 =====
        report "TESTE 8: 255 x 7";
        md_tb <= "11111111";  -- 255
        start_tb <= '1';
        wait for 10 ns;
        start_tb <= '0';
        wait until pronto_tb = '1';
        report "Resultado: " & integer'image(conv_integer(resultado_tb)) & " (esperado 1785)";
        wait for 10 ns;
        
        report "======================================";
        report "TODOS OS TESTES CONCLUIDOS!";
        report "======================================";
        
        wait;
        
    end process;
    
end tb;
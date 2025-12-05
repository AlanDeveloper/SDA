Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;

Entity PROJETO_TB is
End PROJETO_TB;

architecture tb of PROJETO_TB is
    
    component PROJETO is
        Port(
            a : in std_logic_vector(7 downto 0);
            b : in std_logic_vector(7 downto 0);
            resultado : out std_logic_vector(15 downto 0)
        );
    End component;
    
    signal a_tb : std_logic_vector(7 downto 0);
    signal b_tb : std_logic_vector(7 downto 0);
    signal resultado_tb : std_logic_vector(15 downto 0);
    
begin
    
    DUT: PROJETO port map(
        a => a_tb,
        b => b_tb,
        resultado => resultado_tb
    );
    
    process
    begin
        
        -- ===== TESTE 1: 5 x 3 = 15 =====
        report "TESTE 1: 5 x 3";
        a_tb <= "00000101";  -- 5
        b_tb <= "00000011";  -- 3
        wait for 10 ns;
        report "Resultado: " & integer'image(conv_integer(resultado_tb)) & " (esperado 15)";
        
        -- ===== TESTE 2: 10 x 10 = 100 =====
        report "TESTE 2: 10 x 10";
        a_tb <= "00001010";  -- 10
        b_tb <= "00001010";  -- 10
        wait for 10 ns;
        report "Resultado: " & integer'image(conv_integer(resultado_tb)) & " (esperado 100)";
        
        -- ===== TESTE 3: 255 x 255 = 65025 =====
        report "TESTE 3: 255 x 255";
        a_tb <= "11111111";  -- 255
        b_tb <= "11111111";  -- 255
        wait for 10 ns;
        report "Resultado: " & integer'image(conv_integer(resultado_tb)) & " (esperado 65025)";
        
        -- ===== TESTE 4: 0 x 100 = 0 =====
        report "TESTE 4: 0 x 100";
        a_tb <= "00000000";  -- 0
        b_tb <= "01100100";  -- 100
        wait for 10 ns;
        report "Resultado: " & integer'image(conv_integer(resultado_tb)) & " (esperado 0)";
        
        -- ===== TESTE 5: 7 x 7 = 49 =====
        report "TESTE 5: 7 x 7";
        a_tb <= "00000111";  -- 7
        b_tb <= "00000111";  -- 7
        wait for 10 ns;
        report "Resultado: " & integer'image(conv_integer(resultado_tb)) & " (esperado 49)";
        
        -- ===== TESTE 6: 52 x 38 = 1976 =====
        report "TESTE 6: 52 x 38";
        a_tb <= "00110100";  -- 52
        b_tb <= "00100110";  -- 38
        wait for 10 ns;
        report "Resultado: " & integer'image(conv_integer(resultado_tb)) & " (esperado 1976)";
        
        -- ===== TESTE 7: 199 x 109 = 21691 =====
        report "TESTE 7: 199 x 109";
        a_tb <= "11000111";  -- 199
        b_tb <= "01101101";  -- 109
        wait for 10 ns;
        report "Resultado: " & integer'image(conv_integer(resultado_tb)) & " (esperado 21691)";
        
        -- ===== TESTE 8: 15 x 15 = 225 =====
        report "TESTE 8: 15 x 15";
        a_tb <= "00001111";  -- 15
        b_tb <= "00001111";  -- 15
        wait for 10 ns;
        report "Resultado: " & integer'image(conv_integer(resultado_tb)) & " (esperado 225)";
        
        report "======================================";
        report "TODOS OS TESTES CONCLUIDOS!";
        report "======================================";
        
        wait;
        
    end process;
    
end tb;
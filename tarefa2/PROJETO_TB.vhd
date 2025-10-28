library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PROJETO_TB is
end PROJETO_TB;

architecture Behavioral of PROJETO_TB is
    component PROJETO
        Port ( 
            clock    : in  STD_LOGIC;
            reset    : in  STD_LOGIC;
            data_in  : in  STD_LOGIC_VECTOR(31 downto 0);
            control  : in  STD_LOGIC_VECTOR(18 downto 0);
            data_out : out STD_LOGIC_VECTOR(31 downto 0);
            overflow : out STD_LOGIC;
            carry    : out STD_LOGIC;
            negative : out STD_LOGIC;
            zero     : out STD_LOGIC
        );
    end component;
    
    signal clock    : STD_LOGIC := '0';
    signal reset    : STD_LOGIC := '0';
    signal data_in  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal control  : STD_LOGIC_VECTOR(18 downto 0) := (others => '0');
    signal data_out : STD_LOGIC_VECTOR(31 downto 0);
    signal overflow : STD_LOGIC;
    signal carry    : STD_LOGIC;
    signal negative : STD_LOGIC;
    signal zero     : STD_LOGIC;
    
    constant CLK_PERIOD : time := 10 ns;
    
begin
    UUT: PROJETO
        port map (
            clock    => clock,
            reset    => reset,
            data_in  => data_in,
            control  => control,
            data_out => data_out,
            overflow => overflow,
            carry    => carry,
            negative => negative,
            zero     => zero
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
        -- TESTE 1: R0 <- 10
        -----------------------------------------------------------------
        report "TESTE 1: R0 <- 10";
        data_in <= X"0000000A";
        control <= "0000000001000000001"; -- DS=000, LE=1, MD=1
        wait until rising_edge(clock);
        control <= "0000000000000000000"; -- BS=000 para ler R0
        wait until rising_edge(clock);
        assert data_out = X"0000000A"
            report "ERRO TESTE 1: R0 deveria ser 0x0A"
            severity error;
        
        -----------------------------------------------------------------
        -- TESTE 2: R1 <- 15
        -----------------------------------------------------------------
        report "TESTE 2: R1 <- 15";
        data_in <= X"0000000F";
        control <= "0000000011000000001"; -- DS=001, LE=1, MD=1
        wait until rising_edge(clock);
        control <= "0000010000000000000"; -- BS=001 para ler R1
        wait until rising_edge(clock);
        assert data_out = X"0000000F"
            report "ERRO TESTE 2: R1 deveria ser 0x0F"
            severity error;
        
        -----------------------------------------------------------------
        -- TESTE 3: R2 <- R0 + R1
        -----------------------------------------------------------------
        report "TESTE 3: R2 <- R0 + R1";
        control <= "0000010101000100000"; -- A=R0, B=R1, DS=010, GS=0010 (A+B)
        wait until rising_edge(clock);
        control <= "0000100000000000000";
        wait until rising_edge(clock);
        assert data_out = X"00000019"
            report "ERRO TESTE 3: R2 deveria ser 0x19"
            severity error;
        
        -----------------------------------------------------------------
        -- TESTE 4: R3 <- R0 - R1
        -----------------------------------------------------------------
        report "TESTE 4: R3 <- R0 - R1";
        control <= "0000010111001000000"; -- A=R0, B=R1, DS=011, GS=0100 (A-B)
        wait until rising_edge(clock);
        control <= "0000110000000000000";
        wait until rising_edge(clock);
        assert data_out = X"FFFFFFFB"
            report "ERRO TESTE 4: R3 deveria ser 0xFFFFFFFB"
            severity error;
        
        -----------------------------------------------------------------
        -- TESTE 5: R4 <- R0 + 2
        -----------------------------------------------------------------
        report "TESTE 5: R4 <- R0 + 2";
        data_in <= X"00000002";
        control <= "0000001001001010000"; -- A=R0, DS=100, GS=0101 (A+2)
        wait until rising_edge(clock);
        control <= "0001000000000000000";
        wait until rising_edge(clock);
        assert data_out = X"0000000C"
            report "ERRO TESTE 5: R4 deveria ser 0x0C"
            severity error;
        
        -----------------------------------------------------------------
        -- TESTE 6: R5 <- R2 xor R1
        -----------------------------------------------------------------
        report "TESTE 6: R5 <- R2 xor R1";
        control <= "0100011011010100000"; -- A=R2, B=R1, DS=101, GS=1010 (xor)
        wait until rising_edge(clock);
        control <= "0001010000000000000";
        wait until rising_edge(clock);
        assert data_out = X"00000016"
            report "ERRO TESTE 6: R5 deveria ser 0x16"
            severity error;
        
        -----------------------------------------------------------------
        -- TESTE 7: R6 <- R2 and R1
        -----------------------------------------------------------------
        report "TESTE 7: R6 <- R2 and R1";
        control <= "0100011101010000000"; -- A=R2, B=R1, DS=110, GS=1000 (and)
        wait until rising_edge(clock);
        control <= "0001100000000000000";
        wait until rising_edge(clock);
        assert data_out = X"00000009"
            report "ERRO TESTE 7: R6 deveria ser 0x09"
            severity error;
        
        -----------------------------------------------------------------
        -- TESTE 8: R7 <- sll R2
        -----------------------------------------------------------------
        report "TESTE 8: R7 <- sll R2";
        control <= "0000101111000000110"; -- B=R2, DS=111, HS=01, MF=1
        wait until rising_edge(clock);
        control <= "0001110000000000000";
        wait until rising_edge(clock);
        assert data_out = X"00000032"
            report "ERRO TESTE 8: R7 deveria ser 0x32"
            severity error;
        
        -----------------------------------------------------------------
        -- TESTE 9: R6 <- srl R6
        -----------------------------------------------------------------
        report "TESTE 9: R6 <- srl R6";
        control <= "0001101101000001010"; -- B=R6, DS=110, HS=10, MF=1
        wait until rising_edge(clock);
        control <= "0001100000000000000";
        wait until rising_edge(clock);
        assert data_out = X"00000004"
            report "ERRO TESTE 9: R6 deveria ser 0x04"
            severity error;
        
        -----------------------------------------------------------------
        -- TESTE 10: R2 <- R2 + (not R1)
        -----------------------------------------------------------------
        report "TESTE 10: R2 <- R2 + (not R1)";
        control <= "0100010101001100000"; -- GS=0110 (A + not B)
        wait until rising_edge(clock);
        control <= "0000100000000000000";
        wait until rising_edge(clock);
        assert data_out = X"00000009"
            report "ERRO TESTE 10: R2 deveria ser 0x09"
            severity error;
        
        -----------------------------------------------------------------
        -- TESTE 11: R0 <- R2 xor (not R3)
        -----------------------------------------------------------------
        report "TESTE 11: R0 <- R2 xor (not R3)";
        control <= "0100110001011110000"; -- GS=1111 (A xor not B)
        wait until rising_edge(clock);
        control <= "0000000000000000000";
        wait until rising_edge(clock);
        assert data_out = X"0000000D"
            report "ERRO TESTE 11: R0 deveria ser 0x0D"
            severity error;
        
        -----------------------------------------------------------------
        -- TESTE 12: R1 <- not R0
        -----------------------------------------------------------------
        report "TESTE 12: R1 <- not R0";
        control <= "0000000011010110000"; -- GS=1011 (not A)
        wait until rising_edge(clock);
        control <= "0000010000000000000";
        wait until rising_edge(clock);
        assert data_out = X"FFFFFFF2"
            report "ERRO TESTE 12: R1 deveria ser 0xFFFFFFF2"
            severity error;
        
        -----------------------------------------------------------------
        -- TESTE 13: R4 <- R2 or (not R0)
        -----------------------------------------------------------------
        report "TESTE 13: R4 <- R2 or (not R0)";
        control <= "0100001001011010000"; -- GS=1101 (A or not B)
        wait until rising_edge(clock);
        control <= "0001000000000000000";
        wait until rising_edge(clock);
        assert data_out = X"FFFFFFFB"
            report "ERRO TESTE 13: R4 deveria ser 0xFFFFFFFB"
            severity error;
        
        report "===== TODOS OS TESTES PASSARAM =====";
        wait;
    end process;
    
end Behavioral;

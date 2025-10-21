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
    signal data_out : STD_LOGIC_VECTOR(31 downto 0);
    signal overflow : STD_LOGIC;
    signal carry    : STD_LOGIC;
    signal negative : STD_LOGIC;
    signal zero     : STD_LOGIC;
    
    constant CLK_PERIOD : time := 10 ns;
    
begin
    -- Instancia o DUT (Device Under Test)
    UUT: PROJETO
        port map (
            clock    => clock,
            reset    => reset,
            data_in  => data_in,
            data_out => data_out,
            overflow => overflow,
            carry    => carry,
            negative => negative,
            zero     => zero
        );
    
    -- Gerador de clock
    clk_process: process
    begin
        clock <= '0';
        wait for CLK_PERIOD/2;
        clock <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    -- Processo de teste
    test_process: process
    begin
        report "===== INICIANDO TESTES =====";
        
        -- Reset inicial
        reset <= '1';
        wait for CLK_PERIOD * 2;
        reset <= '0';
        wait for CLK_PERIOD;
        
        report "TESTE 1: Carregar constante 0x00000005 no R0";
        -- Formato: [18:16]=A, [15:13]=B, [12:10]=Dest, [9]=En, [8]=MB, [7:4]=ALU, [3:2]=Shift, [1]=MF, [0]=MD
        -- MD=1 (bit 0), Enable=1 (bit 9), Destino=R0 (bits 12:10 = 000)
        data_in <= X"00000205";  -- bit 9=1 (enable), bit 0=1 (MD=imediato)
        wait for CLK_PERIOD;
        report "R0 deve conter: 0x00000205";
        
        report "TESTE 2: Carregar constante 0x00000003 no R1";
        data_in <= X"00000603";  -- bits 12:10=001 (R1), bit 9=1, bit 0=1
        wait for CLK_PERIOD;
        report "R1 deve conter: 0x00000603";
        
        report "TESTE 3: Carregar constante 0x0000000A no R2";
        data_in <= X"00000A0A";  -- bits 12:10=010 (R2), bit 9=1, bit 0=1
        wait for CLK_PERIOD;
        report "R2 deve conter: 0x00000A0A";
        
        report "TESTE 4: ADD R0 + R1 -> R3";
        -- A=R0 (000), B=R1 (001), Dest=R3 (011), Enable=1, MB=0 (usar B), ALU=0010 (ADD), MF=0 (ALU), MD=0 (resultado)
        -- Formato: [18:16]=000, [15:13]=001, [12:10]=011, [9]=1, [8]=0, [7:4]=0010, [3:2]=00, [1]=0, [0]=0
        data_in <= "000" & "001" & "011" & "1" & "0" & "0010" & "00" & "0" & "0";
        wait for CLK_PERIOD;
        report "R3 deve conter: R0 + R1 = 0x00000205 + 0x00000603 = 0x00000808";
        
        report "TESTE 5: SUB R2 - R1 -> R4";
        -- A=R2 (010), B=R1 (001), Dest=R4 (100), ALU=0100 (SUB)
        data_in <= "010" & "001" & "100" & "1" & "0" & "0100" & "00" & "0" & "0";
        wait for CLK_PERIOD;
        report "R4 deve conter: R2 - R1 = 0x00000A0A - 0x00000603 = 0x00000407";
        
        report "TESTE 6: AND R0 AND R1 -> R5";
        -- ALU=1000 (AND)
        data_in <= "000" & "001" & "101" & "1" & "0" & "1000" & "00" & "0" & "0";
        wait for CLK_PERIOD;
        report "R5 deve conter: R0 AND R1 = 0x00000205 AND 0x00000603 = 0x00000201";
        
        report "TESTE 7: OR R0 OR R2 -> R6";
        -- ALU=1001 (OR)
        data_in <= "000" & "010" & "110" & "1" & "0" & "1001" & "00" & "0" & "0";
        wait for CLK_PERIOD;
        report "R6 deve conter: R0 OR R2 = 0x00000205 OR 0x00000A0A = 0x00000A0F";
        
        report "TESTE 8: XOR R1 XOR R2 -> R7";
        -- ALU=1010 (XOR)
        data_in <= "001" & "010" & "111" & "1" & "0" & "1010" & "00" & "0" & "0";
        wait for CLK_PERIOD;
        report "R7 deve conter: R1 XOR R2 = 0x00000603 XOR 0x00000A0A = 0x00000C09";
        
        report "TESTE 9: Shift Left R0 -> R0";
        -- Shifter=01 (left), MF=1 (shifter)
        data_in <= "000" & "000" & "000" & "1" & "0" & "0000" & "01" & "1" & "0";
        wait for CLK_PERIOD;
        report "R0 deve conter: 0x00000205 << 1 = 0x0000040A";
        
        report "TESTE 10: Shift Right R2 -> R2";
        -- Shifter=10 (right)
        data_in <= "010" & "010" & "010" & "1" & "0" & "0000" & "10" & "1" & "0";
        wait for CLK_PERIOD;
        report "R2 deve conter: 0x00000A0A >> 1 = 0x00000505";
        
        report "TESTE 11: ADD R0 + constante 0x00000010 -> R1";
        -- MB=1 (usar data_in como constante), ALU=0010 (ADD), MD=0 (resultado ALU)
        data_in <= "000" & "000" & "001" & "1" & "1" & "0010" & "00" & "0" & "0";
        data_in(7 downto 0) <= X"10";  -- constante nos bits baixos
        wait for CLK_PERIOD;
        report "R1 deve conter: R0 + 0x10 (aproximadamente)";
        
        report "TESTE 12: Verificar flags com operação que resulta em zero";
        -- Carregar 0 em R0
        data_in <= X"00000001";  -- MD=1, valor = 0
        wait for CLK_PERIOD;
        -- Fazer R0 + R0 (0+0=0)
        data_in <= "000" & "000" & "000" & "1" & "0" & "0010" & "00" & "0" & "0";
        wait for CLK_PERIOD;
        report "Flag ZERO deve estar ativa";
        
        report "===== TESTES FINALIZADOS =====";
        wait;
    end process;
    
end Behavioral;
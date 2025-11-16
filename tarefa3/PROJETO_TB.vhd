library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

entity PROJETO_TB is
end PROJETO_TB;

architecture Behavioral of PROJETO_TB is
    
    component PROJETO
        Port ( 
            clock    : in  STD_LOGIC;
            reset    : in  STD_LOGIC;
            data_in  : in  STD_LOGIC_VECTOR(31 downto 0);
            control  : in  STD_LOGIC_VECTOR(21 downto 0);
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
    signal control  : STD_LOGIC_VECTOR(21 downto 0) := (others => '0');
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
    
    -- Gerador de clock
    clk_process: process
    begin
        clock <= '0';
        wait for CLK_PERIOD/2;
        clock <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    -- Processo de teste com leitura/escrita de arquivos
    test_process: process
        file input_file : TEXT;
        file output_file : TEXT;
        variable line_in : LINE;
        variable line_out : LINE;
        variable control_var : STD_LOGIC_VECTOR(21 downto 0);
        variable data_in_var : STD_LOGIC_VECTOR(31 downto 0);
        variable open_status : FILE_OPEN_STATUS;
        variable test_count : INTEGER := 0;
        variable char : CHARACTER;
        variable is_comment : BOOLEAN;
        type reg_array is array (0 to 15) of INTEGER;
        variable reg_values : reg_array := (others => 0);
        
    begin
        report "===== INICIANDO TESTES COM ARQUIVOS =====" severity NOTE;
        
        -- Abre arquivo de entrada
        file_open(open_status, input_file, "entrada_dados.txt", READ_MODE);
        if open_status /= OPEN_OK then
            report "ERRO: Nao foi possivel abrir entrada_dados.txt" severity ERROR;
            wait;
        end if;
        
        -- Abre arquivo de saÃ­da
        file_open(open_status, output_file, "saida_dados.txt", WRITE_MODE);
        if open_status /= OPEN_OK then
            report "ERRO: Nao foi possivel abrir saida_dados.txt" severity ERROR;
            wait;
        end if;
        
        -- Reset inicial
        reset <= '1';
        wait for CLK_PERIOD * 2;
        reset <= '0';
        wait for CLK_PERIOD;
        
        -- CabeÃ§alho do arquivo de saÃ­da
        write(line_out, STRING'("Control                 | Data_In                 | Data_Out                | OF | CY | NG | ZR"));
        writeline(output_file, line_out);
        write(line_out, STRING'("---------------------------------------------------------------------------"));
        writeline(output_file, line_out);
        
        -- LÃª arquivo de entrada linha por linha
        while not endfile(input_file) loop
            readline(input_file, line_in);
            
            -- Verifica se a linha nÃ£o estÃ¡ vazia
            if line_in'length > 0 then
                -- Verifica se Ã© comentÃ¡rio (comeÃ§a com --)
                is_comment := FALSE;
                if line_in(1) = '-' and line_in'length > 1 then
                    if line_in(2) = '-' then
                        is_comment := TRUE;
                    end if;
                end if;
                
                if not is_comment then
                    -- Tenta ler control (32 bits)
                    if line_in'length > 0 then
                        read(line_in, control_var);
                        
                        -- Tenta ler data_in (32 bits) - se nÃ£o houver, usa zero
                        if line_in'length > 0 then
                            read(line_in, data_in_var);
                        else
                            data_in_var := (others => '0');
                        end if;
                        
                        -- Aplica as entradas
                        control <= control_var;
                        data_in <= data_in_var;
                        wait until rising_edge(clock);
                        
                        -- Escreve resultado no arquivo de saÃ­da
                        write(line_out, control_var);
                        write(line_out, STRING'(" | "));
                        write(line_out, data_in_var);
                        write(line_out, STRING'(" | "));
                        write(line_out, data_out);
                        write(line_out, STRING'(" |  "));
                        write(line_out, overflow);
                        write(line_out, STRING'("  |  "));
                        write(line_out, carry);
                        write(line_out, STRING'("  |  "));
                        write(line_out, negative);
                        write(line_out, STRING'("  |  "));
                        write(line_out, zero);
                        writeline(output_file, line_out);
                        
                        test_count := test_count + 1;
                        report "Teste " & INTEGER'image(test_count) & " executado" severity NOTE;
                    end if;
                end if;
            end if;
        end loop;
        
        -- Fecha os arquivos
        file_close(input_file);
        
        -- ===== LEITURA DOS VALORES FINAIS DOS REGISTRADORES =====
        for i in 0 to 15 loop
            control_var := (others => '0');
            control_var(17 downto 14) := STD_LOGIC_VECTOR(TO_UNSIGNED(i, 4));
            
            control <= control_var;
            data_in <= (others => '0');
            wait until rising_edge(clock);
            
            reg_values(i) := TO_INTEGER(SIGNED(data_out));
        end loop;
        
        -- Relatório final em tabela
        write(line_out, STRING'(""));
        writeline(output_file, line_out);
        write(line_out, STRING'("====== RESUMO TABULAR ======"));
        writeline(output_file, line_out);
        write(line_out, STRING'(""));
        writeline(output_file, line_out);
        write(line_out, STRING'("R0  | R1  | R2   | R3  | R4   | R5  | R6  | R7  | R8  | R9   | R10 | R11  | R12  | R13 | R14  | R15 "));
        writeline(output_file, line_out);
        write(line_out, STRING'("----|-----|------|-----|------|-----|-----|-----|-----|------|-----|------|-----|------|------|------"));
        writeline(output_file, line_out);
        
        write(line_out, INTEGER'image(reg_values(0)), RIGHT, 3);
        write(line_out, STRING'(" | "));
        write(line_out, INTEGER'image(reg_values(1)), RIGHT, 3);
        write(line_out, STRING'(" | "));
        write(line_out, INTEGER'image(reg_values(2)), RIGHT, 4);
        write(line_out, STRING'(" | "));
        write(line_out, INTEGER'image(reg_values(3)), RIGHT, 3);
        write(line_out, STRING'(" | "));
        write(line_out, INTEGER'image(reg_values(4)), RIGHT, 4);
        write(line_out, STRING'(" | "));
        write(line_out, INTEGER'image(reg_values(5)), RIGHT, 3);
        write(line_out, STRING'(" | "));
        write(line_out, INTEGER'image(reg_values(6)), RIGHT, 3);
        write(line_out, STRING'(" | "));
        write(line_out, INTEGER'image(reg_values(7)), RIGHT, 4);
        write(line_out, STRING'(" | "));
        write(line_out, INTEGER'image(reg_values(8)), RIGHT, 3);
        write(line_out, STRING'(" | "));
        write(line_out, INTEGER'image(reg_values(9)), RIGHT, 4);
        write(line_out, STRING'(" | "));
        write(line_out, INTEGER'image(reg_values(10)), RIGHT, 3);
        write(line_out, STRING'(" | "));
        write(line_out, INTEGER'image(reg_values(11)), RIGHT, 4);
        write(line_out, STRING'(" | "));
        write(line_out, INTEGER'image(reg_values(12)), RIGHT, 4);
        write(line_out, STRING'(" | "));
        write(line_out, INTEGER'image(reg_values(13)), RIGHT, 3);
        write(line_out, STRING'(" | "));
        write(line_out, INTEGER'image(reg_values(14)), RIGHT, 4);
        write(line_out, STRING'(" | "));
        write(line_out, INTEGER'image(reg_values(15)), RIGHT, 3);
        writeline(output_file, line_out);
        
        file_close(output_file);
        
        report "===== TESTES CONCLUIDOS =====" severity NOTE;
        report "Total de testes executados: " & INTEGER'image(test_count) severity NOTE;
        report "Resultados salvos em saida_dados.txt" severity NOTE;
        
        wait;
    end process;
    
end Behavioral;

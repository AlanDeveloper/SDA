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

architecture estrutural of mult_sequencial is
    
    component soma16b is
        Port(
            a    : in std_logic_vector(15 downto 0);
            b    : in std_logic_vector(15 downto 0);
            s    : out std_logic_vector(15 downto 0);
            cout : out std_logic
        );
    End component;
    
    component mux2to1_16b is
        Port (
            sel    : in  STD_LOGIC;
            input0 : in  STD_LOGIC_VECTOR(15 downto 0);
            input1 : in  STD_LOGIC_VECTOR(15 downto 0);
            output : out STD_LOGIC_VECTOR(15 downto 0)
        );
    End component;
    
    type estado is (OCIOSO, OPERANDO, FINALIZADO);
    signal estado_atual : estado;
    
    signal contador : INTEGER range 0 to 8;
    signal md : STD_LOGIC_VECTOR(7 downto 0);
    signal mr : STD_LOGIC_VECTOR(7 downto 0);
    signal acc : STD_LOGIC_VECTOR(15 downto 0);
    
    signal soma_entrada : STD_LOGIC_VECTOR(15 downto 0);
    signal soma_saida : STD_LOGIC_VECTOR(15 downto 0);
    signal cout_dummy : STD_LOGIC;
    
    signal acc_shifado : STD_LOGIC_VECTOR(15 downto 0);
    signal acc_zerado : STD_LOGIC_VECTOR(15 downto 0);
    signal mux_acc_out : STD_LOGIC_VECTOR(15 downto 0);
    
begin
    
    soma_entrada <= "00000000" & md when mr(0) = '1' else (others => '0');
    
    SOMA_INST: soma16b port map(
        a    => acc,
        b    => soma_entrada,
        s    => soma_saida,
        cout => cout_dummy
    );
    
    acc_shifado <= '0' & soma_saida(15 downto 1);
    
    acc_zerado <= (others => '0');
    
    MUX_ACC_INST: mux2to1_16b port map(
        sel    => start,
        input0 => acc_zerado,
        input1 => acc_shifado,
        output => mux_acc_out
    );
    
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
                        acc <= mux_acc_out;
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
    
end estrutural;
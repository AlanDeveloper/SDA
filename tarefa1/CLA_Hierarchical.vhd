library ieee;
use ieee.std_logic_1164.all;

-- Aluno: Alan Souza dos Santos
-- Matrícula: 20102002

-- Nota: Somador feito para apenas N_BITS múltiplo de 16, abaixo disso pode resultar algum problema
-- Nota: Decidi pela criação de dois arquivos diferentes CLG4 e CLGB4, ambos possuem o mesmo código porém são usados em situações diferentes
-- CLG4: Utilizado para o cálculo dos carries individuais dos CLA4
-- CLGB4: Utilizado para o cálculo dos carries OUT dos CLA4 (c4, c8, c12, c16, c20, c24, c28, c32)

entity CLA_Hierarchical is
    generic(
        N_BITS : integer := 32  -- Múltiplo de 16
    );
    port(
        a    : in  std_logic_vector(N_BITS-1 downto 0);
        b    : in  std_logic_vector(N_BITS-1 downto 0);
        cin  : in  std_logic;
        s    : out std_logic_vector(N_BITS-1 downto 0);
        cout : out std_logic
    );
end entity CLA_Hierarchical;

architecture Arc of CLA_Hierarchical is
    
    component CLA4 is
        port(
            a     : in  std_logic_vector(3 downto 0);
            b     : in  std_logic_vector(3 downto 0);
            cin   : in  std_logic;
            s     : out std_logic_vector(3 downto 0);
            P_out : out std_logic;
            G_out : out std_logic;
            c4    : out std_logic
        );
    end component CLA4;
    
    component CLGB4 is
        port(
            P     : in  std_logic_vector(3 downto 0);
            G     : in  std_logic_vector(3 downto 0);
            c0    : in  std_logic;
            c     : out std_logic_vector(4 downto 1);
            P_out : out std_logic;
            G_out : out std_logic
        );
    end component CLGB4;
    
    constant NUM_CLA4 : integer := N_BITS / 4;
    constant NUM_CLGB : integer := NUM_CLA4 / 4;
    
    signal P_blk : std_logic_vector(NUM_CLA4-1 downto 0);
    signal G_blk : std_logic_vector(NUM_CLA4-1 downto 0);
    
    type carry_array is array (0 to NUM_CLGB-1) of std_logic_vector(4 downto 1);
    signal c_clgb : carry_array;
    
    signal c_between : std_logic_vector(NUM_CLGB downto 0);
    
    type cin_array is array (0 to NUM_CLA4-1) of std_logic;
    signal cin_cla : cin_array;
    
begin
    
    c_between(0) <= cin;
    
    gen_cin: for i in 0 to NUM_CLA4-1 generate
        constant POS : integer := i mod 4;
        constant CLGB_IDX : integer := i / 4;
    begin
        gen_cin_first: if POS = 0 generate
            cin_cla(i) <= c_between(CLGB_IDX);
        end generate;
        
        gen_cin_others: if POS /= 0 generate
            cin_cla(i) <= c_clgb(CLGB_IDX)(POS);
        end generate;
    end generate gen_cin;
    
    gen_cla4: for i in 0 to NUM_CLA4-1 generate
        CLA_inst: CLA4 
            port map(
                a     => a(4*i+3 downto 4*i),
                b     => b(4*i+3 downto 4*i),
                cin   => cin_cla(i),
                s     => s(4*i+3 downto 4*i),
                P_out => P_blk(i),
                G_out => G_blk(i),
                c4    => open
            );
    end generate gen_cla4;
    
    gen_clgb: for i in 0 to NUM_CLGB-1 generate
        CLGB_inst: CLGB4 
            port map(
                P     => P_blk(4*i+3 downto 4*i),
                G     => G_blk(4*i+3 downto 4*i),
                c0    => c_between(i),
                c     => c_clgb(i),
                P_out => open,
                G_out => open
            );
        
        c_between(i+1) <= c_clgb(i)(4);
    end generate gen_clgb;
    
    cout <= c_between(NUM_CLGB);
    
end architecture Arc;

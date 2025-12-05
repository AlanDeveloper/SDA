Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;

Entity matricial is
    Port(
        a : in std_logic_vector(7 downto 0);
        b : in std_logic_vector(7 downto 0);
        p : out std_logic_vector(15 downto 0)
    );
End matricial;

architecture arq of matricial is
    
    type matriz is array(7 downto 0) of std_logic_vector(7 downto 0);
    signal pp : matriz;
    
    component soma16b is
        Port(
            a    : in std_logic_vector(15 downto 0);
            b    : in std_logic_vector(15 downto 0);
            s    : out std_logic_vector(15 downto 0);
            cout : out std_logic
        );
    End component;
    
    signal resultado_0, resultado_1, resultado_2, resultado_3 : std_logic_vector(15 downto 0);
    signal resultado_4, resultado_5, resultado_6 : std_logic_vector(15 downto 0);
    signal cout_dummy : std_logic_vector(6 downto 0);

    -- sinais m�nimos necess�rios
    signal a0, b0, b1, b2, b3, b4, b5, b6 : std_logic_vector(15 downto 0);

begin
    
    G0: for i in 0 to 7 generate
        G1: for j in 0 to 7 generate 
            pp(i)(j) <= a(i) and b(j);
        end generate;
    end generate;

    a0 <= "00000000" & pp(0);
    b0 <= "0000000" & pp(1) & "0";
    b1 <= "000000" & pp(2) & "00";
    b2 <= "00000" & pp(3) & "000";
    b3 <= "0000" & pp(4) & "0000";
    b4 <= "000" & pp(5) & "00000";
    b5 <= "00" & pp(6) & "000000";
    b6 <= "0" & pp(7) & "0000000";

    SOMA0: soma16b port map(
        a    => a0,
        b    => b0,
        s    => resultado_0,
        cout => cout_dummy(0)
    );
    
    SOMA1: soma16b port map(
        a    => resultado_0,
        b    => b1,
        s    => resultado_1,
        cout => cout_dummy(1)
    );
    
    SOMA2: soma16b port map(
        a    => resultado_1,
        b    => b2,
        s    => resultado_2,
        cout => cout_dummy(2)
    );
    
    SOMA3: soma16b port map(
        a    => resultado_2,
        b    => b3,
        s    => resultado_3,
        cout => cout_dummy(3)
    );
    
    SOMA4: soma16b port map(
        a    => resultado_3,
        b    => b4,
        s    => resultado_4,
        cout => cout_dummy(4)
    );
    
    SOMA5: soma16b port map(
        a    => resultado_4,
        b    => b5,
        s    => resultado_5,
        cout => cout_dummy(5)
    );
    
    SOMA6: soma16b port map(
        a    => resultado_5,
        b    => b6,
        s    => resultado_6,
        cout => cout_dummy(6)
    );
    
    p <= resultado_6;
    
end arq;

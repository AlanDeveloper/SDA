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
    
begin
    
    G0: for i in 0 to 7 generate
        G1: for j in 0 to 7 generate 
            pp(i)(j) <= a(i) and b(j);
        end generate;
    end generate;
    
    SOMA0: soma16b port map(
        a    => ("00000000" & pp(0)),
        b    => ("0000000" & pp(1) & "0"),
        s    => resultado_0,
        cout => cout_dummy(0)
    );
    
    SOMA1: soma16b port map(
        a    => resultado_0,
        b    => ("000000" & pp(2) & "00"),
        s    => resultado_1,
        cout => cout_dummy(1)
    );
    
    SOMA2: soma16b port map(
        a    => resultado_1,
        b    => ("00000" & pp(3) & "000"),
        s    => resultado_2,
        cout => cout_dummy(2)
    );
    
    SOMA3: soma16b port map(
        a    => resultado_2,
        b    => ("0000" & pp(4) & "0000"),
        s    => resultado_3,
        cout => cout_dummy(3)
    );
    
    SOMA4: soma16b port map(
        a    => resultado_3,
        b    => ("000" & pp(5) & "00000"),
        s    => resultado_4,
        cout => cout_dummy(4)
    );
    
    SOMA5: soma16b port map(
        a    => resultado_4,
        b    => ("00" & pp(6) & "000000"),
        s    => resultado_5,
        cout => cout_dummy(5)
    );
    
    SOMA6: soma16b port map(
        a    => resultado_5,
        b    => ("0" & pp(7) & "0000000"),
        s    => resultado_6,
        cout => cout_dummy(6)
    );
    
    p <= resultado_6;
    
end arq;
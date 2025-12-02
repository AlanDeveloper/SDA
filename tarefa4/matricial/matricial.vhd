Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;

Entity matricial is
Port(a, b : in std_logic_vector(7 downto 0);
     p : out std_logic_vector(15 downto 0)
);
End matricial;

architecture arq of matricial is
    type matriz is array(7 downto 0) of std_logic_vector(7 downto 0);
    signal pp : matriz;
    
    component soma8b is
        Port(a, b : in std_logic_vector(7 downto 0);
             s : out std_logic_vector(7 downto 0);
             cout : out std_logic
        );
    End component;
    
    signal resultado_0, resultado_1, resultado_2, resultado_3 : std_logic_vector(15 downto 0);
    signal resultado_4, resultado_5, resultado_6 : std_logic_vector(15 downto 0);
    
begin
    G0: for i in 0 to 7 generate
        G1: for j in 0 to 7 generate 
            pp(i)(j) <= a(i) and b(j);
        end generate;
    end generate;
    
    -- Estágio 1: pp(0) + (pp(1) << 1)
    resultado_0 <= ("00000000" & pp(0)) + ("0000000" & pp(1) & "0");
    
    -- Estágio 2: resultado_0 + (pp(2) << 2)
    resultado_1 <= resultado_0 + ("000000" & pp(2) & "00");
    
    -- Estágio 3: resultado_1 + (pp(3) << 3)
    resultado_2 <= resultado_1 + ("00000" & pp(3) & "000");
    
    -- Estágio 4: resultado_2 + (pp(4) << 4)
    resultado_3 <= resultado_2 + ("0000" & pp(4) & "0000");
    
    -- Estágio 5: resultado_3 + (pp(5) << 5)
    resultado_4 <= resultado_3 + ("000" & pp(5) & "00000");
    
    -- Estágio 6: resultado_4 + (pp(6) << 6)
    resultado_5 <= resultado_4 + ("00" & pp(6) & "000000");
    
    -- Estágio 7: resultado_5 + (pp(7) << 7)
    resultado_6 <= resultado_5 + ("0" & pp(7) & "0000000");
    
    p <= resultado_6;
    
end arq;

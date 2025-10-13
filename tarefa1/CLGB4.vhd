library ieee;
use ieee.std_logic_1164.all;

entity CLGB4 is
    port(
        P     : in  std_logic_vector(3 downto 0);
        G     : in  std_logic_vector(3 downto 0);
        c0    : in  std_logic;
        c     : out std_logic_vector(4 downto 1);
        P_out : out std_logic;
        G_out : out std_logic
    );
end entity CLGB4;

architecture Arc of CLGB4 is
begin
    c(1) <= G(0) or (P(0) and c0);
    c(2) <= G(1) or (P(1) and G(0)) or (P(1) and P(0) and c0);
    c(3) <= G(2) or (P(2) and G(1)) or (P(2) and P(1) and G(0)) or 
            (P(2) and P(1) and P(0) and c0);
    c(4) <= G(3) or (P(3) and G(2)) or (P(3) and P(2) and G(1)) or 
            (P(3) and P(2) and P(1) and G(0)) or (P(3) and P(2) and P(1) and P(0) and c0);
    
    P_out <= P(3) and P(2) and P(1) and P(0);
    G_out <= G(3) or (P(3) and G(2)) or (P(3) and P(2) and G(1)) or 
             (P(3) and P(2) and P(1) and G(0));
end architecture Arc;

library ieee;
use ieee.std_logic_1164.all;

entity CLG4 is
    port(
        p     : in  std_logic_vector(3 downto 0);
        g     : in  std_logic_vector(3 downto 0);
        c0    : in  std_logic;
        c     : out std_logic_vector(4 downto 1);
        P_out : out std_logic;
        G_out : out std_logic
    );
end entity CLG4;

architecture Arc of CLG4 is
begin
    
    c(1) <= g(0) or (p(0) and c0);
    
    c(2) <= g(1) or (p(1) and g(0)) or 
            (p(1) and p(0) and c0);
    
    c(3) <= g(2) or (p(2) and g(1)) or 
            (p(2) and p(1) and g(0)) or 
            (p(2) and p(1) and p(0) and c0);
    
    c(4) <= g(3) or (p(3) and g(2)) or 
            (p(3) and p(2) and g(1)) or 
            (p(3) and p(2) and p(1) and g(0)) or 
            (p(3) and p(2) and p(1) and p(0) and c0);
    
    P_out <= p(3) and p(2) and p(1) and p(0);
    
    G_out <= g(3) or (p(3) and g(2)) or 
             (p(3) and p(2) and g(1)) or 
             (p(3) and p(2) and p(1) and g(0));
    
end architecture Arc;

library ieee;
use ieee.std_logic_1164.all;

entity CLA4 is
    port(
        a     : in  std_logic_vector(3 downto 0);
        b     : in  std_logic_vector(3 downto 0);
        cin   : in  std_logic;
        s     : out std_logic_vector(3 downto 0);
        P_out : out std_logic;
        G_out : out std_logic;
        c4    : out std_logic
    );
end entity CLA4;

architecture Arc of CLA4 is
    
    component CLG4 is
        port(
            p     : in  std_logic_vector(3 downto 0);
            g     : in  std_logic_vector(3 downto 0);
            c0    : in  std_logic;
            c     : out std_logic_vector(4 downto 1);
            P_out : out std_logic;
            G_out : out std_logic
        );
    end component CLG4;
    
    signal p : std_logic_vector(3 downto 0);
    signal g : std_logic_vector(3 downto 0);
    signal c : std_logic_vector(4 downto 1);
    
begin
    
    gen_pg: for i in 0 to 3 generate
        g(i) <= a(i) and b(i);
        p(i) <= a(i) xor b(i);
    end generate gen_pg;
    
    M0: CLG4 
        port map(
            p     => p,
            g     => g,
            c0    => cin,
            c     => c,
            P_out => P_out,
            G_out => G_out
        );
    
    s(0) <= p(0) xor cin;
    s(1) <= p(1) xor c(1);
    s(2) <= p(2) xor c(2);
    s(3) <= p(3) xor c(3);
    
    c4 <= c(4);
    
end architecture Arc;

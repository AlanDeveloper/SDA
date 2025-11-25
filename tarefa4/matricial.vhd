Library IEEE;
USE IEEE.std_logic_1164.all;

Entity matricial is
Port(a,b : in std_logic_vector(7 downto 0);
     p : out std_logic_vector(15 downto 0);
);
End matricial;

architecture arq of matricial is
type matriz is array(7 downto 0) of std_logic_vector(7 downto 0); 
signal pp : matriz;

component soma8b is
Port(a,b : in std_logic_vector(7 downto 0);
     s : out std_logic_vector(7 downto 0);
	  cout : out std_logic
);
End component;

signal c : std_logic_vector(7 downto 0);
signal soma_0 : std_logic_vector(7 downto 0);

begin

-- gerador dos produtos parciais
G0: for i in 0 to 7 generate
    G1:for j in 0 to 7 generate 
           pp(i)(j) <= a(i) and b(j);
       end generate;
	 end generate;

S0: soma8b port map(a => '0'& pp(0)(7 downto 1),
                    b => pp(1),
						  s => soma_0,
						  cout => c(0));
						  
S1: soma8b port map(a => c(0)& soma_0(7 downto 1),
                    b => pp(2),
						  s => soma_1,
						  cout => c(1));

end arq;
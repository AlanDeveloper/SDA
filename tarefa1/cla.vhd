LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity cla is
port(
a, b : in std_logic_vector ( 3 downTO 0);
cin: in std_logic;
s: out std_logic_vector ( 3 downTO 0);
P_out, G_out, c4: out std_logic
);
end cla;

ARCHITECTURE Arc of cla is

component clg is
port(
	p, g : in std_logic_vector ( 3 downTO 0);
	c0: in std_logic;
	c: out std_logic_vector ( 4 downTO 1);
	P_out, G_out: out std_logic
);
end component;

signal p, g: std_logic_vector(3 downto 0);
signal c: std_logic_vector(3 downto 0);

begin

c4 <= c(3);

g(0) <= a(0) and b(0);
g(1) <= a(1) and b(1);
g(2) <= a(2) and b(2);
g(3) <= a(3) and b(3);

p(0) <= a(0) xor b(0);
p(1) <= a(1) xor b(1);
p(2) <= a(2) xor b(2);
p(3) <= a(3) xor b(3);

M0: clg port map(
	p => p,
	g => g,
	c0 => cin,
	c => c,
	P_out => P_out,
	G_out => G_out
);

s(0) <= a(0) xor b(0) xor cin; 
s(1) <= a(1) xor b(1) xor c(0);
s(2) <= a(2) xor b(2) xor c(1);
s(3) <= a(3) xor b(3) xor c(2);


end Arc;
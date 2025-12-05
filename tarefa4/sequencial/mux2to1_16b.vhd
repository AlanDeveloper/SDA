Library IEEE;
USE IEEE.std_logic_1164.all;

Entity mux2to1_16b is
    Port (
        sel    : in  STD_LOGIC;
        input0 : in  STD_LOGIC_VECTOR(15 downto 0);
        input1 : in  STD_LOGIC_VECTOR(15 downto 0);
        output : out STD_LOGIC_VECTOR(15 downto 0)
    );
End mux2to1_16b;

architecture arq of mux2to1_16b is
begin
    output <= input0 when sel = '0' else input1;
end arq;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux16to1 is
    Port (
        sel    : in  STD_LOGIC_VECTOR(3 downto 0);
        input0 : in  STD_LOGIC_VECTOR(31 downto 0);
        input1 : in  STD_LOGIC_VECTOR(31 downto 0);
        input2 : in  STD_LOGIC_VECTOR(31 downto 0);
        input3 : in  STD_LOGIC_VECTOR(31 downto 0);
        input4 : in  STD_LOGIC_VECTOR(31 downto 0);
        input5 : in  STD_LOGIC_VECTOR(31 downto 0);
        input6 : in  STD_LOGIC_VECTOR(31 downto 0);
        input7 : in  STD_LOGIC_VECTOR(31 downto 0);
        input8 : in  STD_LOGIC_VECTOR(31 downto 0);
        input9 : in  STD_LOGIC_VECTOR(31 downto 0);
        input10 : in STD_LOGIC_VECTOR(31 downto 0);
        input11 : in STD_LOGIC_VECTOR(31 downto 0);
        input12 : in STD_LOGIC_VECTOR(31 downto 0);
        input13 : in STD_LOGIC_VECTOR(31 downto 0);
        input14 : in STD_LOGIC_VECTOR(31 downto 0);
        input15 : in STD_LOGIC_VECTOR(31 downto 0);
        output : out STD_LOGIC_VECTOR(31 downto 0)
    );
end mux16to1;

architecture Arc of mux16to1 is
begin
    process(sel, 
            input0, input1, input2, input3,
            input4, input5, input6, input7,
            input8, input9, input10, input11,
            input12, input13, input14, input15)
    begin
        case sel is
            when "0000" => output <= input0;
            when "0001" => output <= input1;
            when "0010" => output <= input2;
            when "0011" => output <= input3;
            when "0100" => output <= input4;
            when "0101" => output <= input5;
            when "0110" => output <= input6;
            when "0111" => output <= input7;
            when "1000" => output <= input8;
            when "1001" => output <= input9;
            when "1010" => output <= input10;
            when "1011" => output <= input11;
            when "1100" => output <= input12;
            when "1101" => output <= input13;
            when "1110" => output <= input14;
            when "1111" => output <= input15;
            when others => output <= (others => '0');
        end case;
    end process;
end Arc;

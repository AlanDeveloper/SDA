library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux8to1 is
    Port (
        sel    : in  STD_LOGIC_VECTOR(2 downto 0);
        input0 : in  STD_LOGIC_VECTOR(31 downto 0);
        input1 : in  STD_LOGIC_VECTOR(31 downto 0);
        input2 : in  STD_LOGIC_VECTOR(31 downto 0);
        input3 : in  STD_LOGIC_VECTOR(31 downto 0);
        input4 : in  STD_LOGIC_VECTOR(31 downto 0);
        input5 : in  STD_LOGIC_VECTOR(31 downto 0);
        input6 : in  STD_LOGIC_VECTOR(31 downto 0);
        input7 : in  STD_LOGIC_VECTOR(31 downto 0);
        output : out STD_LOGIC_VECTOR(31 downto 0)
    );
end mux8to1;

architecture Arc of mux8to1 is
begin
    process(sel, input0, input1, input2, input3, input4, input5, input6, input7)
    begin
        case sel is
            when "000" => output <= input0;
            when "001" => output <= input1;
            when "010" => output <= input2;
            when "011" => output <= input3;
            when "100" => output <= input4;
            when "101" => output <= input5;
            when "110" => output <= input6;
            when "111" => output <= input7;
            when others => output <= (others => '0');
        end case;
    end process;
end Arc;
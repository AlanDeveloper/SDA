library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    Port (
        sel      : in STD_LOGIC_VECTOR(3 downto 0);
        input0   : in STD_LOGIC_VECTOR(31 downto 0);
        input1   : in STD_LOGIC_VECTOR(31 downto 0);
        output   : out STD_LOGIC_VECTOR(31 downto 0);
        overflow : out STD_LOGIC;
        carry    : out STD_LOGIC
    );
end alu;

architecture Arc of alu is
    signal result : STD_LOGIC_VECTOR(32 downto 0);  -- 33 bits para detectar carry
    signal temp_output : STD_LOGIC_VECTOR(31 downto 0);
begin
    process(sel, input0, input1)
        variable a, b : signed(32 downto 0);
        variable sum : signed(32 downto 0);
    begin
        temp_output <= (others => '0');
        overflow <= '0';
        carry <= '0';
        
        case sel is
            when "0000" => temp_output <= input0;
            when "0001" => temp_output <= input1;
            
            when "0010" =>  -- ADD
                a := resize(signed(input0), 33);
                b := resize(signed(input1), 33);
                sum := a + b;
                temp_output <= std_logic_vector(sum(31 downto 0));
                carry <= sum(32);
                overflow <= (input0(31) xor sum(31)) and (input1(31) xor sum(31));
                
            when "0011" =>  -- input0 + 1
                a := resize(signed(input0), 33);
                sum := a + 1;
                temp_output <= std_logic_vector(sum(31 downto 0));
                carry <= sum(32);
                
            when "0100" =>  -- SUB
                a := resize(signed(input0), 33);
                b := resize(signed(input1), 33);
                sum := a - b;
                temp_output <= std_logic_vector(sum(31 downto 0));
                overflow <= (input0(31) xor input1(31)) and (input0(31) xor sum(31));
                
            when "0101" =>  -- input0 + 2
                a := resize(signed(input0), 33);
                sum := a + 2;
                temp_output <= std_logic_vector(sum(31 downto 0));
                carry <= sum(32);
                
            when "0110" => temp_output <= std_logic_vector(unsigned(input0) + unsigned(not input1));
            when "0111" => temp_output <= std_logic_vector(unsigned(input0) - unsigned(not input1));
            when "1000" => temp_output <= input0 and input1;
            when "1001" => temp_output <= input0 or input1;
            when "1010" => temp_output <= input0 xor input1;
            when "1011" => temp_output <= not input0;
            when "1100" => temp_output <= not input1;
            when "1101" => temp_output <= input0 or (not input1);
            when "1110" => temp_output <= input0 and (not input1);
            when "1111" => temp_output <= input0 xor (not input1);
            when others => temp_output <= (others => '0');
        end case;
    end process;
    
    output <= temp_output;
end Arc;
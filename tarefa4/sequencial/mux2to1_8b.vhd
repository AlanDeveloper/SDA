Library IEEE;
USE IEEE.std_logic_1164.all;

Entity mux2to1_8b is
    Port (
        sel    : in  STD_LOGIC;
        input0 : in  STD_LOGIC_VECTOR(7 downto 0);
        input1 : in  STD_LOGIC_VECTOR(7 downto 0);
        output : out STD_LOGIC_VECTOR(7 downto 0)
    );
End mux2to1_8b;

architecture Arc of mux2to1_8b is
begin
    process(sel, input0, input1)
    begin
        case sel is
            when '0' => output <= input0;
            when '1' => output <= input1;
            when others => output <= (others => '0');
        end case;
    end process;
end Arc;
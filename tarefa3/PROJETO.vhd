library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PROJETO is
    Port ( 
        clock    : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        data_in  : in  STD_LOGIC_VECTOR(31 downto 0);
		  control  : in  STD_LOGIC_VECTOR(21 downto 0);
        data_out : out STD_LOGIC_VECTOR(31 downto 0);
		  overflow : out STD_LOGIC;
		  carry    : out STD_LOGIC;
		  negative : out STD_LOGIC;
		  zero     : out STD_LOGIC
    );
end PROJETO;

architecture Arc of PROJETO is
    component register32BITS
        Port ( 
            clock  : in  STD_LOGIC;
            reset  : in  STD_LOGIC;
            enable : in  STD_LOGIC;
            d_in   : in  STD_LOGIC_VECTOR(31 downto 0);
            d_out  : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
	 
    component mux16to1
        Port (
            sel     : in  STD_LOGIC_VECTOR(3 downto 0);
            input0  : in  STD_LOGIC_VECTOR(31 downto 0);
            input1  : in  STD_LOGIC_VECTOR(31 downto 0);
            input2  : in  STD_LOGIC_VECTOR(31 downto 0);
            input3  : in  STD_LOGIC_VECTOR(31 downto 0);
            input4  : in  STD_LOGIC_VECTOR(31 downto 0);
            input5  : in  STD_LOGIC_VECTOR(31 downto 0);
            input6  : in  STD_LOGIC_VECTOR(31 downto 0);
            input7  : in  STD_LOGIC_VECTOR(31 downto 0);
				input8  : in  STD_LOGIC_VECTOR(31 downto 0);
				input9  : in  STD_LOGIC_VECTOR(31 downto 0);
				input10 : in  STD_LOGIC_VECTOR(31 downto 0);
				input11 : in  STD_LOGIC_VECTOR(31 downto 0);
				input12 : in  STD_LOGIC_VECTOR(31 downto 0);
				input13 : in  STD_LOGIC_VECTOR(31 downto 0);
				input14 : in  STD_LOGIC_VECTOR(31 downto 0);
				input15 : in  STD_LOGIC_VECTOR(31 downto 0);
            output : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
	 
    component mux2to1
        Port (
            sel    : in  STD_LOGIC;
            input0 : in  STD_LOGIC_VECTOR(31 downto 0);
            input1 : in  STD_LOGIC_VECTOR(31 downto 0);
            output : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    component decoder4to16
        Port (
            input  : in  STD_LOGIC_VECTOR(3 downto 0);
            output : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;
	 
	 component alu
		  Port (
			   sel      : in STD_LOGIC_VECTOR(3 downto 0);
			   input0   : in STD_LOGIC_VECTOR(31 downto 0);
			   input1   : in STD_LOGIC_VECTOR(31 downto 0);
			   output   : out STD_LOGIC_VECTOR(31 downto 0);
				overflow : out STD_LOGIC;
				carry    : out STD_LOGIC
		  );
	 end component;
	 
	 component shifter
		  Port (
			   sel    : in STD_LOGIC_VECTOR(1 downto 0);
		 	   input  : in STD_LOGIC_VECTOR(31 downto 0);
			   output : out STD_LOGIC_VECTOR(31 downto 0)
		  );
	 end component;
    
    type reg_array is array (0 to 15) of STD_LOGIC_VECTOR(31 downto 0);
    signal reg_outputs : reg_array;
    signal reg_enables : STD_LOGIC_VECTOR(15 downto 0);
	 
    signal out_a       : STD_LOGIC_VECTOR(31 downto 0);
    signal out_b       : STD_LOGIC_VECTOR(31 downto 0);
    signal out_mb      : STD_LOGIC_VECTOR(31 downto 0);
	 signal decoder_sel : STD_LOGIC_VECTOR(3 downto 0);
	 signal decoder_out : STD_LOGIC_VECTOR(15 downto 0);
	 signal out_alu     : STD_LOGIC_VECTOR(31 downto 0);
	 signal out_shifter : STD_LOGIC_VECTOR(31 downto 0);
	 signal out_mf      : STD_LOGIC_VECTOR(31 downto 0);
	 signal out_md      : STD_LOGIC_VECTOR(31 downto 0);
begin
    decoder_sel <= control(13 downto 10);
	 negative    <= out_alu(31);
    zero        <= '1' when out_alu = X"00000000" else '0';
	 data_out    <= out_mb;
	 
    -- Decoder 4 para 16: converte 4 bits em 16 saídas one-hot
    DECODER: decoder4to16
        port map (
            input  => decoder_sel,
            output => decoder_out
        );
    
    -- Gera enables individuais: decoder_out AND enable geral
    GEN_ENABLES: for i in 0 to 15 generate
        reg_enables(i) <= decoder_out(i) AND control(9);
    end generate GEN_ENABLES;
    
    -- Gera os 8 registradores com enable individual
    GEN_REGISTERS: for i in 0 to 15 generate
        REG: register32BITS
            port map (
                clock  => clock,
                reset  => reset,
                enable => reg_enables(i),
                d_in   => out_md,
                d_out  => reg_outputs(i)
            );
    end generate GEN_REGISTERS;
	 
    -- MUX A: Seleciona registrador A usando bits 21:18
    MUXA: mux16to1 
        port map (
            sel     => control(21 downto 18),
            input0  => reg_outputs(0),
            input1  => reg_outputs(1),
            input2  => reg_outputs(2),
            input3  => reg_outputs(3),
            input4  => reg_outputs(4),
            input5  => reg_outputs(5),
            input6  => reg_outputs(6),
            input7  => reg_outputs(7),
				input8  => reg_outputs(8),
				input9  => reg_outputs(9),
				input10 => reg_outputs(10),
				input11 => reg_outputs(11),
				input12 => reg_outputs(12),
				input13 => reg_outputs(13),
				input14 => reg_outputs(14),
				input15 => reg_outputs(15),
            output  => out_a
        );
	 
    -- MUX B: Seleciona registrador B usando bits 17:14
    MUXB: mux16to1 
        port map (
            sel     => control(17 downto 14),
            input0  => reg_outputs(0),
            input1  => reg_outputs(1),
            input2  => reg_outputs(2),
            input3  => reg_outputs(3),
            input4  => reg_outputs(4),
            input5  => reg_outputs(5),
            input6  => reg_outputs(6),
            input7  => reg_outputs(7),
				input8  => reg_outputs(8),
				input9  => reg_outputs(9),
				input10 => reg_outputs(10),
				input11 => reg_outputs(11),
				input12 => reg_outputs(12),
				input13 => reg_outputs(13),
				input14 => reg_outputs(14),
				input15 => reg_outputs(15),
            output  => out_b
        );
		  
    -- MUX MB: Seleciona entre out_b ou data_in usando bit 8
    MUXMB: mux2to1 
        port map (
            sel    => control(8),
            input0 => out_b,
            input1 => data_in,
            output => out_mb
        );

    -- ALU INST: Realiza a operação sobre out_a e out_mb
	 ALU_INST: alu
		  port map (
				sel      => control(7 downto 4),
				input0   => out_a,
				input1   => out_mb,
				output   => out_alu,
				overflow => overflow,
				carry    => carry
		  );
    
	 -- SHIFTER INST: Realiza o deslocamento sobre out_mb
	 SHIFTER_INST: shifter
		  port map (
				sel    => control(3 downto 2),
				input  => out_mb,
				output => out_shifter
		  );
		  
	 -- MUX MF: Seleciona entre out_alu e out_shifter
    MUXMF: mux2to1 
        port map (
            sel    => control(1),
            input0 => out_alu,
            input1 => out_shifter,
            output => out_mf
        );	
		  
	 -- MUX MD: Seleciona entre out_mf e data_in
    MUXMD: mux2to1 
        port map (
            sel    => control(0),
            input0 => out_mf,
            input1 => data_in,
            output => out_md
        );
		  
end Arc;
vcom -work work -2002 -explicit alu.vhd
vcom -work work -2002 -explicit decoder3to8.vhd
vcom -work work -2002 -explicit mux2to1.vhd
vcom -work work -2002 -explicit mux8to1.vhd
vcom -work work -2002 -explicit PROJETO.vhd
vcom -work work -2002 -explicit register32BITS.vhd
vcom -work work -2002 -explicit shifter.vhd
vcom -work work -2002 -explicit PROJETO_TB.vhd
vsim -gui work.projeto_tb
do wave.do
run 285 ns
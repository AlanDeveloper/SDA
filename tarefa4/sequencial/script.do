vcom -work work -2002 -explicit PROJETO.vhd
vcom -work work -2002 -explicit matricial.vhd
vcom -work work -2002 -explicit soma8b.vhd
vcom -work work -2002 -explicit PROJETO_TB.vhd
vsim -gui work.projeto_tb
do wave.do
run 285 ns

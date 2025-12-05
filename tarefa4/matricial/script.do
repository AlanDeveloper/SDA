vcom -work matricial -2002 -explicit PROJETO.vhd
vcom -work matricial -2002 -explicit matricial.vhd
vcom -work matricial -2002 -explicit soma16b.vhd
vcom -work matricial -2002 -explicit PROJETO_TB.vhd
vsim -gui matricial.projeto_tb
do wave.do
run 85 ns

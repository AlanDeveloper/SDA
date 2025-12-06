vcom -work sequencial -2002 -explicit PROJETO.vhd
vcom -work sequencial -2002 -explicit mult_sequencial.vhd
vcom -work sequencial -2002 -explicit soma16b.vhd
vcom -work sequencial -2002 -explicit mux2to1_16b.vhd
vcom -work sequencial -2002 -explicit PROJETO_TB.vhd
vsim -gui sequencial.projeto_tb
do wave.do
run 85 ns

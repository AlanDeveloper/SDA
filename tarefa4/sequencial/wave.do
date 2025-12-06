onerror {resume}
quietly WaveActivateNextPane {} 0

# Top level do DUT
set base /PROJETO_tb/DUT

add wave -noupdate $base/rst
add wave -noupdate $base/start
add wave -noupdate $base/a
add wave -noupdate $base/b
add wave -noupdate $base/resultado
add wave -noupdate $base/pronto

TreeUpdate [SetDefaultTree]
update
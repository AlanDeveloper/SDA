onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /projeto_tb/UUT/clock
add wave -noupdate /projeto_tb/UUT/reset
add wave -noupdate /projeto_tb/UUT/data_in
add wave -noupdate /projeto_tb/UUT/control
add wave -noupdate /projeto_tb/UUT/data_out
add wave -noupdate /projeto_tb/UUT/overflow
add wave -noupdate /projeto_tb/UUT/carry
add wave -noupdate /projeto_tb/UUT/negative
add wave -noupdate /projeto_tb/UUT/zero
add wave -noupdate /projeto_tb/UUT/reg_outputs
add wave -noupdate /projeto_tb/UUT/reg_enables
add wave -noupdate /projeto_tb/UUT/out_a
add wave -noupdate /projeto_tb/UUT/out_b
add wave -noupdate /projeto_tb/UUT/out_mb
add wave -noupdate /projeto_tb/UUT/decoder_sel
add wave -noupdate /projeto_tb/UUT/decoder_out
add wave -noupdate /projeto_tb/UUT/out_alu
add wave -noupdate /projeto_tb/UUT/out_shifter
add wave -noupdate /projeto_tb/UUT/out_mf
add wave -noupdate /projeto_tb/UUT/out_md
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {35000 ps} 1} {{Cursor 2} {45183 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 352
configure wave -valuecolwidth 590
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {44713 ps} {45287 ps}

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /matricial/a
add wave -noupdate /matricial/b
add wave -noupdate /matricial/p
add wave -noupdate /matricial/pp
add wave -noupdate /matricial/resultado_0
add wave -noupdate /matricial/resultado_1
add wave -noupdate /matricial/resultado_2
add wave -noupdate /matricial/resultado_3
add wave -noupdate /matricial/resultado_4
add wave -noupdate /matricial/resultado_5
add wave -noupdate /matricial/resultado_6
add wave -noupdate /matricial/cout_dummy
add wave -noupdate /matricial/a0
add wave -noupdate /matricial/b0
add wave -noupdate /matricial/b1
add wave -noupdate /matricial/b2
add wave -noupdate /matricial/b3
add wave -noupdate /matricial/b4
add wave -noupdate /matricial/b5
add wave -noupdate /matricial/b6
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {1 ns}

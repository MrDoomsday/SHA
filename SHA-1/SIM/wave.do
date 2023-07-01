onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /unit_tb/DUT/clk
add wave -noupdate /unit_tb/DUT/reset_n
add wave -noupdate /unit_tb/DUT/o_tready_in
add wave -noupdate /unit_tb/DUT/i_tvalid_in
add wave -noupdate /unit_tb/DUT/i_data_in
add wave -noupdate /unit_tb/DUT/i_A
add wave -noupdate /unit_tb/DUT/i_B
add wave -noupdate /unit_tb/DUT/i_C
add wave -noupdate /unit_tb/DUT/i_D
add wave -noupdate /unit_tb/DUT/i_E
add wave -noupdate /unit_tb/DUT/i_tready_out
add wave -noupdate /unit_tb/DUT/o_tvalid_out
add wave -noupdate /unit_tb/DUT/o_A
add wave -noupdate /unit_tb/DUT/o_B
add wave -noupdate /unit_tb/DUT/o_C
add wave -noupdate /unit_tb/DUT/o_D
add wave -noupdate /unit_tb/DUT/o_E
add wave -noupdate /unit_tb/DUT/processing
add wave -noupdate -radix unsigned /unit_tb/DUT/iteration
add wave -noupdate /unit_tb/DUT/A_reg
add wave -noupdate /unit_tb/DUT/B_reg
add wave -noupdate /unit_tb/DUT/C_reg
add wave -noupdate /unit_tb/DUT/D_reg
add wave -noupdate /unit_tb/DUT/E_reg
add wave -noupdate /unit_tb/DUT/A_next
add wave -noupdate /unit_tb/DUT/B_next
add wave -noupdate /unit_tb/DUT/C_next
add wave -noupdate /unit_tb/DUT/D_next
add wave -noupdate /unit_tb/DUT/E_next
add wave -noupdate /unit_tb/DUT/update
add wave -noupdate /unit_tb/DUT/F
add wave -noupdate /unit_tb/DUT/Kt
add wave -noupdate /unit_tb/DUT/Wt
add wave -noupdate /unit_tb/DUT/Wt15_next
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8090 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {999 ns} {24375 ns}

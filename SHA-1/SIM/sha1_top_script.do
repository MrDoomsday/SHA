onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sha1_top_tb/DUT/clk
add wave -noupdate /sha1_top_tb/DUT/reset_n
add wave -noupdate -expand -group data_in /sha1_top_tb/DUT/o_tready
add wave -noupdate -expand -group data_in /sha1_top_tb/DUT/i_tvalid
add wave -noupdate -expand -group data_in /sha1_top_tb/DUT/i_tdata
add wave -noupdate -expand -group data_in /sha1_top_tb/DUT/i_tkeep
add wave -noupdate -expand -group data_in /sha1_top_tb/DUT/i_tlast
add wave -noupdate -expand -group sha_result /sha1_top_tb/DUT/i_sha_tready
add wave -noupdate -expand -group sha_result /sha1_top_tb/DUT/o_sha_tvalid
add wave -noupdate -expand -group sha_result /sha1_top_tb/DUT/o_sha_tdata
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/pa_ready_out
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/pa_valid_out
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/pa_data_out
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/pa_tlast_out
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/unit_ready_in
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/unit_valid_in
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/unit_data_in
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/unit_A_in
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/unit_B_in
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/unit_C_in
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/unit_D_in
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/unit_E_in
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/unit_ready_out
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/unit_valid_out
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/unit_A_out
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/unit_B_out
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/unit_C_out
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/unit_D_out
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/unit_E_out
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/A
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/B
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/C
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/D
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/E
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/state
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/state_next
add wave -noupdate -expand -group DUT /sha1_top_tb/DUT/last_reg
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/clk
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/reset_n
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/o_tready_in
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/i_tvalid_in
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/i_data_in
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/i_A
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/i_B
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/i_C
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/i_D
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/i_E
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/i_tready_out
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/o_tvalid_out
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/o_A
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/o_B
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/o_C
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/o_D
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/o_E
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/processing
add wave -noupdate -expand -group unit -radix unsigned /sha1_top_tb/DUT/sha1_unit_inst/iteration
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/A_reg
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/B_reg
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/C_reg
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/D_reg
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/E_reg
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/A_next
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/B_next
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/C_next
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/D_next
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/E_next
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/update
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/F
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/Kt
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/Wt
add wave -noupdate -expand -group unit /sha1_top_tb/DUT/sha1_unit_inst/Wt15_next
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {410 ns} 0}
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
WaveRestoreZoom {294 ns} {882 ns}

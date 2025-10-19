onerror {quit -f}
vlib work
vlog -work work FPU_32b.vo
vlog -work work FPU_32b.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.FPU_32b_vlg_vec_tst
vcd file -direction FPU_32b.msim.vcd
vcd add -internal FPU_32b_vlg_vec_tst/*
vcd add -internal FPU_32b_vlg_vec_tst/i1/*
add wave /*
run -all

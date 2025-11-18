vlog ../rtl/aes/*.sv
vlog ../rtl/*.sv
vlog *.sv
vsim work.tb_arbiter
run -all

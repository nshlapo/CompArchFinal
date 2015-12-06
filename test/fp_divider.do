vlog -reportprogress 300 -work work fp_divider.v fp_divider.t.v
vsim -voptargs="+acc" fpDividerTest
run -all
#do script
vsim -gui work.text_io_testbench -novopt
add wave sim:/text_io_testbench/*
run
run
#warnings
# ** Warning: NUMERIC_BIT.TO_SIGNED: vector truncated
#    Time: 105 ns  Iteration: 0  Instance: /text_io_testbench
# ** Warning: NUMERIC_BIT.TO_SIGNED: vector truncated
#    Time: 135 ns  Iteration: 0  Instance: /text_io_testbench
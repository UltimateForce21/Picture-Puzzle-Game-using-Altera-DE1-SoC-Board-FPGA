# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog update.v

#load simulation using mux as the top level simulation module
vsim update

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

add wave {/update/D0/*}
add wave {/update/C0/current_state}
add wave {/update/C0/next_state}
add wave {/update/C0/data_prev}
add wave {/update/C0/dataChanged}
add wave {/update/C0/storedPrev}

radix -unsigned



#Clock Setting
force Clock 0 0, 1 0.5ns -repeat 1ns

force Reset 0; ########set everything to zero
force done 0
force DataIn 0
run 10 ns

force Reset 1
force done 1
run 90ns
#####Above Finished = Reset


force DataIn 001
run 10 ns
###### before 110 ns Above = r1 = 0 and current state == 1 

force done 0
force DataIn 010
run 10ns

force done 1
force DataIn 010
run 10ns
#########Above: r2 == 1 and current state == 1

force done 0
force DataIn 011
run 10ns

force done 1
force DataIn 011
run 10ns
#########Above: r3 == 2 and current state == 1

force done 0
force DataIn 100
run 10ns

force done 1
force DataIn 100
run 10ns
#########Above: r3 == 3 and current state == 1

run 100ns
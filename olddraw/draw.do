# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog draw.v

#load simulation using mux as the top level simulation module
#vsim -L altera_mf_ver draw
vsim draw

add wave -position insertpoint  \
sim:/draw/F0/current_state

add wave -position insertpoint  \
sim:/draw/F0/next_state

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}
add wave {/draw/F0/current_state}
add wave {/draw/F0/next_state}
#add wave {/draw/D0/pv_draw}
add wave {/draw/D0/pv_draw_x}
add wave {/draw/D0/pv_draw_y}

radix -unsigned



#Clock Setting
force iClock 0 0, 1 0.5ns -repeat 1ns


force draw 0
force iResetn 0
run 10ns

force iResetn 1
run 50000ns

force image_select 00
force location 00
force draw 0

run 1000ns


force image_select 00
force location 01
force draw 1

run 1000ns

force image_select 11
force location 01
force draw 0

run 1000ns

force image_select 11
force location 01
force draw 1

run 5000ns

force image_select 11
force location 01
force draw 0

run 1000ns

force image_select 11
force location 01
force draw 1

run 5000ns

force image_select 11
force location 01
force draw 0

run 1000ns

force image_select 11
force location 01
force draw 0
run 5000ns

run 10000ns



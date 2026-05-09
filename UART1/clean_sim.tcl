# Run this in Vivado TCL Console to clean and re-run simulation
# Step 1: Close any running simulation
catch {close_sim}

# Step 2: Delete the stale incremental xsim build directory
set sim_dir "D:/desktop/proj_file/UART1/UART1.sim/sim_1/behav/xsim"
if {[file exists $sim_dir]} {
    file delete -force $sim_dir
    puts "INFO: Deleted stale xsim cache: $sim_dir"
} else {
    puts "INFO: xsim cache directory not found, skipping."
}

# Step 3: Relaunch simulation fresh (no incremental)
launch_simulation

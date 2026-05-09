# ============================================================
# Run this ENTIRE script in the Vivado TCL Console
# It fixes the sim_1 fileset by removing list.sv and
# adding all the individual SV and RTL files directly.
# ============================================================

set sv_dir "D:/DFTFILES/Uart_Project_with_code/Uart_Project/uart/UART_TRANSMITTER/sv_tb"
set rtl_dir "D:/DFTFILES/Uart_Project_with_code/Uart_Project/uart/UART_TRANSMITTER/rtl"

# Step 1: Remove list.sv
catch {remove_files -fileset sim_1 [get_files -of_objects [get_filesets sim_1] "*/list.sv"]}

# Step 2: List all files
set rtl_files [list \
    "${rtl_dir}/mux.v" \
    "${rtl_dir}/parity_calc.v" \
    "${rtl_dir}/serializer.v" \
    "${rtl_dir}/tx_fsm.v" \
    "${rtl_dir}/uart_tx.v" \
]

set all_tb_files [list \
    "${sv_dir}/uart_common.sv" \
    "${sv_dir}/uart_tx.sv" \
    "${sv_dir}/uart_intf.sv" \
    "${sv_dir}/uart_sbd.sv" \
    "${sv_dir}/uart_cov.sv" \
    "${sv_dir}/uart_mon.sv" \
    "${sv_dir}/uart_bfm.sv" \
    "${sv_dir}/uart_gen.sv" \
    "${sv_dir}/uart_agent.sv" \
    "${sv_dir}/uart_env.sv" \
    "${sv_dir}/uart_top.sv" \
]

# Step 3: Add ALL files explicitly to the sim_1 fileset
add_files -fileset sim_1 -norecurse $rtl_files
add_files -fileset sim_1 -norecurse $all_tb_files

# Step 4: Ensure all are enabled for simulation
foreach f [concat $rtl_files $all_tb_files] {
    catch {
        set_property is_enabled true [get_files $f]
        set_property used_in_simulation true [get_files $f]
    }
}
puts "INFO: Added and enabled all RTL and TB files in sim_1"

# Step 5: Set uart_common.sv as a global include so macros work
set_property is_global_include true [get_files "${sv_dir}/uart_common.sv"]
puts "INFO: Set uart_common.sv as global include"

# Step 6: Set the top module explicitly
set_property top top [get_filesets sim_1]
update_compile_order -fileset sim_1
puts "INFO: Updated compile order and top module"

# Step 7: Delete stale xsim cache
set sim_dir "D:/desktop/proj_file/UART1/UART1.sim/sim_1/behav/xsim"
catch {file delete -force $sim_dir}
puts "INFO: Cleaned xsim cache"

# Step 8: Relaunch simulation
launch_simulation

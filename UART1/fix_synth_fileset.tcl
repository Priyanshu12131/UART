# ============================================================
# Run this script in the Vivado TCL Console to fix Synthesis
# It adds the RTL files to sources_1 so you can view the schematic
# ============================================================

set rtl_dir "D:/DFTFILES/Uart_Project_with_code/Uart_Project/uart/UART_TRANSMITTER/rtl"

# Step 1: List all RTL files
set rtl_files [list \
    "${rtl_dir}/mux.v" \
    "${rtl_dir}/parity_calc.v" \
    "${rtl_dir}/serializer.v" \
    "${rtl_dir}/tx_fsm.v" \
    "${rtl_dir}/uart_tx.v" \
]

# Step 2: Add files to sources_1
add_files -fileset sources_1 -norecurse $rtl_files

# Step 3: Enable them for synthesis and implementation
foreach f $rtl_files {
    catch {
        set_property is_enabled true [get_files $f]
        set_property used_in_synthesis true [get_files $f]
        set_property used_in_implementation true [get_files $f]
    }
}

# Step 4: Set the top module for synthesis to uart_tx
set_property top uart_tx [get_filesets sources_1]
update_compile_order -fileset sources_1

puts "INFO: Fixed sources_1. You can now open the elaborated design / schematic!"

# Ethernet MAC with FIFO timing constraints

foreach mac_inst [get_cells -hier -filter {(ORIG_REF_NAME == eth_mac_1g_fifo || REF_NAME == eth_mac_1g_fifo || \
            ORIG_REF_NAME == eth_mac_10g_fifo || REF_NAME == eth_mac_10g_fifo || \
            ORIG_REF_NAME == eth_mac_1g_gmii_fifo || REF_NAME == eth_mac_1g_gmii_fifo || \
            ORIG_REF_NAME == eth_mac_1g_rgmii_fifo || REF_NAME == eth_mac_1g_rgmii_fifo || \
            ORIG_REF_NAME == eth_mac_mii_fifo || REF_NAME == eth_mac_mii_fifo)}] {
    puts "Inserting timing constraints for ethernet MAC with FIFO instance $mac_inst"

    set sync_ffs [get_cells -hier -regexp ".*/rx_sync_reg_\[1234\]_reg\\\[\\d+\\\]" -filter "PARENT == $mac_inst"]

    if {[llength $sync_ffs]} {
        set_property ASYNC_REG TRUE $sync_ffs

        set src_clk [get_clocks -of_objects [get_pins $mac_inst/rx_sync_reg_1_reg[*]/C]]

        set_max_delay -from [get_cells $mac_inst/rx_sync_reg_1_reg[*]] -to [get_cells $mac_inst/rx_sync_reg_2_reg[*]] -datapath_only [get_property -min PERIOD $src_clk]
    }

    set sync_ffs [get_cells -hier -regexp ".*/tx_sync_reg_\[1234\]_reg\\\[\\d+\\\]" -filter "PARENT == $mac_inst"]

    if {[llength $sync_ffs]} {
        set_property ASYNC_REG TRUE $sync_ffs

        set src_clk [get_clocks -of_objects [get_pins $mac_inst/tx_sync_reg_1_reg[*]/C]]

        set_max_delay -from [get_cells $mac_inst/tx_sync_reg_1_reg[*]] -to [get_cells $mac_inst/tx_sync_reg_2_reg[*]] -datapath_only [get_property -min PERIOD $src_clk]
    }
}

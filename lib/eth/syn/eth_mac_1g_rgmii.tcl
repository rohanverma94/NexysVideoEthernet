# RGMII Gigabit Ethernet MAC timing constraints

foreach mac_inst [get_cells -hier -filter {(ORIG_REF_NAME == eth_mac_1g_rgmii || REF_NAME == eth_mac_1g_rgmii)}] {
    puts "Inserting timing constraints for eth_mac_1g_rgmii instance $mac_inst"

    set select_ffs [get_cells -hier -regexp ".*/tx_mii_select_sync_reg\\\[\\d\\\]" -filter "PARENT == $mac_inst"]

    if {[llength $select_ffs]} {
        set_property ASYNC_REG TRUE $select_ffs

        set src_clk [get_clocks -of_objects [get_pins $mac_inst/mii_select_reg_reg/C]]

        set_max_delay -from [get_cells $mac_inst/mii_select_reg_reg] -to [get_cells $mac_inst/tx_mii_select_sync_reg[0]] -datapath_only [get_property -min PERIOD $src_clk]
    }

    set select_ffs [get_cells -hier -regexp ".*/rx_mii_select_sync_reg\\\[\\d\\\]" -filter "PARENT == $mac_inst"]

    if {[llength $select_ffs]} {
        set_property ASYNC_REG TRUE $select_ffs

        set src_clk [get_clocks -of_objects [get_pins $mac_inst/mii_select_reg_reg/C]]

        set_max_delay -from [get_cells $mac_inst/mii_select_reg_reg] -to [get_cells $mac_inst/rx_mii_select_sync_reg[0]] -datapath_only [get_property -min PERIOD $src_clk]
    }

    set prescale_ffs [get_cells -hier -regexp ".*/rx_prescale_sync_reg\\\[\\d\\\]" -filter "PARENT == $mac_inst"]

    if {[llength $prescale_ffs]} {
        set_property ASYNC_REG TRUE $prescale_ffs

        set src_clk [get_clocks -of_objects [get_pins $mac_inst/rx_prescale_reg[2]/C]]

        set_max_delay -from [get_cells $mac_inst/rx_prescale_reg[2]] -to [get_cells $mac_inst/rx_prescale_sync_reg[0]] -datapath_only [get_property -min PERIOD $src_clk]
    }
}

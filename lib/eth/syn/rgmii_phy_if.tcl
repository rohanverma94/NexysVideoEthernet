# RGMII PHY IF timing constraints

foreach if_inst [get_cells -hier -filter {(ORIG_REF_NAME == rgmii_phy_if || REF_NAME == rgmii_phy_if)}] {
    puts "Inserting timing constraints for rgmii_phy_if instance $if_inst"

    # reset synchronization
    set reset_ffs [get_cells -hier -regexp ".*/(rx|tx)_rst_reg_reg\\\[\\d\\\]" -filter "PARENT == $if_inst"]

    set_property ASYNC_REG TRUE $reset_ffs
    set_false_path -to [get_pins -of_objects $reset_ffs -filter {IS_PRESET || IS_RESET}]

    # clock output
    set_property ASYNC_REG TRUE [get_cells $if_inst/clk_oddr_inst/oddr[0].oddr_inst]

    set src_clk [get_clocks -of_objects [get_pins $if_inst/rgmii_tx_clk_1_reg/C]]

    set_max_delay -from [get_cells $if_inst/rgmii_tx_clk_1_reg] -to [get_cells $if_inst/clk_oddr_inst/oddr[0].oddr_inst] -datapath_only [expr [get_property -min PERIOD $src_clk]/4]
    set_max_delay -from [get_cells $if_inst/rgmii_tx_clk_2_reg] -to [get_cells $if_inst/clk_oddr_inst/oddr[0].oddr_inst] -datapath_only [expr [get_property -min PERIOD $src_clk]/4]
}

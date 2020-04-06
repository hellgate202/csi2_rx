# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"

  ipgui::add_param $IPINST -name "CONTINIOUS_VALID"
  set FRAMES_TO_IGNORE [ipgui::add_param $IPINST -name "FRAMES_TO_IGNORE"]
  set_property tooltip {How many frames will be ignored after receiver start} ${FRAMES_TO_IGNORE}

}

proc update_PARAM_VALUE.CONTINIOUS_VALID { PARAM_VALUE.CONTINIOUS_VALID } {
	# Procedure called to update CONTINIOUS_VALID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CONTINIOUS_VALID { PARAM_VALUE.CONTINIOUS_VALID } {
	# Procedure called to validate CONTINIOUS_VALID
	return true
}

proc update_PARAM_VALUE.FRAMES_TO_IGNORE { PARAM_VALUE.FRAMES_TO_IGNORE } {
	# Procedure called to update FRAMES_TO_IGNORE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FRAMES_TO_IGNORE { PARAM_VALUE.FRAMES_TO_IGNORE } {
	# Procedure called to validate FRAMES_TO_IGNORE
	return true
}


proc update_MODELPARAM_VALUE.CONTINIOUS_VALID { MODELPARAM_VALUE.CONTINIOUS_VALID PARAM_VALUE.CONTINIOUS_VALID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CONTINIOUS_VALID}] ${MODELPARAM_VALUE.CONTINIOUS_VALID}
}

proc update_MODELPARAM_VALUE.FRAMES_TO_IGNORE { MODELPARAM_VALUE.FRAMES_TO_IGNORE PARAM_VALUE.FRAMES_TO_IGNORE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FRAMES_TO_IGNORE}] ${MODELPARAM_VALUE.FRAMES_TO_IGNORE}
}


--------------------------------------------------------------------------------------------------------------
-- FlyWithLua Plugin for IXEG 737-300
-- By Christian Harraeus <charraeus
-- Version 1.1.0 / 2022-02-04
--
-- * Set field of view so that all instruments are visible for the captain's side
-- * Create 4 commands to be uses for hardware-fuel-cutoff-levers:
--   * Set lever 1 to on
--   * Set lever 1 to off
--   * Set lever 2 to on
--   * Set lever 2 to off
-- * Create 2 commands to set all landing lights on/off
-- * Create 2 command to set the taxi light and the runway turnoff lights on/off
--
-- The new commands can be found under *FlyWithLua/ixeg/...*  
-- All created commands are logged in the x-plane log.txt file.
--------------------------------------------------------------------------------------------------------------

-- If it's not an IXEG, just skip all the rest
if AIRCRAFT_FILENAME ~= "B733.acf" then return end

logMsg("  IXEG733_commands.lua started...")


-- Datarefs --------------------------------------------------------------------------------------------------
dataref("FoV", "sim/graphics/view/field_of_view_deg", "writable")
dataref("lever1", "ixeg/733/fuel/fuel_start_lever1_act", "writable")
dataref("lever2", "ixeg/733/fuel/fuel_start_lever2_act", "writable")
dataref("llLeftInboard", "ixeg/733/lighting/l_inboard_ll_act", "writable")
dataref("llLeftOutboard", "ixeg/733/lighting/l_outboard_ll_act", "writable")
dataref("llRightInboard", "ixeg/733/lighting/r_inboard_ll_act", "writable")
dataref("llRightOutboard", "ixeg/733/lighting/r_outboard_ll_act", "writable")
dataref("llLeftOutboardRatio", "ixeg/733/lighting/left_outboard_LL_ratio", "writable")
dataref("llRightOutboardRatio", "ixeg/733/lighting/right_outboard_LL_ratio", "writable")
dataref("txLight", "ixeg/733/lighting/taxi_lt_act", "writable")
dataref("rwTurnoffLeft", "ixeg/733/lighting/l_rwy_turnoff_act", "writable")
dataref("rwTurnoffRight", "ixeg/733/lighting/r_rwy_turnoff_act", "writable")

-- set lateral field of view ---------------------------------------------------------------------------------
newFoV = 79.9
FoV = newFoV
logMsg("    FOV set to ".. newFoV)


-- define commands for taxi and runway turnoff lights --------------------------------------------------------
-- Command Taxi and Rwy Turnoff Lights On
create_command(
	"FlyWithLua/ixeg/Taxi_and_Rwy_Turnoff_Lights_On",
	"Taxi and Rwy Turnoff Lights On",
	[[
		txLight = 1
		rwTurnoffLeft = 1
		rwTurnoffRight = 1
	]],
	"",
	""
)
logMsg("    Command 'FlyWithLua/ixeg/Taxi_and_Rwy_Turnoff_Lights_On' created.")


-- Command Taxi and Rwy Turnoff Lights On
create_command(
	"FlyWithLua/ixeg/Taxi_and_Rwy_Turnoff_Lights_Off",
	"Taxi and Rwy Turnoff Lights Off",
	[[
		txLight = 0
		rwTurnoffLeft = 0
		rwTurnoffRight = 0
	]],
	"",
	""
)
logMsg("    Command 'FlyWithLua/ixeg/Taxi_and_Rwy_Turnoff_Lights_Off' created.")


-- define commands for landing lights ------------------------------------------------------------------------
-- Command All landing lights on
create_command(
	"FlyWithLua/ixeg/All_Landing_Lights_On",
	"Landing Lights all On",
	[[
		llLeftInboard = 1
		llLeftOutboard = 2
    	llLeftOutboardRatio = 0.96
		llRightInboard = 1
		llRightOutboard = 2
    	llRightOutboardRatio = 0.96
	]],
	"",
	""
)
logMsg("    Command 'FlyWithLua/ixeg/All_Landing_Lights_On' created.")


-- Command All landing lights off
create_command(
	"FlyWithLua/ixeg/All_Landing_Lights_Off",
	"Landing Lights all Off",
	[[
		llLeftInboard = 0
		llLeftOutboard = 0
    	llLeftOutboardRatio = 0
		llRightInboard = 0
		llRightOutboard = 0
    	llRightOutboardRatio = 0
	]],
	"",
	""
)
logMsg("    Command 'FlyWithLua/ixeg/All_Landing_Lights_Off' created.")


-- define commands for fuel start levers ---------------------------------------------------------------------
-- Command Fuel_Start_Lever_1_On
create_command(
	"FlyWithLua/ixeg/Fuel_Start_Lever_1_On",
	"Fuel Start Lever #1 On",
	"", -- do nothing if the button is pressed momentarily
	[[
		if lever1 ~= 1.0 then	
			lever1 = 1.0
		end
	]],
	""
)
logMsg("    Command 'FlyWithLua/ixeg/Fuel_Start_Lever_1_On' created.")


-- Command Fuel_Start_Lever_1_Off
create_command(
	"FlyWithLua/ixeg/Fuel_Start_Lever_1_Off",
	"Fuel Start Lever #1 Off",
	"", -- do nothing if the button is pressed momentarily
	[[
		if lever1 ~= 0.0 then	
			lever1 = 0.0
		end
	]],
	""
)
logMsg("    Command 'FlyWithLua/ixeg/Fuel_Start_Lever_1_Off' created.")


-- Command Fuel_Start_Lever_2_On
create_command(
	"FlyWithLua/ixeg/Fuel_Start_Lever_2_On",
	"Fuel Start Lever #2 On",
	"", -- do nothing if the button is pressed momentarily
	[[
		if lever2 ~= 1.0 then	
			lever2 = 1.0
		end
	]],
	""
)
logMsg("    Command 'FlyWithLua/ixeg/Fuel_Start_Lever_2_On' created.")


-- Command Fuel_Start_Lever_2_Off
create_command(
	"FlyWithLua/ixeg/Fuel_Start_Lever_2_Off",
	"Fuel Start Lever #2 Off",
	"", -- do nothing if the button is pressed momentarily
	[[
		if lever2 ~= 0.0 then	
			lever2 = 0.0
		end
	]],
	""
)
logMsg("    Command 'FlyWithLua/ixeg/Fuel_Start_Lever_2_Off' created.")


logMsg("  IXEG733_commands.lua end.")

-----------------------------------------------------------------------------------------------------------------------------------
-- FlyWithLua Plugin for Quest Kodiak
-- By Popeye_swe
-- Version 1.1.0 / 2020-09-05
-- Version 1.2 / 07.01.2021 adapted by CHarraeus
-- Version 1.2.1 / 11.09.2022 Remove some bugs, CHarraeus
-- Version 1.2.2 / 17.09.2022 Adjust to changed Datarefs, CHarraeus
-----------------------------------------------------------------------------------------------------------------------------------


-- If it's not a Kodiak, just skip all the rest
if AIRCRAFT_FILENAME ~= "Quest_Kodiak-LR_G1000.acf" and AIRCRAFT_FILENAME ~= "Quest_Kodiak_Amphib-LR_G1000.acf" then return end

logMsg("  Kodiak_commands.lua started...")

-- Datarefs -----------------------------------------------------------------------------------------------------------------------
dataref("Avionics", "thranda/electrical/AvionicsBus", "writable")
dataref("Aux_Bus", "thranda/electrical/AuxiliaryBus", "writable")
dataref("Starter", "thranda/electrical/StarterSw", "writable")
dataref("Ignition", "thranda/electrical/AutoIgn", "writable")
dataref("Fuel_Pump", "thranda/fuel/FuelPump", "writable")
dataref("firewall_fuel", "thranda/pneumatic/FirewallFuel", "writable")
dataref("Fuel_Switch_L", "thranda/cockpit/actuators/FuelSwL", "writable")
dataref("Fuel_Switch_R", "thranda/cockpit/actuators/FuelSwR", "writable")
dataref("Door_Pilot", "thranda/cockpit/animations/doormanip", "writable", 0)
dataref("Door_Copilot", "thranda/cockpit/animations/doormanip", "writable", 1)
dataref("Door_Upper_Back", "thranda/cockpit/animations/doormanip", "writable", 2)
dataref("Door_Lower_Back", "thranda/cockpit/animations/doormanip", "writable", 3)
dataref("Door_Cargopod_1", "thranda/cockpit/animations/doormanip", "writable", 7)
dataref("Door_Cargopod_2", "thranda/cockpit/animations/doormanip", "writable", 8)
dataref("Door_Cargopod_3", "thranda/cockpit/animations/doormanip", "writable", 9)
dataref("Yaw_Damper", "sim/cockpit2/switches/yaw_damper_on", "writable")
dataref("FoV", "sim/graphics/view/field_of_view_deg", "writable")

logMsg("    Set field of view to ", 73.27)
FoV = 73.27


-- Commands and Functions ---------------------------------------------------------------------------------------------------------

-- toogle
function Toggle(df)
  if df == 0 then
    df = 1
  else
    df = 0
  end
  return df
end

-- Command Avionics on
create_command(
	"FlyWithLua/Kodiak/Avionics_On",
	"Avionics on",
	"Avionics = 1",
	"",
	""
)

-- Command Avionics off
create_command(
	"FlyWithLua/Kodiak/Avionics_Off",
	"Avionics off",
	"Avionics = 0",
	"",
	""
)

-- Command Aux Bus on
create_command(
	"FlyWithLua/Kodiak/Aux_Bus_On",
	"Aux Bus on",
	"Aux_Bus = 1",
	"",
	""
	)

-- Command Aux Bus off
create_command(
	"FlyWithLua/Kodiak/Aux_Bus_Off",
	"Aux Bus off",
	"Aux_Bus = 0",
	"",
	""
)

-- Command Starter Off
create_command(
	"FlyWithLua/Kodiak/Starter_Off",
	"Starter off",
	"Starter = 0",
	"",
	""
)

-- Command Starter High
create_command(
	"FlyWithLua/Kodiak/Starter_High",
	"Starter High",
	"Starter = 1",
	"",
	""
)

-- Command Starter LO
create_command(
	"FlyWithLua/Kodiak/Starter_Lo",
	"Starter Lo",
	"Starter = 2",
	"",
	""
)

-- Wenn nur Taster vorhanden sind, braucht man diese Commands zur Bedienung
-- des Starter-Schalters
-- Function and Command Starter Switch up
function StarterSwitchUp()
  if Starter == 0 then
     Starter = 1
  elseif Starter == 1 then
    Starter = 0
  elseif Starter == 2 then
    Starter = 0
  end
end

-- Command Starter Switch Up
create_command(
  "FlyWithLua/Kodiak/Starter_Sw_Up",
  "Starter Switch Up",
  "StarterSwitchUp()",
  "",
  ""
)
-- Function and Command Starter Switch down
function StarterSwitchDown()
  if Starter == 0 then
    Starter = 2
  elseif Starter == 2 then
    Starter = 0
  elseif Starter == 1 then
    Starter = 0
  end
end

-- Command Starter Switch Up
create_command(
  "FlyWithLua/Kodiak/Starter_Sw_Dn",
  "Starter Switch Down",
  "StarterSwitchDown()",
  "",
  ""
)

-- Command  Ignition_on
create_command(
	"FlyWithLua/Kodiak/Ignition_On",
	"Ignition on",
	"Ignition = 1",
	"",
	""
	)

-- Command Ignition_off
create_command(
	"FlyWithLua/Kodiak/Ignition_Off",
	"Ignition off",
	"Ignition = 0",
	"",
	""
	)

  -- Command Fuel pump off
create_command(
	"FlyWithLua/Kodiak/Fuel_Pump_Off",
	"Fuel Pump off",
  "Fuel_Pump = 0",
	"",
	""
	)

-- Command Fuel pump STBY
create_command(
	"FlyWithLua/Kodiak/Fuel_Pump_Stby",
	"Fuel Pump Stby",
	"Fuel_Pump = 1",
	"",
	""
	)

-- Command Fuel pump on
create_command(
	"FlyWithLua/Kodiak/Fuel_Pump_On",
	"Fuel Pump on",
	"Fuel_Pump = 2",
	"",
	""
	)

-- Wenn nur Taster vorhanden sind, braucht man diese Commands zum Bedienen
-- der Fuel Pump
-- Function and Command Fuel Pump Switch Up
function FuelPumpSwitchUp()
  if Fuel_Pump == 0 then
    Fuel_Pump = 1
  elseif Fuel_Pump == 1 then
    Fuel_Pump = 2
  end
end

-- Function and Command Fuel Swich Down
function FuelPumpSwitchDown()
  if Fuel_Pump == 2 then
    Fuel_Pump = 1
  elseif Fuel_Pump == 1 then
    Fuel_Pump = 0
  end
end

-- Command Fuel Switch Up
create_command(
  "FlyWithLua/Kodiak/Fuel_Pump_Sw_Up",
  "Fuel Pump Switch Up",
  "FuelPumpSwitchUp()",
  "",
  ""
)

-- Command Fuel Switch Down
create_command(
  "FlyWithLua/Kodiak/Fuel_Pump_Sw_Dn",
  "Fuel Pump Switch Down",
  "FuelPumpSwitchDown()",
  "",
  ""
)

-- Command Fuel Switch Left On
create_command(
  "FlyWithLua/Kodiak/Fuel_Switch_L_on",
  "Fuel Switch left on",
  "Fuel_Switch_L = 1",
  "",
  ""
)

-- Command Fuel Switch Left Off
create_command(
  "FlyWithLua/Kodiak/Fuel_Switch_L_off",
  "Fuel Switch left off",
  "Fuel_Switch_L = 0",
  "",
  ""
)

-- Command Fuel Switch Right On
create_command(
  "FlyWithLua/Kodiak/Fuel_Switch_R_on",
  "Fuel Switch right on",
  "Fuel_Switch_R = 1",
  "",
  ""
)

-- Command Fuel Switch Right Off
create_command(
  "FlyWithLua/Kodiak/Fuel_Switch_R_off",
  "Fuel Switch right off",
  "Fuel_Switch_R = 0",
  "",
  ""
)
create_command(
	"FlyWithLua/Kodiak/firewall_fuel_on",
	"Firewall fuel on",
	"firewall_fuel = 1",
	"",
	""
	)

-- 306 - Firewall fuel off

create_command(
	"FlyWithLua/Kodiak/firewall_fuel_off",
	"Firewall fuel off",
	"firewall_fuel = 0",
	"",
	""
	)


-- Command Door Pilot Toggle
create_command(
  "FlyWithLua/Kodiak/Door_Pilot_toggle",
  "Pilot's Door toggle",
  "Door_Pilot = Toggle(Door_Pilot)",
  "",
  ""
)

-- Command Door Copilot Toggle
create_command(
  "FlyWithLua/Kodiak/Door_Copilot_toggle",
  "Copilot's Door toggle",
  "Door_Copilot = Toggle(Door_Copilot)",
  "",
  ""
)

-- Command Backdoor Toggle
create_command(
  "FlyWithLua/Kodiak/Door_Back_toggle",
  "Backdoor toggle",
  [[Door_Upper_Back = Toggle(Door_Upper_Back)
  Door_Lower_Back = Toggle(Door_Lower_Back)]],
  "",
  ""
)

-- Command All Cargo Doors toggle
create_command(
  "FlyWithLua/Kodiak/Door_Cargopod_toggle",
  "Cargopod Doors toggle",
  [[Door_Cargopod_1 = Toggle(Door_Cargopod_1)
  Door_Cargopod_2 = Toggle(Door_Cargopod_2)
  Door_Cargopod_3 = Toggle(Door_Cargopod_3)]],
  "",
  ""
)

-- Command Yaw Damper On
create_command(
  "FlyWithLua/Kodiak/Yaw_Damper_On",
  "Yaw Damper on",
  "Yaw_Damper = 1",
  "",
  ""
)

-- Command Yaw Damper Auto
create_command(
  "FlyWithLua/Kodiak/Yaw_Damper_Auto",
  "Yaw Damper auto",
  "Yaw_Damper = 2",
  "",
  ""
)

-- Command Yaw Damper Off
create_command(
  "FlyWithLua/Kodiak/Yaw_Damper_Off",
  "Yaw Damper off",
  "Yaw_Damper = 0",
  "",
  ""
)

-- Wenn nur Taster vorhanden sind, braucht man diese Commands für den Yaw Damper
function Yaw_damper_switch_up(state)
  if state == 0 then
    state = 2
  elseif state == 1 then
    state = 0
  end
  return state
end

function Yaw_damper_switch_down(state)
  if state == 0 then
    state = 1
  elseif state == 2 then
    state = 0
  end
  return state
end

-- Command Yaw Damper Switch Up
create_command(
  "FlyWithLua/Kodiak/Yaw_Damper_Switch_Up",
  "Yaw Damper Switch Up",
  "Yaw_Damper = Yaw_damper_switch_up(Yaw_Damper)",
  "",
  ""
)

-- Command Yaw Damper Switch Down
create_command(
  "FlyWithLua/Kodiak/Yaw_Damper_Switch_Down",
  "Yaw Damper Switch Down",
  "Yaw_Damper = Yaw_damper_switch_down(Yaw_Damper)",
  "",
  ""
)

-- Command All Baro Down
-- Diese Commands sind direkt im Bravo Throttle Quadrant auf den rechten
-- Drehknopf programmiert
create_command(
  "FlyWithLua/Kodiak/All_Baro_Down",
  "All Baro down",
  [[command_once("thranda/G1000/g1000n1_baroDn")
    command_once("thranda/G1000/g1000n2_baroDn")
    command_once("thranda/G1000/g1000n3_baroDn")]],
  "",
  ""
)

-- Command All Baro Up
create_command(
  "FlyWithLua/Kodiak/All_Baro_Up",
  "All Baro up",
  [[command_once("thranda/G1000/g1000n1_baroUp")
    command_once("thranda/G1000/g1000n2_baroUp")
    command_once("thranda/G1000/g1000n3_baroUp")]],
  "",
  ""
)

--Anti ice on
-- create_command(
-- 	"FlyWithLua/Kodiak/Anti_Ice_On",
-- 	"Inlet Anti Ice on",
-- 	"Anti_Ice = 1",
-- 	"",
-- 	""
-- 	)
--Anti ice off
-- create_command(
-- 	"FlyWithLua/Kodiak/Anti_Ice_Off",
-- 	"Inlet Anti Ice off",
-- 	"Anti_Ice = 0",
-- 	"",
-- 	""
-- 	)

logMsg("  Kodiak_commands.lua end.")

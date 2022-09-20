---------------------------------------------------------------------------------------------------
-- writeKodiakPrefs.lua
-- 
-- Workaround for the Thranda Quest Kodiak V2.3 which always overwrites it's prefs-file with
-- default data when unloading the aircraft in the X-Plane 11-simulator. 
--
-- !! Make sure to have a backup of your preferences file before using this app the first time. !!
--
-- This FlyWithLua-script overwrites the following preferences:
--   _track_up_0,     _track_up_1,     _track_up_2
--   _data_fields_0,  _data_fields_1,  _data_fields_2
--   _ils_cdi_auto_0, _ils_cdi_auto_1, _ils_cdi_auto_2
--   _filter_rnp_0,   _filter_rnp_1,   _filter_rnp_2
--   _baro_unit_0,    _baro_unit_1,    _baro_unit_2
--   _wind_display_0, _wind_display_1, _wind_display_2
--   _inset_map_0,    _inset_map_1,    _inset_map_2
-- 
-- Version: 1.0
-- Date:    20.09.2022
-- Author:  Christian Harraeus
--
-- Change history:
--
-- Disclaimer: Use this app on your own risk.
-- 
-- Tested with:
--   o Standalone Lua 5.1.5 on macOS Monterey 12.5.1 with local preferences file
--   o Standalone Lua 5.1.5 on macOS Monterey 12.5.1 with preferences file on Windows PC via SMB
--   o Standalone Lua 5.1 (Zerobrane Studio 1.90) on Windows 10 version 21H2
--   o Standalone Lua 5.3 (Zerobrane Studio 1.90) on Windows 10 version 21H2
---------------------------------------------------------------------------------------------------

-------------------------------------------------
-- adjust the following values to your needs
-------------------------------------------------
local kodiakPath = "D:/X-Plane 11/Aircraft/Krischis Flieger/Thranda_Quest_Kodiak REP/"
local backupPath = kodiakPath
--local kodiakPath = "/Volumes/X-Plane 11/Aircraft/Krischis Flieger/Thranda_Quest_Kodiak REP/"
--local backupPath = kodiakPath
local kodiakPrefsTxtName = "Quest_Kodiak-LR_G1000_prefs.txt"
local kodiakPrefsBakName = "Quest_Kodiak-LR_G1000_prefs.txt.bak"
local entries = {["_track_up_0"] = 1,       -- ND Map display: 1 = heading is up, 0 = north is up
                 ["_track_up_1"] = 1,       -- ND Map display: 1 = heading is up, 0 = north is up
                 ["_track_up_2"] = 1,       -- ND Map display: 1 = heading is up, 0 = north is up
                 ["_data_fields_0"] = 0,    -- ?? unknown
                 ["_data_fields_1"] = 1,    -- ?? unknown
                 ["_data_fields_2"] = 1,    -- ?? unknown
                 ["_ils_cdi_auto_0"] = 1,   -- ?? unknown
                 ["_ils_cdi_auto_1"] = 0,   -- ?? unknown
                 ["_ils_cdi_auto_2"] = 0,   -- ?? unknown
                 ["_filter_rnp_0"] = 1,     -- ?? unknown
                 ["_filter_rnp_1"] = 0,     -- ?? unknown
                 ["_filter_rnp_2"] = 0,     -- ?? unknown
                 ["_baro_hpa_0"] = 1,       -- Baro unit: 0 = inHg, 1 = hPa
                 ["_baro_hpa_1"] = 1,       -- Baro unit: 0 = inHg, 1 = hPa
                 ["_baro_hpa_2"] = 1,       -- Baro unit: 0 = inHg, 1 = hPa
                 ["_wind_display_0"] = 3,   -- PFD Wind display: 0 = off, 1...3 = Option 1...3, 
                 ["_wind_display_1"] = 1,   -- PFD Wind display: 0 = off, 1...3 = Option 1...3
                 ["_wind_display_2"] = 2,   -- PFD Wind display: 0 = off, 1...3 = Option 1...3
                 ["_inset_map_0"] = 0,      -- PFD Litte inset map: 0 = off, 1 = on
                 ["_inset_map_1"] = 1,      -- PFD Litte inset map: 0 = off, 1 = on
                 ["_inset_map_2"] = 1       -- PFD Litte inset map: 0 = off, 1 = on
                }
local verboseMessages = false

-------------------------------------------------
-- Do not touch anything below this line
-- unless you know exactly what you do
-------------------------------------------------
-------------------------------------------------
local version = "1.0"

-- change the oiginal setting to the new setting as defined in eintries
local function changeSettings(settings, newEntries)
    for key, value in pairs(newEntries) do
        local count = 0
        settings, count = string.gsub(settings, key .. "%s*%w", key .. " " .. value)
        if count == 0 then
            print("Warning: Setting '" .. key .. "' not found in preferences file. Nothing changed.")
        elseif verboseMessages then
            print("Value of setting '" .. key .. "' set to " .. value .. ".")
        end
    end
    return settings
end


-- make a backup of the current prefs-file
local function createBackup(filename, backupfilename)
    local backupname = backupfilename

    local count = 0
    local ok, errorMsg, errorFileExists
    repeat
        ok, errorMsg = os.rename(filename, backupname)  -- macOS always overwrites existing backupname file
        if not ok then  -- on macOS ok is always true
            -- check wether filename already exists and compute new backup filename
            -- as macOS always overwrites existing backupname file this works only on windows
            errorFileExists, _ = string.find(tostring(errorMsg), "%s*File exists")
            if errorFileExists ~= nil then
                -- yes, backupfilename does already exist
                count = count + 1
                backupname = backupfilename .. count
            end
        end
    until ok or (errorFileExists == nil)    -- errorFileExists is <> 0 if errorMsg is "...File exists"
    return ok, backupname, errorMsg
end


-- build complete filename paths
kodiakPrefsTxtName = kodiakPath .. kodiakPrefsTxtName
kodiakPrefsBakName = backupPath .. kodiakPrefsBakName
-- welcome message
print("writeKodiakPrefs Version " .. version .. " 2022 by Christian Harraeus")
if verboseMessages then
    print("Input file:  " .. kodiakPrefsTxtName)
    print("Backup file: " .. kodiakPrefsBakName)
end

local ok = false
local errorOccured = false
local errorMsg

ok, kodiakPrefsBakName, errorMsg = createBackup(kodiakPrefsTxtName, kodiakPrefsBakName)
if ok then
    print("Created new backupfile: " .. kodiakPrefsBakName)
    -- open the source file (the backup file)
    local oldPrefsFile
    oldPrefsFile, errorMsg = io.open(kodiakPrefsBakName, "r")
    if oldPrefsFile ~= nil then
        -- create the new prefs-file
        local newPrefsFile
        newPrefsFile, errorMsg = io.open(kodiakPrefsTxtName, "w")
        if newPrefsFile ~= nil then
            -- read the old preferences file and change the settings
            local settings = oldPrefsFile:read("*a")
            oldPrefsFile:close()
            settings = changeSettings(settings, entries)
            -- write the changes, close file and end program
            newPrefsFile:write(settings)
            newPrefsFile:close()
            print("Kodiak preferences changed successfully.")
        else
            print("Error when trying to create new file: " .. errorMsg)
            errorOccured = true
        end
    else
        print("Error when trying to open existing file: " .. errorMsg)
        errorOccured = true
    end
else
    print("Error when trying to backup existing file: " .. errorMsg)
end

if errorOccured then
    -- restore original file
    ok, errorMsg = os.rename(kodiakPrefsBakName, kodiakPrefsTxtName)
    if not ok then
        print("Restore of original file failed! There must be a big problem.")
    else
        print("Original file restored.")
    end
end
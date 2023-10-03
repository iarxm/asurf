local mp = require "mp"
local utils = require 'mp.utils'
package.path = mp.command_native({"expand-path", "~~/script-modules/?.lua;"})..package.path
local ds = require 'asurf'
	-- load surf analysis functions

local function getScreenshotFilename()
	local absolutePath = ds.absPath()
	local directory, filename = utils.split_path(absolutePath)
    	local nameCode = ds.uniqueId(filename)

	local newPath = directory .. nameCode .. ".zXano.png"
	return newPath

end

local function getWinDim()
	
	local cmd = 'xdims'
	local handle = io.popen(cmd)
	local dims = handle:read("*a")
	handle:close()
	return dims
end

local function main()
    	-- Define the command to execute Flameshot
    	local command = {
        "flameshot",
        "gui",
	     "-p",
        	getScreenshotFilename(), -- Dynamic Name
		"--region ",
		getWinDim() -- Dims
	     }

	local cmd = table.concat(command, " ")
	local ret = os.execute(cmd)

	-- Check the return code of the subprocess
	if ret ~= 0 then
    		mp.msg.error("Failed to execute Flameshot")
	end
end

mp.add_key_binding("f", "trigger_flameshot", function()
	-- Define the keybinding
	main()
end)

-- ################################################
-- NOTES: #########################################

-- DESCRIPTION::
-- This modified script uses the getScreenshotFilename function to dynamically generate the filename for the Flameshot screenshot. It retrieves the path and filename of the currently playing video using the mp.get_property("path") function, then modifies the filename by appending "_screenshot" and the file extension ".png". The screenshot will be saved in the same directory as the video with the modified filename.

-- Define window area
	-- - If need to take screen of double pane, 
	-- - just manually resize the frame for that use case


--###############################################
-- ARCHIVE ###################################
--local ret = utils.subprocess({args = command, playback_only = false})
    	-- Check the return code of the subprocess
    	--if ret.error then
        --mp.msg.error("Failed to execute Flameshot:", ret.error)
    	--end

-- local name, extension = filename:match("(.*)%.([^%./]+)$")
    	-- DEBUG:
    	-- mp.msg.error("filename: " .. filename)
	-- mp.msg.error("directory: " .. directory)

	--mp.msg.error("absolutePath: " .. tostring(absolutePath))


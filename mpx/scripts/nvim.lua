-- DESCRIPTION:
-- 	- Checks if server is running at startup, and if so, will auto hook files to nvim
-- 	- The keybinding starts the nvim instance, and passes the current file.
local socket = require("socket")
local mp = require "mp"
local utils = require 'mp.utils'
package.path = mp.command_native({"expand-path", "~~/script-modules/?.lua;"})..package.path
-- load surf analysis functions 'asurf'
local ds = require 'asurf'
local msg = require 'mp.msg'  -- Import the msg module

-- VARS ##################################
-- local switch = 0
local serverPipePath = os.getenv("HOME") .. "/.cache/nvim/server.pipe"

-- CHECK ###############################
local function checkServer()
	-- Use string.format to include the serverPipe in the pgrep pattern
	local commandCheck = string.format("pgrep -f 'nvim --listen %s' > /dev/null", serverPipePath)
    	local isServerRunning = os.execute(commandCheck)
	return isServerRunning
end

local function startServer()
    -- Check if Neovim server isn't running
    local isServerRunning = checkServer()
    if isServerRunning ~= 0 then
        -- Use nohup to ensure the server continues to run after the terminal is closed
        -- Use & to start nvim as a background process
        local commandStart = string.format("nohup st -e nvim --listen %s &", serverPipePath)
        	os.execute(commandStart)
		socket.sleep(1)  -- sleep 1s to allow nvim to setup as a server, before sending it a file
    end
end

local function previewTextFile()
	local mediaFilePath = ds.absPath()
    local mediaFileDir, mediaFileName = utils.split_path(mediaFilePath)
    local uniqueId = ds.fullMeta()
    -- Text File
    local textFilePath = mediaFileDir .. "x" .. uniqueId .. ".txt"
    local file = io.open(textFilePath, "r")
    if file then  -- If the file exists
        if not file:read("*l") then  -- Check if the first line is nil, meaning the file is empty
            file:close()  -- Close the file
            file = io.open(textFilePath, "a")  -- Open the file in append mode
            file:write("# " .. uniqueId .. "\n\n\n")  -- Append the uniqueId as a markdown heading
        end
        file:close()
    else  -- If the file does not exist
        file = io.open(textFilePath, "w")  -- Open a new file in write mode
        file:write("# " .. uniqueId .. "\n")  -- Write the uniqueId as a markdown heading
        file:close()
    end
    -- EXEC NVIM
    startServer()
    local nvimCommand = "nvim --server " .. serverPipePath .. " --remote " .. textFilePath .. " &"
    os.execute(nvimCommand)
end

local function previewSwitch()
	local isServerRunning = checkServer()
	if isServerRunning == 0 then
		previewTextFile()
	end
end

local function main()
	-- switch = 1
	previewTextFile()
end

-- BIND CALL ###########################################
mp.add_key_binding("E", "trigger_nvim", function()
	-- Define the keybinding and executions
	main()
end)

-- STARTUP CALL ######################################
mp.register_event("file-loaded", previewSwitch)


-- ############################
-- DEV: #####################
-- xTODO: case: nvim server isn't running, then start it up
-- TODO: case: uniqueCode returns incorrect name: then return error
-- TODO: case: 'file-loaded' vs 'on_load'

-- Please note that the 'checkServer' function now assumes that the server is always started with the --listen option followed by the pipe name, with no other options or arguments in between. If the server could be started with additional options or arguments, you might need a more complex method to check if the server is running. For example, you could use a regular expression to allow for additional options or arguments, or use a script to parse the output of the ps command.

--#########################
--ARCHIVING ###############
--DEBUG:
--msg.error("previewTextFile() called")
-- IMPORT DATA

-- DEBUG
-- mp.msg.error("Executing nvimCommand")
-- msg.error("nvimCommand:" .. nvimCommand)

-- mp.add_hook("file-loaded", 10, previewTestFile
--        callback(...)
--   end)
-- end

--mp.msg.error("nvim.lua called")
-- hook_add("file-loaded", 10, previewTextFile)
-- hook_add("file-loaded", 10, previewTextFile)
-- on_load'

-- mp.register_event("on_loaded", previewSwitch)
-- mp.register_event("file-loaded", previewTextFile)


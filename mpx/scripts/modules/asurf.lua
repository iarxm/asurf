local mp = require "mp"
local utils = require "mp.utils"

-- #############################################################
--
local function absPath() -- ensure path is abs
	local relativePath = mp.get_property("path")
	local absolutePath
	if relativePath:sub(1, 1) == "/" then
        -- if path abs, then set it as abs var
        	absolutePath = relativePath
    	else -- else, convert it to abs:
		local currentDir = utils.getcwd()
		absolutePath = utils.join_path(currentDir, relativePath)
	end
	return absolutePath
end

-- ###################################################################
-- EXTRACTING UNIQUE MEDIA FILE ID ####################################
local function uniqueId() -- create string 'code + surfer id'
  local dir, name = utils.split_path(absPath())
	local cameraCode = name:match("([ASsPp]%d%d%d%d%d?%d?%d?)")
	local nameCode = name:match("%.(S%a+)%.")
	local ratingCode = name:match("%.(R%a+)%.")
	local fileCode = cameraCode
	if nameCode then
        fileCode = fileCode .. "." .. nameCode
    	end
	if ratingCode then
				fileCode = fileCode .. "." .. ratingCode
			end
  return fileCode
	--local nameCode = cameraCode .. surferCode
	--return nameCode
end

local function fullMeta()
	local dir, name = utils.split_path(absPath())
	local noteCode = name:match("%.(N%a+)%.")
	local fileCode = uniqueId()
	if noteCode then
				fileCode = fileCode .. "." .. noteCode
	end
	return fileCode
end

return {
    absPath = absPath,
    uniqueId = uniqueId,
		fullMeta = fullMeta,
}

-- ##TODO: ##################################
--

-- ## Other Libraries ##################
-- local utils = require "mp.utils"
-- local msg = require "mp.msg"
-- local input = require "user-input-module"

-- ## NOTES: ####################################
-- It's often best practise to work with abs path's
	-- eg incase mp.get_property returns a relative path.. 
		-- Can cause confusion in other places.
-- local currentDir = io.popen("pwd"):read("*l")  
	-- Get the current working directory using 'pwd' command
	-- calling external scripts can be very costly. 
	-- Bad practise and best to utilise available libraries.
-- absolutePath = io.popen("readlink -f " .. currentDir .. "/" .. relativePath):read("*l")  -- Execute 'readlink -f' command to get the absolute path

-- HOW SHOULD I DEFINE THE FUNCTIONS? 
-- AS LOCAL OR GLOBAL (with first letter capitalised?)
-- Answer: As local which is equivalent to module global..


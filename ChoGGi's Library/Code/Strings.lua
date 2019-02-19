-- See LICENSE for terms

-- i translate all the strings at startup, so it's a table lookup instead of a func call
-- ~ ChoGGi.Strings[27]

-- amount of entries in the CSV file
local string_limit = 1550

do -- Translate
	-- local some globals
	local T,_InternalTranslate,IsT,TGetID = T,_InternalTranslate,IsT,TGetID
	local type,select,pcall,tostring = type,select,pcall,tostring

	-- translate func that always returns a string
	function ChoGGi.ComFuncs.Translate(...)
		local str,result
		local stype = type(select(1,...))
		if stype == "userdata" or stype == "number" then
			str = T{...}
		else
			str = ...
		end

		-- certain stuff will fail without this obj, so just pass it off to pcall and let it error out
		if UICity then
			result,str = true,_InternalTranslate(str)
		else
			result,str = pcall(_InternalTranslate,str)
		end

		-- Missing text means the string id wasn't found (generally)
		if str == "Missing text" then
			return (IsT(...) and TGetID(...) or tostring(...)) .. " *bad string id?"
		-- just in case
		elseif not result or type(str) ~= "string" then
			str = select(2,...)
			if type(str) == "string" then
				return str
			end
			-- i'd rather know if something failed by having a bad string rather than a failed func
			return (IsT(...) and TGetID(...) or tostring(...)) .. " *bad string id?"
		end

		-- and done
		return str
	end
end -- do
local Trans = ChoGGi.ComFuncs.Translate

--~ local missing_strs = {}
-- we need to pad some zeros
local tonumber = tonumber
local function TransZero(pad,first,last,strings)
	for i = first, last do
		if i > string_limit then
			break
		end
		local num = tonumber("30253592000" .. pad .. i)
		local str = Trans(num)

		if not (#str > 16 and str:sub(-16) == " *bad string id?") then
			strings[num] = str
--~ 		else
--~ 			c = c + 1
--~ 			missing_strs[#missing_strs+1] = num
		end
	end
end

function ChoGGi.ComFuncs.UpdateStringsList()
	local ChoGGi = ChoGGi

	ChoGGi.lang = GetLanguage()
	-- devs didn't bother changing droid font to one that supports unicode, so we do this when it isn't eng
	if ChoGGi.lang ~= "English" then
		-- first get the unicode font name

		local f = Trans(997--[[*font*, 15, aa--]])
		-- index of first , then crop out the rest
		f = f:sub(1,f:find(",")-1)
		ChoGGi.font = f

		-- these four don't get to use non-eng fonts, cause screw you is why
		-- ok it's these aren't expected to be exposed to end users, but console is in mod editor so...
		local TextStyles = TextStyles
		TextStyles.Console.TextFont = f .. ", 18, bold, aa"
		TextStyles.ConsoleLog.TextFont = f .. ", 13, bold, aa"
		TextStyles.DevMenuBar.TextFont = f .. ", 18, aa"
		TextStyles.GizmoText.TextFont = f .. ", 32, bold, aa"

	end

	-- one big table of all in-game strings and mine (i make a copy since we edit some strings below, and i want to make sure tag icons show up)
	local strings = ChoGGi.Strings or {}

	-- 0000 = 0 if we try to pass as a number (as well as 001 to 1)
	TransZero("000",0,9,strings)
	TransZero("00",10,99,strings)
	TransZero(0,100,999,strings)
	TransZero("",1000,9999,strings)

--~ 	if #missing_strs > 0 then
--~ 		ex(missing_strs)
--~ 	end

--~ 	-- build a list of tags with .tga
--~ 	local tags = {}
--~ 	local TagLookupTable = const.TagLookupTable
--~ 	for key,value in pairs(TagLookupTable) do
--~ 		if type(value) == "string" and value:find(".tga") then
--~ 			tags[key] = value
--~ 		end
--~ 	end

--~ 	local TranslationTable = TranslationTable
--~ 	for key,value in pairs(TranslationTable) do
--~ 		local tag_match = tags[value:match("<+([%a_]+)>+")]
--~ 		-- translate strings with an image tag (<left_click> to <image UI/Infopanel/left_click.tga>)
--~ 		if tag_match then
--~ 			strings[key] = Trans(key)
--~ 		-- the rest don't matter
--~ 		else
--~ 			strings[key] = value
--~ 		end
--~ 	end

	-- and update my global ref
	ChoGGi.Strings = strings
end
-- always fire on startup
--~ ChoGGi.ComFuncs.TickStart("TestTableIterate.1.Tick")
ChoGGi.ComFuncs.UpdateStringsList()
--~ ChoGGi.ComFuncs.TickEnd("TestTableIterate.1.Tick")

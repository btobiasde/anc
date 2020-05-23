Name_Changer = Name_Changer or {}

local luaroot = "advanced_namechanger"

function LogInfo(message)
	MsgC(Color(0, 255, 0), "[U1tim4te-Namechanger] " .. message .. "\n")
end

function LogWarning(message)
	MsgC(Color(255, 255, 0), "[U1tim4te-Namechanger] " .. message .. "\n")
end

if SERVER then
	local files = file.Find( luaroot .."/config/*.lua", "LUA" )
	for _, file in ipairs( files ) do
		if not string.StartWith(file, 'sv_') then
			AddCSLuaFile( luaroot .. "/config/" .. file )
		end
		
		include( luaroot .. "/config/" .. file )
		LogInfo("Loading " .. luaroot .. "/config/" .. file)
	end

	local files = file.Find( luaroot .."/client/*.lua", "LUA" )
	for _, file in ipairs( files ) do
		AddCSLuaFile( luaroot .. "/client/" .. file )
		LogInfo("Loading " .. luaroot .. "/client/" .. file)
	end

	local files = file.Find( luaroot .."/shared/*.lua", "LUA" )
	for _, file in ipairs( files ) do
		AddCSLuaFile( luaroot .. "/shared/" .. file )
		include( luaroot .. "/shared/" .. file )
		LogInfo("Loading " .. luaroot .. "/shared/" .. file)
	end

	local files = file.Find( luaroot .."/server/*.lua", "LUA" )
	for _, file in ipairs( files ) do
		include( luaroot .. "/server/" .. file )
		LogInfo("Loading " .. luaroot .. "/server/" .. file)
	end
end

if CLIENT then
	local files = file.Find( luaroot .."/config/*.lua", "LUA" )
	for _, file in ipairs( files ) do
		if not string.StartWith(file, 'sv_') then
			include( luaroot .. "/config/" .. file )
		    LogInfo("Loading " .. luaroot .. "/config/" .. file)
		end
	end

	local files = file.Find( luaroot .."/client/*.lua", "LUA" )
	for _, file in ipairs( files ) do
		include( luaroot .."/client/" .. file )
		LogInfo("Loading " .. luaroot .. "/client/" .. file)
	end

	local files = file.Find( luaroot .."/shared/*.lua", "LUA" )
	for _, file in ipairs( files ) do
		include( luaroot .. "/shared/" .. file )
		LogInfo("Loading " .. luaroot .. "/shared/" .. file)
	end
end
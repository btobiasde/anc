util.AddNetworkString( "Name_Changer:ChangeName" )
util.AddNetworkString( "Name_Changer:OpenMenu" )
util.AddNetworkString( "Name_Changer:ResetName" )
util.AddNetworkString( "Name_Changer:Chat" )

hook.Add("Initialize", "Name_Changer:Init", function()
	if not sql.TableExists( "Name_Changer" ) then
		sql.Query("CREATE TABLE `Name_Changer` ( `id` INTEGER PRIMARY KEY AUTOINCREMENT, `steamid` TEXT, `firstname` TEXT, `lastname` TEXT);")
	end
end)

function ChatPrintTag(ply, message)
	net.Start("Name_Changer:Chat")
		net.WriteString(message)
	net.Send(ply)
	-- ply:ChatPrint(Name_Changer.Language.ChatTag .. " " .. message)
end

net.Receive("Name_Changer:ChangeName", function( len, ply )
	local firstname = net.ReadString()
	local lastname = net.ReadString()
	if IsValid( ply ) then
		
		if(firstname == Name_Changer.Language.ExampleFirstName or lastname == Name_Changer.Language.ExampleLastName) then
			ChatPrintTag(ply, Name_Changer.Language.ErrorF)
			net.Start("Name_Changer:OpenMenu")
			net.Send(ply)
		else
			ply:changeName(firstname, lastname)
		end 
	end
end)

net.Receive("Name_Changer:ResetName", function( len, ply )
	local notfind = true
	local firstname = net.ReadString()
	local lastname = net.ReadString()
	local chosenplayer = net.ReadString()
	
	if Name_Changer.Admins[ply:GetNWString("usergroup")] then
		for k,v in pairs(player.GetAll()) do
			if v:Name() == chosenplayer then
				DarkRP.storeRPName(v, firstname .. " " .. lastname)
				v:setDarkRPVar("rpname", firstname .. " " .. lastname)
				sql.Query("UPDATE Name_Changer SET firstname = " .. sql.SQLStr(firstname) .. ", lastname = " .. sql.SQLStr(lastname) .. " WHERE steamid = "..v:SteamID())
				ChatPrintTag(v, Name_Changer.Language.ResetDone .. " " .. firstname .. " " .. lastname)
				ChatPrintTag(ply, Name_Changer.Language.ResetSuccess)
				notfind = false
				break
			end
		end
		
		if notfind then
			ChatPrintTag(ply, Name_Changer.Language.ResetBadPly)
		end
	end
end)

hook.Add( "PlayerInitialSpawn", "Name_Changer:PlayerSpawner", function( ply )
	timer.Simple(1, function()
		if !ply:hasNamechanged() then
			ply:SetNWBool("CharactersFirstAuth", true)
			net.Start("Name_Changer:OpenMenu")
			net.Send(ply)
		else
			ply:SetNWBool("CharactersFirstAuth", false)
		end
		
	end)
end)

hook.Add("PlayerSay", "ResetCharacter", function(ply, text)
	if string.StartWith(text, Name_Changer.ResetCommand) then
		-- if table.HasValue(Characters.Admins, ply:GetUserGroup()) then
		if Name_Changer.Admins[ply:GetNWString("usergroup")] then
			ply:SendLua("ResetNameMenu()")
			return ""
		end
	end
end)

hook.Add("CanChangeRPName", "Name_Changer:DisableNameChange", function(ply, job)
	-- if table.HasValue(Name_Changer.Admins, ply:GetUserGroup()) then
	if Name_Changer.Admins[ply:GetNWString("usergroup")] then
		sql.Query("UPDATE Name_Changer SET firstname = " .. sql.SQLStr(firstname) .. ", lastname = " .. sql.SQLStr(lastname) .. " WHERE steamid = "..ply:SteamID())
		return true, nil, job
	end
	
	return false, Name_Changer.Language.ErrorA
end)

local meta = FindMetaTable( "Player" )

function meta:getInfo()
	local info = sql.Query("SELECT * FROM `Name_Changer` WHERE `steamid` = '"..self:SteamID().."'")
	if type(info) == "table" then
		return info
	end
end

function checkBadWords(text)
	if not Name_Changer.BadWordsEnable then 
		return "" 
	end
	
	for k, word in pairs(Name_Changer.BadWords) do
		if Name_Changer.BadWordsFullCheck then
			local heckStart, heckEnd = string.find( text:lower(), word )
			if heckStart then 
				return true
			end
		else
			if text:lower() == word then
				return true
			end
		end
	end
	
	return false
end

function meta:changeName(firstname, lastname)
	self.timer = self.timer or 0
	
	if self.timer < CurTime() then
		if checkBadWords(firstname) then
			ChatPrintTag(self, Name_Changer.Language.ErrorBF)
			net.Start("Name_Changer:OpenMenu")
			net.Send(self)
			
			return
		elseif checkBadWords(lastname) then
			ChatPrintTag(self, Name_Changer.Language.ErrorBL)
			net.Start("Name_Changer:OpenMenu")
			net.Send(self)
			
			return
		end
		
		-- if not string.match(firstname, "^[a-zA-ZЀ-џ0-9 ]+$") then 
		if not string.match(firstname, "^[a-zA-ZЀ-џ]") then 
			ChatPrintTag(self, Name_Changer.Language.ErrorNF)
			net.Start("Name_Changer:OpenMenu")
			net.Send(self)
			return
		end
		
		-- if not string.match(lastname, "^[a-zA-ZЀ-џ0-9 ]+$") then 
		if not string.match(lastname, "^[a-zA-ZЀ-џ]") then 
			ChatPrintTag(self, Name_Changer.Language.ErrorNL)
			net.Start("Name_Changer:OpenMenu")
			net.Send(self)
			return
		end

		local lenf = string.len(firstname)
		local lenl = string.len(lastname)
		
		if lenf > 14 then 
			ChatPrintTag(self, Name_Changer.Language.ErrorTooLF)
			net.Start("Name_Changer:OpenMenu")
			net.Send(self)
			return
		end 
		if lenf < 3 then 
			ChatPrintTag(self, Name_Changer.Language.ErrorTooSF)
			net.Start("Name_Changer:OpenMenu")
			net.Send(self)
			return 
		end
		
		if lenl > 14 then 
			ChatPrintTag(self, Name_Changer.Language.ErrorTooLL)
			net.Start("Name_Changer:OpenMenu")
			net.Send(self)
			return
		end 
		if lenl < 3 then 
			ChatPrintTag(self, Name_Changer.Language.ErrorTooSL)
			net.Start("Name_Changer:OpenMenu")
			net.Send(self)
			return 
		end
		
				
		if checkName(firstname, lastname) then
			if(self:hasNamechanged()) then
				if Name_Changer.CostMoney then
					if self:getDarkRPVar("money") < Name_Changer.HowMuchCost then
						ChatPrintTag(self, Name_Changer.Language.Money)
						return
					end
					self:setDarkRPVar("money", self:getDarkRPVar("money") - Name_Changer.HowMuchCost)
				end
				 
				sql.Query("UPDATE Name_Changer SET firstname = " .. sql.SQLStr(firstname) .. ", lastname = " .. sql.SQLStr(lastname) .. " WHERE steamid = "..self:SteamID())
			else
				sql.Query("INSERT INTO Name_Changer (steamid, firstname, lastname) VALUES ('"..self:SteamID().."', '"..firstname.."', '"..lastname.."')")
			end
			
			DarkRP.storeRPName(self, firstname .. " " .. lastname)
			self:setDarkRPVar("rpname", firstname .. " " .. lastname)
			ChatPrintTag(self, Name_Changer.Language.Success)
			self:SetNWBool("CharactersFirstAuth", false)
		else
			ChatPrintTag(self, Name_Changer.Language.ErrorU)
			net.Start("Name_Changer:OpenMenu")
			net.Send(self)
		end 
		
		self.timer = CurTime() + 30
	else
		ChatPrintTag(self, Name_Changer.Language.Time)
	end
end

function meta:hasNamechanged()
	local info = self:getInfo()
	if not istable(info) then return false else return true end
end

function checkName( firstname, lastname )
	local names = sql.Query("SELECT * FROM `Name_Changer` WHERE `firstname` = " .. firstname .. " AND `lastname` = " .. lastname)
	if !names then
		return true
	else
		return false
	end
end
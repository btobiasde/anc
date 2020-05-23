net.Receive("Name_Changer:OpenMenu", function()
    frame = NameChange.Frame(-1, -1, ScrW() * 0.25, ScrH() * 0.3, Name_Changer.Language.Title, true)
    fw, fh = frame:GetSize()

    NameChange.HeaderText(frame, fw * 0.02, fh * 0.16, Name_Changer.Language.MainMessageA)
    NameChange.HeaderText(frame, fw * 0.02, fh * 0.26, Name_Changer.Language.MainMessageB)
    NameChange.HeaderText(frame, fw * 0.02, fh * 0.36, Name_Changer.Language.MainMessageC)

    firstname = vgui.Create( "DTextEntry", frame )
    firstname:SetPos( fw * 0.30, fh * 0.5 )
    firstname:SetSize( fw * 0.4, fh * 0.1 )

    lastname = vgui.Create( "DTextEntry", frame )
    lastname:SetPos( fw * 0.30, fh * 0.64 )
    lastname:SetSize( fw * 0.4, fh * 0.1 )
	
	if Name_Changer.EnableGenerator then
		http.Fetch("https://uinames.com/api/?region=" .. Name_Changer.RegionName, function(body, len, headers, code)
			randomtable = util.JSONToTable(body)
			if not IsValid(firstname) or not IsValid(lastname) then return end
			
			if randomtable != nil then
				if randomtable['name'] != nil and randomtable['surname'] != nil then
					firstname:SetText(randomtable['name']) 
					lastname:SetText(randomtable['surname'])
				end
			else
				firstname:SetText(Name_Changer.Language.ExampleFirstName)
				lastname:SetText(Name_Changer.Language.ExampleLastName)
			end
			
			if code != 200 and code != 201 then
				chat.AddText(Name_Changer.TagColor, Name_Changer.Language.ChatTag .. " ", Name_Changer.MessageColor, Name_Changer.Language.TooManyRequests)
				firstname:SetText(Name_Changer.Language.ExampleFirstName)
				lastname:SetText(Name_Changer.Language.ExampleLastName)
			end
		end)
	else
		firstname:SetText(Name_Changer.Language.ExampleFirstName)
		lastname:SetText(Name_Changer.Language.ExampleLastName)
	end 
	
	local yes
	
	if LocalPlayer():GetNWBool("CharactersFirstAuth", true) then
		yes = NameChange.Button(frame, fw * 0.30, fh * 0.78, fw * 0.4, fh * 0.15, Name_Changer.Language.FirstButtonText)
	else
		yes = NameChange.Button(frame, fw * 0.30, fh * 0.78, fw * 0.4, fh * 0.15, Name_Changer.Language.ButtonText)
	end
    
    yes.DoClick = function()
        frame:Close() 
        net.Start( "Name_Changer:ChangeName" )
        net.WriteString( firstname:GetValue() )
        net.WriteString( lastname:GetValue() ) 
        net.SendToServer()
		
		surface.PlaySound("buttons/button14.wav")
    end
end)

net.Receive("Name_Changer:Chat", function()
	local message = net.ReadString()
	chat.AddText(Name_Changer.TagColor, Name_Changer.Language.ChatTag .. " ", Name_Changer.MessageColor, message)
end)

function ResetNameMenu()
	local xlen, ylen = 2000, 1100

	if IsValid(ResetCharMenu) then
		ResetCharMenu:Remove()
	end

	ResetCharMenu = vgui.Create("DFrame")
	ResetCharMenu:SetTitle("")
	ResetCharMenu:MakePopup()
	ResetCharMenu:SetSize(xlen * 0.18, ylen * 0.133)
	ResetCharMenu:SetPos(ScrW() - xlen / 2, ScrH() - ylen / 1.7)
	-- ResetCharMenu:Center()
	ResetCharMenu:ShowCloseButton(false)
	ResetCharMenu:SetDraggable(true)
	ResetCharMenu.Paint = function(self, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 210))
		draw.RoundedBox(4, 0, 0, w, h * 0.21, Color(0, 0, 0, 210))
		
		draw.SimpleText(Name_Changer.Language.SelectPlayerFrame, "NPCName_text_mini", w * 0.02, h * 0.045, Color(255, 255, 255, 255), 0, 0)
		draw.SimpleText(Name_Changer.Language.SelectPlayer, "NPCName_text", w * 0.23, h * 0.29, Color(255, 255, 255, 255), 1, 0)
		draw.SimpleText(Name_Changer.Language.SelectPlayerName, "NPCName_text", w * 0.23, h * 0.79, Color(255, 255, 255, 255), 1, 0)
	end

	local SelectPlayer = vgui.Create("DComboBox", ResetCharMenu)
	SelectPlayer:SetPos(xlen * 0.085, ylen * 0.035)
	SelectPlayer:SetSize(xlen * 0.085, ylen * 0.027)
	SelectPlayer:SetValue(Name_Changer.Language.SelectPlayer)
	SelectPlayer.OnSelect = function(self, _, _, data)
		-- net.Start("GetCharactersToSV")
			-- net.WriteEntity(data)
		-- net.SendToServer()
	end
	
	for k,v in pairs(player.GetAll()) do
		SelectPlayer:AddChoice(v:Name(), v)
	end
	
	
	
	firstname = vgui.Create( "DTextEntry", ResetCharMenu )
    firstname:SetPos( xlen * 0.085, ylen * 0.1)
    firstname:SetSize( xlen * 0.04, ylen * 0.027 )
	
	lastname = vgui.Create( "DTextEntry", ResetCharMenu )
    lastname:SetPos( xlen * 0.13, ylen * 0.1)
    lastname:SetSize( xlen * 0.04, ylen * 0.027 )
	
	notcoloreda = true

	local okbutton = vgui.Create("DButton", ResetCharMenu)
	okbutton:SetPos( xlen * 0.085, ylen * 0.067 )
	okbutton:SetSize( xlen * 0.085, ylen * 0.03 )
	okbutton:SetText( "Change" )
	okbutton:SetFont( "NPCName_button" )
	okbutton:SetColor( Color(240, 240, 240) )
	okbutton.Paint = function(self, w, h)
		if notcoloreda then
			draw.RoundedBox( 5, 0, 0, w, h, Color(0, 0, 0, 180)) 
		else
			draw.RoundedBox( 5, 0, 0, w, h, Color(0, 0, 0, 240)) 
		end
	end
	okbutton.DoClick = function()
		ResetCharMenu:Close()
	end
	
	okbutton.OnCursorEntered = function() 
		if notcoloreda then
			notcoloreda = false
		end
	end

	okbutton.OnCursorExited = function() 
		if not notcoloreda then
			notcoloreda = true
		end
	end
	
	okbutton.DoClick = function()
		if SelectPlayer:GetValue() == Name_Changer.Language.SelectPlayer then
			chat.AddText(Name_Changer.TagColor, Name_Changer.Language.ChatTag .. " ", Name_Changer.MessageColor, Name_Changer.Language.ResetBadList)
			
			surface.PlaySound("buttons/button11.wav")
		elseif #firstname:GetValue() > 1 and #lastname:GetValue() > 1 then
			net.Start( "Name_Changer:ResetName" )
				net.WriteString( firstname:GetValue() )
				net.WriteString( lastname:GetValue() )
				net.WriteString( SelectPlayer:GetValue() )
			net.SendToServer()
			
			surface.PlaySound("buttons/button14.wav")
			ResetCharMenu:Close() 
		else
			chat.AddText(Name_Changer.TagColor, Name_Changer.Language.ChatTag .. " ", Name_Changer.MessageColor, Name_Changer.Language.ResetBad)
			surface.PlaySound("buttons/button11.wav")
		end
    end
	
	notcolored = true

	local closeButton = vgui.Create("DButton", ResetCharMenu)
	closeButton:SetPos( xlen * 0.165, ylen * 0.003 )
	closeButton:SetSize( xlen * 0.015, ylen * 0.025 )
	closeButton:SetText( "" )
	closeButton:SetColor( Color(240, 240, 240) )
	closeButton.Paint = function(self, w, h)
		if notcolored then
			GNRotatedBox(w/2, h/2, 3, 15, 45)
			GNRotatedBox(w/2, h/2, 3, 15, -45)
		else
			GNRotatedBox(w/2, h/2, 3, 15, 45, 1)
			GNRotatedBox(w/2, h/2, 3, 15, -45, 1)
		end
	end
	closeButton.DoClick = function()
		ResetCharMenu:Close()
	end
	
	closeButton.OnCursorEntered = function() 
		if notcolored then
			notcolored = false
		end
	end

	closeButton.OnCursorExited = function() 
		if not notcolored then
			notcolored = true
		end
	end
end

function GNRotatedBox( x, y, w, h, ang, color )
	draw.NoTexture()
	if color == 1 then
		surface.SetDrawColor(Color(255, 0, 0))
	else
		surface.SetDrawColor(color or color_white)
	end
	
	surface.DrawTexturedRectRotated( x, y, w, h, ang )
end

NameChange = NameChange or {}
NameChange.Materials = NameChange.Materials or {}

NameChange.Materials.DownGradient = Material("gui/gradient_down")
NameChange.Materials.UpGradient = Material("gui/gradient_up")

--[[
-- Elements
]]--

-- Basic Frame.
function NameChange.Frame(x, y, w, h, title)
    local frame = vgui.Create("DFrame")
    frame:SetSize(w, h)
    frame:SetDraggable(false)
    frame:ShowCloseButton(false)
    frame:SetTitle("")
    frame.headerHeight = 30 -- math.Max(h * 0.1, 30)
    if(x == -1 && y == -1) then
        frame:Center()
    else
        frame:SetPos(x, y)
    end
    frame.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 1, w, h - 1, Name_Changer.Colors.FrameBG)

        surface.SetDrawColor(0, 0, 0)
        surface.SetMaterial(NameChange.Materials.DownGradient)
        surface.DrawTexturedRect(0, s.headerHeight * 0.9, w, s.headerHeight * 0.25)

        draw.RoundedBox(5, 0, 0, w, s.headerHeight, Name_Changer.Colors.FrameTop)
        draw.RoundedBox(0, 0, s.headerHeight / 2, w, s.headerHeight / 2, Name_Changer.Colors.FrameTop)

        if(Name_Changer.Colors.DarkMode == false) then
            surface.SetDrawColor(Name_Changer.Colors.FrameTop.r + 25, Name_Changer.Colors.FrameTop.g + 25, Name_Changer.Colors.FrameTop.b + 25)
            surface.SetMaterial(NameChange.Materials.UpGradient)
            surface.DrawTexturedRect(0, s.headerHeight / 2, w, s.headerHeight / 2)
        end

        draw.SimpleText(title, "NPCName_frametitle", w * 0.0225, s.headerHeight / 2, Name_Changer.Colors.FrameTitle, 0, 1)
    end
    frame:MakePopup()
    function frame:GetHeaderHeight()
        return frame.headerHeight
    end

    if not LocalPlayer():GetNWBool("CharactersFirstAuth", true) then
		local closeButton = vgui.Create("DButton", frame)
		closeButton:SetPos(frame:GetWide() * 0.9, 0)
		closeButton:SetSize(frame:GetWide() * 0.1, frame.headerHeight)
		closeButton:SetText("")
		closeButton.Paint = function(s, w, h)
			draw.SimpleText("x", "NPCName_frametitle", w / 2, h * 0.425, Name_Changer.Colors.FrameTitle, 1, 1)
		end
		closeButton.DoClick = function()
			frame:Close()
			surface.PlaySound("buttons/button15.wav")
		end
	end
	
    return frame
end

function NameChange.HeaderText(frame, x, y, text)
    local label = vgui.Create("DLabel", frame)
    label:SetPos(x, y)
    label:SetText(text)
    label:SetFont("NPCName_header")
    label:SetContentAlignment(7)
    label:SizeToContents()
    label:CenterHorizontal()
    label:SetColor(Name_Changer.Colors.Text)
    return label
end

function NameChange.Text(frame, x, y, text)
    local label = vgui.Create("DLabel", frame)
    label:SetPos(x, y)
    label:SetText(text)
    label:SetFont("NPCName_text")
    label:SizeToContents()
    label:SetColor(Name_Changer.Colors.Text)
    return label
end

function NameChange.Button(frame, x, y, w, h, text)
    local button = vgui.Create("DButton", frame)
    button:SetPos(x, y)
    button:SetSize(w, h)
    button:SetText("")
    button.Lerp = 0
    button.Paint = function(s, w, h)
        draw.RoundedBox(6, 0, 0, w, h, Name_Changer.Colors.Button)
        if(s:IsHovered()) then
            s.Lerp = Lerp(0.05, s.Lerp, 25)
        else
            s.Lerp = Lerp(0.05, s.Lerp, 0)
        end
        draw.RoundedBox(6, 0, 0, w, h, Color(255, 255, 255, s.Lerp))
        draw.SimpleText(text, "NPCName_button", w / 2, h / 2, Name_Changer.Colors.ButtonText, 1, 1)
    end
    return button
end

-- For FUTURE

-- function NameChange.ScrollPanel(frame, x, y, w, h)
    -- local scroll = vgui.Create("DScrollPanel", frame)
    -- scroll:SetPos(x, y)
    -- scroll:SetSize(w, h)

    -- local scrollBar = scroll:GetVBar()
    -- scrollBar:SetHideButtons(true)
    -- scrollBar:SetWide(frame:GetWide() * 0.01)
    -- scrollBar.Paint = function(s, w, h)

    -- end
    -- scrollBar.btnUp.Paint = function(s, w, h)

    -- end
    -- scrollBar.btnDown.Paint = function(s, w, h)

    -- end
    -- scrollBar.btnGrip.Paint = function(s, w, h)
        -- draw.RoundedBox(0, 0, 0, w, h, Name_Changer.Colors.FrameTop)
    -- end

    -- return scroll
-- end

-- function NameChange.ScrollItem(scroll, height)
    -- local panel = vgui.Create("DPanel", scroll)
    -- panel:Dock(TOP)
    -- panel:DockMargin(0, 0, 0, 5)
    -- panel:SetSize(scroll:GetWide(), height)
    -- panel.Paint = function(s, w, h)
        -- draw.RoundedBox(0, 0, 0, w, h, Name_Changer.Colors.PanelBG)
    -- end
    -- return panel
-- end

-- function NameChange.Switch(frame, x, y, w, h, defaultValue)
    -- local button = vgui.Create("DButton", frame)
    -- button:SetPos(x, y)
    -- button:SetSize(w, h)
    -- button:SetText("")
    -- button.Lerp = 0
    -- button.LerpR = 0
    -- button.LerpG = 0
    -- button.LerpB = 0
    -- button.value = defaultValue
    -- button.Paint = function(s, w, h)
        -- if(button.value == true) then
            -- button.Lerp = Lerp(0.05, button.Lerp, w - (w * 0.325))
            -- button.LerpR = Lerp(0.05, button.LerpR, Name_Changer.Colors.ToggleBackgroundOn.r)
            -- button.LerpG = Lerp(0.05, button.LerpG, Name_Changer.Colors.ToggleBackgroundOn.g)
            -- button.LerpB = Lerp(0.05, button.LerpB, Name_Changer.Colors.ToggleBackgroundOn.b)
        -- else
            -- button.Lerp = Lerp(0.05, button.Lerp, 0)
            -- button.LerpR = Lerp(0.05, button.LerpR, Name_Changer.Colors.ToggleBackground.r)
            -- button.LerpG = Lerp(0.05, button.LerpG, Name_Changer.Colors.ToggleBackground.g)
            -- button.LerpB = Lerp(0.05, button.LerpB, Name_Changer.Colors.ToggleBackground.b)
        -- end
        -- draw.RoundedBox(14, 0, 0, w, h, Color(button.LerpR, button.LerpG, button.LerpB))
        -- draw.RoundedBox(14, button.Lerp, 0, w * 0.325, h, Color(220, 220, 220))
    -- end
    -- return button
-- end

-- function NameChange.ComboBox(frame, x, y, w, h, defaultValue, fields)
    -- local box = vgui.Create("DComboBox", frame)
    -- box:SetPos(x, y)
    -- box:SetSize(w, h)
    -- for k,v in pairs(fields) do
        -- box:AddChoice(v)
    -- end
    -- box:SetValue(defaultValue)
    -- box.Paint = function(s, w, h)
        -- draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
        -- draw.RoundedBox(0, 1, 1, w - 2, h - 2, Name_Changer.Colors.ComboBox)
    -- end
    -- return box
-- end

-- function NameChange.CheckBox(frame, x, y, w, h, defaultValue)
    -- local box = vgui.Create("DCheckBox", frame)
    -- box:SetPos(x, y)
    -- box:SetSize(w, h)
    -- box:SetChecked(defaultValue)
    -- box.Lerp = 0
    -- box.Paint = function(s, w, h)
        -- draw.RoundedBox(5, 0, 0, w, h, Name_Changer.Colors.FrameTop)
        -- if(s:GetChecked() == true) then
            -- box.Lerp = Lerp(0.05, box.Lerp, 255)
        -- else
            -- box.Lerp = Lerp(0.05, box.Lerp, 0)
        -- end
        -- draw.SimpleText("✔", "NPCName_text", w / 2, h / 2, Color(255, 255, 255, box.Lerp), 1, 1) -- I can hear people screaming at me for using emojis instead of icons now....
    -- end
    -- return box
-- end

-- function NameChange.Notice(title, text)
    -- local frame = NameChange.Frame(-1, -1, ScrW() * 0.3, ScrH() * 0.075, title)
    -- NameChange.HeaderText(frame, frame:GetWide() * 0.025, frame:GetTall() * 0.5, text)
-- end

function NameChange.SetThemeColor(color)
    Name_Changer.Colors.FrameTop = color
    Name_Changer.Colors.Button = color
    Name_Changer.Colors.ToggleBackgroundOn = color
end

function NameChange.ResetTheme()
    Name_Changer.Colors.FrameTop = Color(0, 122, 107)
    Name_Changer.Colors.Button = Color(0, 122, 107)
    Name_Changer.Colors.ToggleBackgroundOn = Color(0, 122, 107)
end
 
if Name_Changer.Colors.DarkMode then
	Name_Changer.Colors.FrameTitle = Color(255, 255, 255)
	Name_Changer.Colors.Text = Color(255, 255, 255)
	Name_Changer.Colors.FrameBG = Color(25, 25, 25)
	Name_Changer.Colors.ButtonShadow = Color(255, 255, 255, 150)
	Name_Changer.Colors.ButtonText = Color(255, 255, 255)
	Name_Changer.Colors.PanelBG = Color(20, 20, 20)
	Name_Changer.Colors.ComboBox = Color(0, 0, 0)
 
	Name_Changer.Colors.ToggleBackgroundOn = Color(0, 122, 107)
	Name_Changer.Colors.FrameTop = Color(50, 50, 50)
	Name_Changer.Colors.Button = Color(50, 50, 50)
end
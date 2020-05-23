Name_Changer = {}
Name_Changer.Colors = {}
Name_Changer.Language = {}
Name_Changer.Admins = {} 

//Name Blacklist

Name_Changer.BadWordsEnable = true -- Enable the bad word checker
Name_Changer.BadWordsFullCheck = true -- Checks entire name for bad words, example: bad word is "heck", first name or last name Johnhecks will be forbidden because it contains word "heck"
Name_Changer.BadWords = {"ass", "lol", "wtf", "nigga", "n1gga", "suck", "d1ck", "dick", "penis", "cock", "fuck", "sex", "porn", "tit", "gay", "fuck", "kek", "adolf", "hitler", "hell", "cunt", "shit", "bastard", "nigga", "bitch"} -- Forbidden player names, bad words

//Name Generator

Name_Changer.EnableGenerator = true -- Enables name generator (true/false)
Name_Changer.RegionName = "england" -- Region for name genarator, example: england, spain, germany, france, poland, russia, india, china

//NPC Settings

Name_Changer.CostMoney = true --Should it cost money to change name your name at the NPC? (true/false)
Name_Changer.HowMuchCost = 1000 -- How much should it cost to change your name?
Name_Changer.NPCModel = "models/Humans/Group03/male_06.mdl" -- What model should the NPC have?

//Admin Settings
Name_Changer.Admins["superadmin"] = true -- Admins can use /name + /rpname and change players' name
Name_Changer.Admins["admin"] = true

//Other Settings
Name_Changer.TagColor = Color(255, 0, 0) -- Chat tag color
Name_Changer.MessageColor = Color(255, 255, 255) -- Chat message (after tag) color

Name_Changer.ResetCommand = "!resetname" -- Chat command for admins to change players' name


//Language

Name_Changer.Language.Title = "Server - Name creation" -- Title text (Bar)
Name_Changer.Language.MainMessageA = "Welcome to our server!" -- Main window text (Line1)
Name_Changer.Language.MainMessageB = "You need to create a" -- Main window text (Line2)
Name_Changer.Language.MainMessageC = "Roleplay name below" -- Main window text (Line3)
Name_Changer.Language.NPCOverhead = "Name NPC" -- Text above the name changing NPC
Name_Changer.Language.ButtonText = "Confirm - " .. Name_Changer.HowMuchCost .. "$" -- Button text in window
Name_Changer.Language.FirstButtonText = "Create" -- Button text on first player's join
Name_Changer.Language.ExampleFirstName = "First name" -- Default text in the name box (First name)
Name_Changer.Language.ExampleLastName = "Last name" --  Default text in the name box (Last name)
Name_Changer.Language.TooManyRequests = "Too many requests from name generator, wait or create own name!" --Error message name generator
Name_Changer.Language.SelectPlayerFrame = "Admin's name changer"
Name_Changer.Language.SelectPlayer = "Select a player"
Name_Changer.Language.SelectPlayerName = "First & Last name"
Name_Changer.Language.ResetSuccess = "Player's name has been changed!"
Name_Changer.Language.ResetBad = "First name or last name is too short, try again!"
Name_Changer.Language.ResetBadPly = "Player not found, try again!"
Name_Changer.Language.ResetBadList = "Choose player from list and try again!"
Name_Changer.Language.ResetDone = "Administrator changed your name:"
Name_Changer.Language.ChatTag = "[ANC]"
Name_Changer.Language.Success = "You have changed your name!"
Name_Changer.Language.ErrorF = "You need to fill the inputs correctly!"
Name_Changer.Language.ErrorU = "This name is already in use!"
Name_Changer.Language.ErrorBF = "Your first name is in the blacklist!"
Name_Changer.Language.ErrorBL = "Your last name is in the blacklist!"
Name_Changer.Language.ErrorNF = "There are forbidden characters in your first name."
Name_Changer.Language.ErrorNL = "There are forbidden characters in your last name."
Name_Changer.Language.ErrorTooLF = "Your first name is too long!"
Name_Changer.Language.ErrorTooLL = "Your last name is too long!"
Name_Changer.Language.ErrorTooSF = "Your first name is too short!"
Name_Changer.Language.ErrorTooSL = "Your last name is too short!"
Name_Changer.Language.ErrorA = "Find an NPC to change your name!"
Name_Changer.Language.Time = "You can change your name once every 30 seconds!"
Name_Changer.Language.Money = "You do not have enough money to change your name!"


//Design Settings

Name_Changer.RainbowNPCOverhead = true -- Rainbow title over the NPC's head (true/false)

if CLIENT then
	Name_Changer.Colors.DarkMode = true -- Enable / Disable Dark mode

	Name_Changer.Colors.FrameTitle = Color(255, 255, 255) -- Personal theme, can be used when the dark mode is disabled
	Name_Changer.Colors.Text = Color(0, 0, 0)
	Name_Changer.Colors.FrameBG = Color(250, 250, 250)
	Name_Changer.Colors.FrameTop = Color(200, 22, 22)
	Name_Changer.Colors.Button = Color(200, 22, 22)
	Name_Changer.Colors.ButtonShadow = Color(0, 0, 0, 150)
	Name_Changer.Colors.ButtonText = Color(255, 255, 255)
	Name_Changer.Colors.PanelBG = Color(242, 242, 242)
	Name_Changer.Colors.ToggleBackground = Color(75, 75, 75)
	Name_Changer.Colors.ToggleBackgroundOn = Color(0, 122, 107)
	Name_Changer.Colors.ComboBox = Color(255, 255, 255)

//Fonts

	surface.CreateFont("NPCName_overheadtext", { -- NPC Overhead Font
		font = "Roboto",
		size = ScrH() * 0.06,
		weight = 1500
	})

	surface.CreateFont("NPCName_frametitle", { -- GUI (Window) fonts below
		font = "Roboto",
		size = ScrH() * 0.025
	})

	surface.CreateFont("NPCName_header", {
		font = "Roboto",
		size = ScrH() * 0.03
	})

	surface.CreateFont("NPCName_text", { 
		font = "Roboto",
		size = ScrH() * 0.02
	})
	
	surface.CreateFont("NPCName_text_mini", { 
		font = "Roboto",
		size = ScrH() * 0.019
	})

	surface.CreateFont("NPCName_button", {
		font = "Roboto",
		size = ScrH() * 0.025
	})

end
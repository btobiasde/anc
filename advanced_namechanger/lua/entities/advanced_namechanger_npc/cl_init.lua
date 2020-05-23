include("shared.lua")

local NPCColor = Color(255, 255, 255, 255)
local NPCColorTimer = 0

local H, S, L = 0, 240, 120
local R, G, B = 0, 0, 0
local k

function ColorRandom()
	local r, g, b = HSLtoRGB(H,S,L)
	
	H = H + 1
	if H > 240 then H = 0 end
	
	NPCColor = Vector(r, g, b, 255)
end

function HSLtoRGB(H, S, L)
    -- R, G, B = 0, 0, 0
    if H < 80 then
        R = math.min(255, 255 * (80 - H) / 40)
    elseif H > 160 then
        R = math.min(255, 255 * (H - 160) / 40)
    end
    if H < 160 then
        G = math.min(255, 255 * (80 - math.abs(H - 80)) / 40)
    end
    if H > 80 then
        B = math.min(255, 255 * (80 - math.abs(H - 160)) / 40)
    end
    if S < 240 then
        k = S / 240
        -- R, G, B = R*k, G*k, B*k
        k = 128 * (240 - S) / 240
        R, G, B = R+k, G+k, B+k
    end
    k = (120 - math.abs(L - 120)) / 120
    R, G, B = R*k, G*k, B*k
    if L > 120 then
        k = 256 * (L - 120) / 120
        R, G, B = R+k, G+k, B+k
    end
    return R, G, B
end

function ENT:Initalize()
	self.AutomaticFrameAdvance = true
end

function ENT:Draw()
	self:DrawModel()

    local ang = self:GetAngles()
    local lpos = Vector(0, 0, 80)
    local pos = self:LocalToWorld(lpos)
    ang:RotateAroundAxis(self:GetAngles():Forward(), 90)
    ang:RotateAroundAxis(self:GetAngles():Up(), 90)
	eye_angles = LocalPlayer():EyeAngles()
	ang = Angle(0, eye_angles.y - 90, -eye_angles.p - 270)
	
	if Name_Changer.RainbowNPCOverhead then
		if NPCColorTimer < CurTime() then
			ColorRandom()
			NPCColorTimer = CurTime() + 0.02
		end
	end

	cam.Start3D2D(pos, ang, 0.1)
		draw.SimpleText(Name_Changer.Language.NPCOverhead, "NPCName_overheadtext", 0, 20, NPCColor, 1, 2)
	cam.End3D2D()
end
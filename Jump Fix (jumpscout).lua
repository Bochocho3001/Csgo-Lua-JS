local bit = require("bit")

local weapons = Menu.MultiCombo("Jump Fix", "Active Weapons", {"Knife", "Nades", "Scout", "Awp", "Autsniper", "Pistol", "Heavy Pistol", "Global"}, 0, "Deactivates Auto Strafe When Jumping With The Selected Weapons")
local hc_on = Menu.Switch("Jump Fix", "Override Hitchance", false)
local hc = Menu.SliderInt("Jump Fix", "Hitchance On Jump", 0, 0, 100)

hc_on:RegisterCallback(function()
    hc:SetVisible()
end)

local auto_strafe = Menu.FindVar("Miscellaneous", "Main", "Movement", "Auto Strafe")

local velocity = function(entity)
    local velocity_x = entity:GetProp("m_vecVelocity[0]")
    local velocity_y = entity:GetProp("m_vecVelocity[1]")
    return math.sqrt(velocity_x * velocity_x + velocity_y * velocity_y)
end

function jump_fix()
    local me = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
    if me == nil then return end
    local weap = me:GetActiveWeapon()
	if weap == nil then return end
    local weap_id = weap:GetClassId()
    local weapon_list = {
        is_knife = weap:IsKnife(),
        is_nade = weap:IsGrenade(),
        is_ssg = weap_id == 267,
        is_awp = weap_id == 233,
        is_auto = weap_id == 242 or weap_id == 261,
        is_pistol = weap:IsPistol(),
        is_heavy_pistol = weap_id == 46,
        is_gun = weap:IsGun(),
    }

    local player = EntityList.GetLocalPlayer()
    if player == nil then return end

    if velocity(player) < 5 then
        for i in weapon_list do
            if weapons:Get(i) then
                auto_strafe:Set(false)
                return
            end
        end
    end
    auto_strafe:Set(true)
end

function jump_hitchance()
    if not hc_on:GetBool() then return end
    local player = EntityList.GetLocalPlayer()
    if player == nil then return end
		
    if velocity(player) < 10 and bit.band(player:GetProp("m_fFlags"), 1) ~= 1 then
        for i = 1, 64 do
            RageBot.OverrideHitchance(i , hc:GetInt())
        end
    end
end

Cheat.RegisterCallback("createmove", function ()
    jump_hitchance()
    jump_fix()
end)
